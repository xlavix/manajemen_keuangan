import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../database/db_helper.dart';

class FinanceFormPage extends StatefulWidget {
  final Map<String, dynamic>? finance;

  const FinanceFormPage({super.key, this.finance});

  @override
  _FinanceFormPageState createState() => _FinanceFormPageState();
}

class _FinanceFormPageState extends State<FinanceFormPage> {
  final TextEditingController _nominalController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _type = 'income';
  String? _selectedCategory;

  final DBHelper _dbHelper = DBHelper();

  final List<String> _incomeCategories = ['Gaji', 'Uang Ortu', 'Bonus', 'Lainnya'];
  final List<String> _expenseCategories = ['Jajan', 'Investasi', 'Transportasi', 'Tagihan', 'Lainnya'];

  @override
  void initState() {
    super.initState();
    if (widget.finance != null) {
      _type = widget.finance!['type'];
      _nominalController.text = widget.finance!['nominal'].toString();
      _descriptionController.text = widget.finance!['description'];
      _selectedDate = DateTime.tryParse(widget.finance!['date'] ?? '') ?? DateTime.now();

      // --- LOGIKA YANG DIPERBAIKI ADA DI SINI ---
      // Cek apakah kategori yang dimuat valid untuk tipe transaksi saat ini.
      // Ini untuk menangani transaksi lama yang belum punya kategori.
      final loadedCategory = widget.finance!['category'];
      final validCategories = _type == 'income' ? _incomeCategories : _expenseCategories;
      if (loadedCategory != null && validCategories.contains(loadedCategory)) {
        _selectedCategory = loadedCategory;
      }
      // Jika tidak, _selectedCategory akan tetap null, dan pengguna harus memilih.
    }
  }

  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveFinance() async {
    if (_nominalController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua field wajib diisi, termasuk kategori')),
      );
      return;
    }

    final finance = {
      'type': _type,
      'nominal': _nominalController.text,
      'description': _descriptionController.text,
      'date': _selectedDate.toIso8601String().split('T').first,
      'category': _selectedCategory,
    };

    if (widget.finance == null) {
      await _dbHelper.insertFinance(finance);
    } else {
      finance['id'] = widget.finance!['id'];
      await _dbHelper.updateFinance(finance);
    }

    _showSuccessDialog(isEdit: widget.finance != null);
  }

  void _showSuccessDialog({required bool isEdit}) {
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
                isEdit ? 'Transaksi berhasil diperbarui' : 'Transaksi berhasil ditambahkan',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context, true);
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

  void _deleteFinance() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi'),
        content: const Text('Apakah kamu yakin ingin menghapus transaksi ini?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Hapus')),
        ],
      ),
    );

    if (confirm == true) {
      await _dbHelper.deleteFinance(widget.finance!['id']);
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.finance != null;
    final dateFormatted = DateFormat('dd MMMM yyyy').format(_selectedDate);
    final currentCategories = _type == 'income' ? _incomeCategories : _expenseCategories;

    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade50,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          isEdit ? 'Edit Transaksi' : 'Tambah Transaksi',
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isEdit ? 'Edit transaksi keuangan Anda' : 'Tambah transaksi baru',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 8)],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ChoiceChip(
                    label: const Text("Pemasukan"),
                    selected: _type == 'income',
                    selectedColor: Colors.green.shade100,
                    onSelected: (_) => setState(() {
                      _type = 'income';
                      _selectedCategory = null;
                    }),
                    labelStyle: TextStyle(color: _type == 'income' ? Colors.green[800] : Colors.black),
                  ),
                  const SizedBox(width: 16),
                  ChoiceChip(
                    label: const Text("Pengeluaran"),
                    selected: _type == 'expense',
                    selectedColor: Colors.red.shade100,
                    onSelected: (_) => setState(() {
                      _type = 'expense';
                      _selectedCategory = null;
                    }),
                    labelStyle: TextStyle(color: _type == 'expense' ? Colors.red[800] : Colors.black),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 8)],
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedCategory,
                  isExpanded: true,
                  hint: const Text('Pilih Kategori'),
                  items: currentCategories.map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedCategory = newValue;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nominalController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Nominal',
                prefixIcon: const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text('Rp', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                filled: true,
                fillColor: Colors.white,
                border: InputBorder.none,
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.blue.shade200, width: 2)),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Deskripsi',
                prefixIcon: const Icon(Icons.edit),
                filled: true,
                fillColor: Colors.white,
                border: InputBorder.none,
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.blue.shade200, width: 2)),
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _pickDate,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 8)],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined),
                    const SizedBox(width: 12),
                    Text(dateFormatted, style: const TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _saveFinance,
                icon: const Icon(Icons.save),
                label: Text(isEdit ? 'Simpan' : 'Tambah'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _type == 'income' ? Colors.green[600] : Colors.red[600],
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
            if (isEdit) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _deleteFinance,
                  icon: const Icon(Icons.delete),
                  label: const Text('Hapus'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[400],
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}