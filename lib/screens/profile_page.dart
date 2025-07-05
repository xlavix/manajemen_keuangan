import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../screens/login_page.dart';
import 'edit_profile_page.dart';
import 'connection_page.dart';
import 'change_password_page.dart';

class ProfilePage extends StatefulWidget {
  final String username;
  final VoidCallback? onBack;
  // Tambahkan callback untuk melapor ke HomePage
  final Function(String newUsername)? onProfileUpdated;

  const ProfilePage({
    super.key,
    required this.username,
    this.onBack,
    this.onProfileUpdated, // Tambahkan ini di constructor
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isDarkMode = false;
  Uint8List? _photoBytes;
  final DBHelper _dbHelper = DBHelper();

  // 'currentUsername' untuk menampilkan di UI halaman ini
  late String currentUsername;

  @override
  void initState() {
    super.initState();
    // Inisialisasi username lokal dengan data dari widget
    currentUsername = widget.username;
    _loadUserImage();
  }

  // Tambahkan ini untuk update state jika widget direbuild dgn username baru
  @override
  void didUpdateWidget(covariant ProfilePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.username != oldWidget.username) {
      setState(() {
        currentUsername = widget.username;
      });
      _loadUserImage();
    }
  }

  Future<void> _loadUserImage() async {
    // Gunakan 'currentUsername' yang sudah terupdate
    final user = await _dbHelper.getUserByUsername(currentUsername);
    if (user != null && user.photo != null) {
      if (mounted) {
        setState(() {
          _photoBytes = user.photo;
        });
      }
    }
  }

  void _navigateToEditProfile() async {
    // Tangkap hasil (username baru) dari EditProfilePage
    final newUsernameResult = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditProfilePage(username: currentUsername),
      ),
    );

    // Jika ada username baru yang dikembalikan (artinya user menekan simpan)
    if (newUsernameResult is String) {
      // 1. Laporkan username baru ke HomePage
      if (widget.onProfileUpdated != null) {
        widget.onProfileUpdated!(newUsernameResult);
      }
      // 2. Update UI di halaman ini
      setState(() {
        currentUsername = newUsernameResult;
      });
      // 3. Muat ulang gambar (mungkin saja ikut berubah)
      _loadUserImage();
    } else {
      // Jika tidak ada hasil, mungkin hanya foto yang diubah
      _loadUserImage();
    }
  }

  void _confirmDeleteAccount(BuildContext context) {
    // ... (kode Anda tidak diubah) ...
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Hapus Akun"),
        content: const Text("Apakah Anda yakin ingin menghapus akun ini secara permanen?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Hapus Akun"),
            onPressed: () async {
              await _dbHelper.deleteUserByUsername(widget.username);
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
    // ... (kode Anda tidak diubah) ...
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Apakah Anda ingin keluar?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
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
    // ... (kode Anda tidak diubah) ...
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        leading: Icon(icon, color: iconColor ?? Colors.black),
        title: Text(
          title,
          style: TextStyle(color: textColor ?? Colors.black, fontWeight: FontWeight.w500),
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
              widget.onBack!();
            } else {
              Navigator.pop(context);
            }
          },
        ),
        title: Text("Akun", style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
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
                    backgroundColor: Colors.grey[300],
                    backgroundImage: _photoBytes != null ? MemoryImage(_photoBytes!) : null,
                    child: _photoBytes == null
                        ? const Icon(Icons.person, size: 50, color: Colors.white)
                        : null,
                  ),
                  const SizedBox(height: 12),
                  // Tampilkan username dari state lokal
                  Text(currentUsername,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor)),
                  const SizedBox(height: 8),
                  Text("${currentUsername}@example.com",
                      style: TextStyle(color: isDarkMode ? Colors.grey[400] : Colors.grey)),
                ],
              ),
            ),
            const SizedBox(height: 32),
            _buildOption(
              icon: Icons.edit,
              title: "Edit Profil",
              onTap: _navigateToEditProfile, // <-- PANGGIL FUNGSI YANG BARU
            ),
            _buildOption(
              icon: Icons.lock_outline,
              title: "Ubah Password",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ChangePasswordPage(username: currentUsername)),
                );
              },
            ),
            _buildOption(
              icon: Icons.link,
              title: "Sambungkan",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ConnectionPage(username: currentUsername),
                  ),
                );
              },
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