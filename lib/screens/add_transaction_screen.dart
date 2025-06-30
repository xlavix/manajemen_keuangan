// add_transaction_screen.dart
import 'package:flutter/material.dart';

class AddTransactionScreen extends StatelessWidget {
  const AddTransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah/Edit Transaksi'),
        backgroundColor: Colors.deepPurple, // Warna AppBar untuk halaman ini
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.edit_note, size: 80, color: Colors.deepPurple),
              SizedBox(height: 20),
              Text(
                'Formulir Tambah/Edit Transaksi',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                'Di sini Anda akan menambahkan input untuk nominal, kategori, deskripsi, dll.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              // Nantinya, di sini akan ada TextField, Dropdown, dll.
            ],
          ),
        ),
      ),
    );
  }
}