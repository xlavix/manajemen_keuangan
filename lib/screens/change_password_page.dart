import 'package:flutter/material.dart';
import '../database/db_helper.dart';

class ChangePasswordPage extends StatefulWidget {
  final String username;

  const ChangePasswordPage({super.key, required this.username});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  final DBHelper _dbHelper = DBHelper();

  void _changePassword() async {
    final oldPassword = oldPasswordController.text.trim();
    final newPassword = newPasswordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (oldPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      _showDialog("Error", "Semua field wajib diisi");
      return;
    }

    final user = await _dbHelper.getUserByUsername(widget.username);

    if (user == null || user.password != oldPassword) {
      _showDialog("Error", "Password lama salah");
      return;
    }

    if (newPassword != confirmPassword) {
      _showDialog("Error", "Konfirmasi password tidak cocok");
      return;
    }

    await _dbHelper.updateUserProfile(
      oldUsername: widget.username,
      newUsername: widget.username,
    );

    // Update password manual (karena updateUserProfile tidak ubah password)
    final db = await _dbHelper.database;
    await db.update(
      'users',
      {'password': newPassword},
      where: 'username = ?',
      whereArgs: [widget.username],
    );

    _showDialog("Sukses", "Password berhasil diubah", success: true);
  }

  void _showDialog(String title, String message, {bool success = false}) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              if (success) Navigator.pop(context);
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        backgroundColor: Colors.blue[50],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Ubah Password", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _inputField(oldPasswordController, "Password Lama", isPassword: true),
            const SizedBox(height: 16),
            _inputField(newPasswordController, "Password Baru", isPassword: true),
            const SizedBox(height: 16),
            _inputField(confirmPasswordController, "Konfirmasi Password Baru", isPassword: true),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _changePassword,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 40),
              ),
              child: const Text("Simpan", style: TextStyle(fontSize: 16)),
            )
          ],
        ),
      ),
    );
  }

  Widget _inputField(TextEditingController controller, String hint, {bool isPassword = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(hintText: hint, border: InputBorder.none),
      ),
    );
  }
}
