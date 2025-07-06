import 'package:flutter/material.dart';
import '../database/db_helper.dart';

class ConnectionPage extends StatelessWidget {
  final String username;
  const ConnectionPage({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? Colors.grey[900] : Colors.blue[50];
    final textColor = isDarkMode ? Colors.white : Colors.black;

    final List<String> banks = [
      "Bank Mandiri",
      "BCA",
      "BRI",
      "BNI",
      "CIMB Niaga",
      "Danamon",
      "Permata Bank",
      "Bank Syariah Indonesia"
    ];

    final dbHelper = DBHelper(); // Tambahkan DBHelper

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Sambungkan ke Bank",
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: banks.length,
        itemBuilder: (context, index) {
          return Card(
            color: isDarkMode ? Colors.grey[800] : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: const Icon(Icons.account_balance),
              title: Text(
                banks[index],
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () async {
                await dbHelper.updateConnectedBank(username, banks[index]);
                _showConnectedDialog(context, banks[index]);
              },
            ),
          );
        },
      ),
    );
  }

  void _showConnectedDialog(BuildContext context, String bankName) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 64),
              const SizedBox(height: 16),
              Text(
                "Tersambung ke $bankName",
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Tutup dialog
                  Navigator.pop(context); // Kembali ke ProfilePage
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Selesai"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
