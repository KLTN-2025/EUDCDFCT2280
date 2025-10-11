import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_change_md/view/internet_provider.dart';

// ignore: use_key_in_widget_constructors
class CheckingInternet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<InternetProvider>(
      builder: (context, internetProvider, child) {
        if (internetProvider.isConnected) {
          Future.microtask(() {
            Navigator.pop(
                // ignore: use_build_context_synchronously
                context); // Quay lại màn hình trước đó khi có Internet
          });
        }

        return Scaffold(
          body: SizedBox(
            width: MediaQuery.sizeOf(context).width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  internetProvider.isConnected ? Icons.wifi : Icons.wifi_off,
                  size: 50,
                  color:
                      internetProvider.isConnected ? Colors.green : Colors.red,
                ),
                // ignore: prefer_const_constructors
                SizedBox(height: 30),
                Text(
                  internetProvider.isConnected
                      ? "Connected"
                      : "Check your WI-FI, Mobile Data or SIM Signal is slowed",
                  // ignore: prefer_const_constructors
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
