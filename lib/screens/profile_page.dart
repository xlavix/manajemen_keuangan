import 'package:flutter/material.dart';
import 'package:uas_pbm/database/db_helper.dart';
import 'package:uas_pbm/screens/login_page.dart';

class ProfilePage extends StatefulWidget {
  final String username;
  final VoidCallback? onBack;

  const ProfilePage({
    super.key,
    required this.username,
    this.onBack,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isDarkMode = false;

  void _confirmDeleteAccount(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Hapus Akun"),
        content: const Text("Apakah Anda yakin ingin menghapus akun ini secara permanen?"),
        actions: [
          TextButton(
            child: const Text("Batal"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Hapus Akun"),
            onPressed: () async {
              final db = DBHelper();
              await db.deleteUserByUsername(widget.username);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
                    (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }

  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Apakah Anda ingin keluar?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
                    (route) => false,
              );
            },
            child: const Text("Logout"),
          ),
        ],
      ),
    );
  }

  Widget _buildOption({
    required IconData icon,
    required String title,
    Color? iconColor,
    Color? textColor,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        leading: Icon(icon, color: iconColor ?? Colors.black),
        title: Text(
          title,
          style: TextStyle(
            color: textColor ?? Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isDarkMode ? Colors.grey[900] : Colors.blue[50];
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () {
            if (widget.onBack != null) {
              widget.onBack!(); // callback ke HomePage
            } else {
              Navigator.pop(context);
            }
          },
        ),
        title: Text(
          "Akun",
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: isDarkMode ? Colors.grey[800] : Colors.blue,
                    child: const Icon(Icons.person, size: 50, color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.username,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "${widget.username}@example.com",
                    style: TextStyle(color: isDarkMode ? Colors.grey[400] : Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            _buildOption(
              icon: Icons.lock_outline,
              title: "Ubah Password",
              onTap: () {},
            ),
            _buildOption(
              icon: Icons.dark_mode_outlined,
              title: "Dark Mode",
              trailing: Switch.adaptive(
                value: isDarkMode,
                onChanged: (value) {
                  setState(() => isDarkMode = value);
                },
              ),
              onTap: () {},
            ),
            _buildOption(
              icon: Icons.logout,
              title: "Logout",
              iconColor: Colors.red,
              textColor: Colors.red,
              onTap: () => _logout(context),
            ),
            _buildOption(
              icon: Icons.delete_forever,
              title: "Hapus Akun",
              iconColor: Colors.red,
              textColor: Colors.red,
              onTap: () => _confirmDeleteAccount(context),
            ),
          ],
        ),
      ),
    );
  }
}
