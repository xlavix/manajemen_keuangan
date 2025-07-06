import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../database/db_helper.dart';

class EditProfilePage extends StatefulWidget {
  final String username;
  const EditProfilePage({super.key, required this.username});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final ImagePicker _picker = ImagePicker();
  final DBHelper _dbHelper = DBHelper();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController(); // <-- TAMBAHKAN INI
  Uint8List? _profileImageBytes;
  String _selectedColor = 'blue';
  bool isDarkMode = false;
  late String _initialUsername;

  final Map<String, Color> _colorOptions = {
    'blue': Colors.blue, 'green': Colors.green, 'purple': Colors.purple, 'orange': Colors.orange, 'red': Colors.red,
  };

  @override
  void initState() {
    super.initState();
    _initialUsername = widget.username;
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = await _dbHelper.getUserByUsername(widget.username);
    if (user != null) {
      _usernameController.text = user.username;
      _emailController.text = user.email ?? ''; // <-- MUAT DATA EMAIL
      _profileImageBytes = user.photo;
      _selectedColor = user.colorTheme ?? 'blue';
      setState(() {});
    }
  }

  Future<void> _pickImage() async {
    final XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage == null) return;
    final bytes = await pickedImage.readAsBytes();
    await _dbHelper.updateUserPhoto(_initialUsername, bytes);
    if (mounted) setState(() => _profileImageBytes = bytes);
  }

  Future<void> _removeImage() async {
    await _dbHelper.updateUserPhoto(_initialUsername, null);
    if (mounted) setState(() => _profileImageBytes = null);
  }

  Future<void> _saveChanges() async {
    final newUsername = _usernameController.text.trim();
    final newEmail = _emailController.text.trim(); // <-- AMBIL DATA EMAIL BARU

    if (newUsername.isEmpty || newEmail.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Username dan Email tidak boleh kosong")));
      return;
    }

    try {
      await _dbHelper.updateUserProfile(
        oldUsername: _initialUsername,
        newUsername: newUsername,
        newEmail: newEmail, // <-- KIRIM EMAIL BARU UNTUK DISIMPAN
        newColorTheme: _selectedColor,
      );

      if (!mounted) return;
      Navigator.pop(context, newUsername);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gagal menyimpan: ${e.toString()}")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color selectedColorValue = _colorOptions[_selectedColor] ?? Colors.blue;
    final backgroundColor = isDarkMode ? Colors.grey[900] : Colors.blue[50];
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new), onPressed: () => Navigator.pop(context)),
        title: Text("Edit Profil", style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Center(
            child: Column(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: _profileImageBytes != null ? MemoryImage(_profileImageBytes!) : null,
                      child: _profileImageBytes == null ? const Icon(Icons.person, size: 50, color: Colors.white) : null,
                    ),
                    Positioned(
                      bottom: 0, right: 0,
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          decoration: BoxDecoration(color: selectedColorValue, shape: BoxShape.circle),
                          padding: const EdgeInsets.all(6),
                          child: const Icon(Icons.edit, color: Colors.white, size: 18),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(_usernameController.text, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor)),
                const SizedBox(height: 8),
                Text(_emailController.text, style: TextStyle(color: isDarkMode ? Colors.grey[400] : Colors.grey)),
              ],
            ),
          ),
          const SizedBox(height: 32),
          if (_profileImageBytes != null)
            TextButton.icon(onPressed: _removeImage, icon: const Icon(Icons.delete), label: const Text("Hapus Foto")),
          const SizedBox(height: 16),
          TextField(
            controller: _usernameController,
            style: TextStyle(color: textColor),
            decoration: InputDecoration(
              labelText: "Nama / Username",
              labelStyle: TextStyle(color: textColor),
              border: const OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: selectedColorValue)),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _emailController,
            style: TextStyle(color: textColor),
            decoration: InputDecoration(
              labelText: "Email",
              labelStyle: TextStyle(color: textColor),
              border: const OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: selectedColorValue)),
            ),
          ),
          const SizedBox(height: 24),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: _saveChanges,
            style: ElevatedButton.styleFrom(backgroundColor: selectedColorValue, padding: const EdgeInsets.symmetric(vertical: 16)),
            child: const Text("Simpan Perubahan"),
          ),
        ],
      ),
    );
  }
}