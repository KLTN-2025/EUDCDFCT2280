import 'dart:io';
import 'dart:convert'; // For jsonDecode
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart'; // To find download path
import 'package:permission_handler/permission_handler.dart'; // To request permissions
// Optional: For showing messages easily
import 'package:flutter/foundation.dart' show kIsWeb; // To check platform

class FileUploadScreen extends StatefulWidget {
  const FileUploadScreen({super.key});
  @override
  State<FileUploadScreen> createState() => _FileUploadScreenState();
}

class _FileUploadScreenState extends State<FileUploadScreen> {
  File? _selectedFile;
  String _statusMessage = 'Please select a DOCX file to optimize.';
  bool _isProcessing = false; // Covers picking and uploading/processing

  // --- Results State ---
  bool _showResults = false;
  int _savingsInk = 0;
  int _savingsPages = 0;
  String? _processedFilename; // Filename on the server for download
  String? _originalFilename;

  // --- Backend URL ---
  // Use 10.0.2.2 for Android Emulator accessing host localhost
  // Use actual IP for physical devices or iOS Simulator
  final String _baseBackendUrl = kIsWeb
      ? "http://localhost:5000" // For web testing (if backend allows CORS)
      : Platform.isAndroid
          ? "http://10.0.2.2:5000" // Android Emulator default localhost
          // Make sure this IP is correct for your backend server
          : "http://172.22.184.237:5000"; // Replace with your PC's network IP for physical device/iOS Sim

  String get _uploadUrl => "$_baseBackendUrl/api/upload";
  String get _downloadUrlBase => "$_baseBackendUrl/api/download";

  // --- Function to request storage permission ---
  Future<bool> _requestPermission() async {
    // Added kIsWeb check
    if (kIsWeb || !(Platform.isAndroid || Platform.isIOS)) {
      // ignore: avoid_print
      print("Permissions: Not required for this platform."); // Log output
      return true; // No permissions needed for web/desktop (usually)
    }

    // --- Log status BEFORE requesting ---
    PermissionStatus initialStatus = await Permission.storage.status;

    // --- THIS LINE BELOW PRINTS THE INITIAL STATUS ---
    // ignore: avoid_print
    print("Permissions: Initial storage status = $initialStatus");

    // If already granted, just return true
    if (initialStatus.isGranted) {
      // ignore: avoid_print
      print("Permissions: Already granted."); // Log output
      return true;
    }

    // Request the permission
    // --- THIS LINE BELOW PRINTS A MESSAGE ---
    // ignore: avoid_print
    print("Permissions: Requesting storage permission...");
    PermissionStatus status = await Permission.storage.request();
    // --- THIS LINE BELOW PRINTS THE STATUS AFTER TRYING TO REQUEST ---
    // ignore: avoid_print
    print("Permissions: Status AFTER request = $status");

    if (status.isGranted) {
      // ignore: avoid_print
      print("Permissions: Granted successfully after request."); // Log output
      return true;
    } else if (status.isPermanentlyDenied) {
      // --- THIS LINE BELOW PRINTS IF PERMANENTLY DENIED ---
      // ignore: avoid_print
      print("Permissions: Permanently denied. Opening app settings...");
      await openAppSettings();
      _showSnackBar(
          "Storage permission permanently denied. Please enable it in settings.",
          isError: true);
      return false;
    } else {
      // --- THIS LINE BELOW PRINTS IF DENIED (BUT NOT PERMANENTLY) ---
      // ignore: avoid_print
      print("Permissions: Denied after request (not permanently).");
      _showSnackBar("Storage permission denied.", isError: true);
      return false;
    }
  }

  // --- Function to pick a file ---
  Future<void> _pickFile() async {
    // ignore: avoid_print
    print("Permissions: ...");
    if (_isProcessing) return;
    setState(() {
      _isProcessing = true;
      _statusMessage = "Picking file...";
      _showResults = false;
    });

    // Request permission before picking
    if (!await _requestPermission()) {
      setState(() {
        _isProcessing = false;
        _statusMessage = "Storage permission required.";
      });
      return;
    }

    try {
      // ignore: avoid_print
      print("Permissions: ...");
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['docx'], // Only allow docx for now
      );

      if (result != null && result.files.single.path != null) {
        setState(() {
          _selectedFile = File(result.files.single.path!);
          _statusMessage = 'File selected. Ready to upload.';
          _processedFilename = null; // Clear previous results
          _originalFilename = null;
        });
      } else {
        setState(() {
          _statusMessage = 'File selection cancelled.';
          _selectedFile = null; // Ensure file is cleared if cancelled
        });
      }
    } catch (e) {
      // ignore: avoid_print
      print("Error picking file: $e");
      setState(() {
        _statusMessage = 'Error picking file: $e';
      });
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  // --- Function to upload and process the file ---
  Future<void> _uploadAndProcessFile() async {
    // ignore: avoid_print
    print("Permissions: ...");
    if (_selectedFile == null) {
      _showSnackBar('Please select a file first.', isError: true);
      return;
    }
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
      _statusMessage = 'Uploading and processing...';
      _showResults = false; // Hide previous results
    });

    try {
      var request = http.MultipartRequest('POST', Uri.parse(_uploadUrl));
      request.files
          .add(await http.MultipartFile.fromPath('file', _selectedFile!.path));

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        setState(() {
          _statusMessage = responseData['message'] ?? 'Processing Complete!';
          _savingsInk = responseData['savings']?['inkPercent'] ?? 0;
          _savingsPages = responseData['savings']?['pagesSaved'] ?? 0;
          _processedFilename =
              responseData['processedFilename']; // Get filename for download
          _originalFilename = responseData['originalFilename'];
          _showResults = true; // Show the results section
        });
        _showSnackBar("Processing Successful!", isError: false);
      } else {
        var errorMsg = 'Upload/Processing failed!';
        try {
          // Try to parse error message from backend
          var responseData = jsonDecode(response.body);
          errorMsg += '\nServer: ${responseData['error'] ?? response.body}';
        } catch (_) {
          // Use raw body if JSON parsing fails
          errorMsg += '\nServer: (${response.statusCode}) ${response.body}';
        }
        setState(() {
          _statusMessage = errorMsg;
        });
        _showSnackBar(errorMsg, isError: true);
      }
    } catch (e) {
      // ignore: avoid_print
      print("Error during upload/process: $e");
      setState(() {
        _statusMessage = 'Error: $e';
      });
      _showSnackBar('An error occurred: $e', isError: true);
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  // --- Function to download the processed file ---
  Future<void> _downloadFile() async {
    // ignore: avoid_print
    print("Permissions: ...");
    if (_processedFilename == null) {
      _showSnackBar("No processed file available to download.", isError: true);
      return;
    }
    if (_isProcessing) return; // Prevent concurrent operations

    // Request permission before downloading
    if (!await _requestPermission()) {
      _showSnackBar("Storage permission is required to download.",
          isError: true);
      return;
    }

    setState(() {
      _isProcessing = true;
      _statusMessage = "Downloading...";
    });

    try {
      final downloadUrl = '$_downloadUrlBase/$_processedFilename';
      final response = await http.get(Uri.parse(downloadUrl));

      if (response.statusCode == 200) {
        // Find the downloads directory
        // Note: getExternalStorageDirectory() is often preferred but might need more setup/permissions.
        // getApplicationDocumentsDirectory() saves within the app's space.
        // Let's try for a more accessible Downloads dir if possible.
        Directory? downloadsDir;
        if (Platform.isAndroid) {
          // On Android, try to get the external downloads directory
          downloadsDir =
              await getExternalStorageDirectory(); // Often requires MANAGE_EXTERNAL_STORAGE or legacy request
          // Fallback if external storage is not available or suitable
          if (downloadsDir == null) {
            downloadsDir = await getApplicationDocumentsDirectory();
            _showSnackBar(
                "Could not access external downloads dir, saving to app folder.",
                isError: false);
          } else {
            // Construct path to standard 'Download' folder if possible (may not exist)
            String downloadDirPath =
                '/storage/emulated/0/Download'; // Common path, but not guaranteed
            downloadsDir = Directory(downloadDirPath);
            // Check if it exists, if not, fallback to external storage dir or app doc dir
            if (!await downloadsDir.exists()) {
              downloadsDir = await getExternalStorageDirectory() ??
                  await getApplicationDocumentsDirectory();
            }
          }
        } else if (Platform.isIOS) {
          // On iOS, save to application documents directory
          downloadsDir = await getApplicationDocumentsDirectory();
        } else {
          // Other platforms (Desktop, etc.) - use downloads directory if available
          downloadsDir = await getDownloadsDirectory();
        }

        if (downloadsDir == null) {
          throw Exception("Could not determine downloads directory.");
        }

        final filePath = '${downloadsDir.path}/$_processedFilename';
        final file = File(filePath);

        // Write the file
        await file.writeAsBytes(response.bodyBytes);

        // ignore: avoid_print
        print('File downloaded to: $filePath');
        setState(() {
          _statusMessage = 'File downloaded successfully!\nPath: $filePath';
        });
        _showSnackBar('File downloaded to: ${downloadsDir.path}',
            isError: false);
      } else {
        var errorMsg = 'Download failed!';
        try {
          // Try to parse error message from backend
          var responseData = jsonDecode(response.body);
          errorMsg += '\nServer: ${responseData['error'] ?? response.body}';
        } catch (_) {
          // Use raw body if JSON parsing fails
          errorMsg += '\nServer: (${response.statusCode}) ${response.body}';
        }
        setState(() {
          _statusMessage = errorMsg;
        });
        _showSnackBar(errorMsg, isError: true);
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error downloading file: $e');
      setState(() {
        _statusMessage = 'Error downloading file: $e';
      });
      _showSnackBar('Error downloading file: $e', isError: true);
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  // --- Helper to show snackbar messages ---
  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return; // Check if the widget is still in the tree
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.redAccent : Colors.green,
      ),
    );
  }

  // --- Build Method ---
  @override
  Widget build(BuildContext context) {
    final String fileName =
        _selectedFile?.path.split(Platform.pathSeparator).last ??
            'No file selected';

    return Scaffold(
      appBar: AppBar(
        title: const Text('EcoFont Processor'),
      ),
      body: SingleChildScrollView(
        // Allow scrolling if content overflows
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton.icon(
                icon: const Icon(Icons.file_open),
                label: const Text('1. Pick DOCX File'),
                onPressed: _isProcessing ? null : _pickFile,
                style:
                    ElevatedButton.styleFrom(minimumSize: const Size(200, 50)),
              ),
              const SizedBox(height: 15),
              Text(fileName, textAlign: TextAlign.center),
              const SizedBox(height: 25),

              ElevatedButton.icon(
                icon: const Icon(Icons.cloud_upload),
                label: const Text('2. Optimize File'),
                onPressed: (_selectedFile == null || _isProcessing)
                    ? null
                    : _uploadAndProcessFile,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    minimumSize: const Size(200, 50)),
              ),
              const SizedBox(height: 25),

              // --- Status and Results Area ---
              if (_isProcessing)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  child: CircularProgressIndicator(),
                ),

              Text(
                _statusMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _statusMessage.contains('Error') ||
                          _statusMessage.contains('failed')
                      ? Colors.red
                      : (_showResults
                          ? Colors.blueGrey[700]
                          : Colors.grey[
                              600]), // Different color for results vs intermediate status
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),

              // --- Show Results Section ---
              if (_showResults && _processedFilename != null) ...[
                Card(
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Optimization Results:",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        Text("Original File: $_originalFilename"),
                        Text("Processed File: $_processedFilename"),
                        const SizedBox(height: 15),
                        Text("Ink Saved: ~$_savingsInk%",
                            style: const TextStyle(
                                fontSize: 16, color: Colors.green)),
                        Text("Pages Saved: $_savingsPages",
                            style: const TextStyle(
                                fontSize: 16,
                                color: Colors.green)), // Will be 0 for now
                        const SizedBox(height: 20),
                        Center(
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.download),
                            label: const Text("Download Optimized File"),
                            onPressed: _isProcessing
                                ? null
                                : _downloadFile, // Disable while downloading
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                minimumSize: const Size(220, 50)),
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Placeholder for Print Button (requires downloaded PDF typically)
                        // Center(
                        //   child: ElevatedButton.icon(
                        //      icon: const Icon(Icons.print),
                        //      label: const Text("Print Optimized PDF"),
                        //      onPressed: null, // Implement printing logic later
                        //      style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
              ] // End of results section
            ],
          ),
        ),
      ),
    );
  }
}
