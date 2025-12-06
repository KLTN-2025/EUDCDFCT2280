import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ecolive/localization/locales.dart';
import 'package:ecolive/localization/translator.dart';
import 'package:share_plus/share_plus.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key}); // Thêm const

  @override
  // ignore: library_private_types_in_public_api
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 1, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _shareProfile() {
    String shareText = "Check out my profile on our app! \n\n"
        "Name: ${user?.displayName ?? "No Name"} \n"
        "Email: ${user?.email ?? "No Email"}";

    Share.share(shareText);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr(LocaleData.profile)),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _shareProfile,
          )
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(icon: const Icon(Icons.feed), text: tr(LocaleData.feeds)),
          ],
        ),
      ),
      body: Column(
        children: [
          // Profile Section
          Container(
            width: double.infinity, // ✨ Chiếm toàn bộ chiều ngang để canh giữa
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor, // ✨ Thêm màu nền nhẹ nếu cần
              border: Border(
                  bottom: BorderSide(
                      color: Colors.grey.shade300)), // ✨ Đường kẻ ngăn cách
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center, // ✨ Canh giữa
              children: [
                // ✨ 1. AVATAR ĐẸP HƠN
                Container(
                  width: 120, // Kích thước bao ngoài (Radius * 2)
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: Colors.blueAccent, width: 3), // ✨ Viền xanh
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5), // ✨ Đổ bóng nhẹ
                      )
                    ],
                  ),
                  child: ClipOval(
                    // ✨ Cắt ảnh hình tròn
                    child: user?.photoURL != null
                        ? Image.network(
                            user!.photoURL!,
                            fit: BoxFit.cover, // ✨ Ảnh lấp đầy khung tròn
                            width: 120,
                            height: 120,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const Center(
                                  child: CircularProgressIndicator());
                            },
                            errorBuilder: (context, error, stackTrace) =>
                                Image.asset("assets/default_avatar.png",
                                    fit: BoxFit.cover),
                          )
                        : Image.asset(
                            "assets/default_avatar.png",
                            fit: BoxFit.cover,
                            width: 120,
                            height: 120,
                          ),
                  ),
                ),

                const SizedBox(height: 16), // ✨ Tăng khoảng cách

                // ✨ 2. TÊN TO HƠN
                Text(
                  user?.displayName ?? "No Name",
                  style: const TextStyle(
                    fontSize: 22, // ✨ To hơn (cũ là 18)
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5, // Khoảng cách chữ rộng xíu cho sang
                  ),
                ),

                const SizedBox(height: 4), // Khoảng cách nhỏ giữa Tên và Mail

                // ✨ 3. EMAIL RÕ HƠN
                Text(
                  user?.email ?? "No Email",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[700], // ✨ Màu xám đậm hơn cho dễ đọc
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
