import 'package:flutter/material.dart';
import 'dbhelper.dart';

class FinanceFormPage extends StatefulWidget {
  final Map<String, dynamic>? finance;

  const FinanceFormPage({super.key, this.finance});

  @override
  _FinanceFormPageState createState() => _FinanceFormPageState();
}

class _FinanceFormPageState extends State<FinanceFormPage> {
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _nominalController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final dbHelper _dbHelper = dbHelper.instance;

  @override
  void initState(){
    super.initState();
    if (widget.finance != null) {
      _typeController.text = widget.finance!['type'];
      _nominalController.text = widget.finance!['nominal'];
      _descriptionController.text = widget.finance!['description'];
    }
  }

  void _saveFinance() async {
    try {
      final finance = {
        'type': _typeController.text,
        'nominal': _nominalController.text,
        'description': _descriptionController.text
      };

      print('Saving finance: $finance');

      if (widget.finance == null){
        await _dbHelper.insertFinance(finance);
        print('Finance Inserted');
      } else {
        finance['id'] = widget.finance!['id'].toString();
        print('Finance ID: ${finance['id']}, Type: ${finance['id'].runtimeType}');
        await _dbHelper.updateFinance(finance);
        print('Finance Updated');
      }

      Navigator.pop(context, true);
    } catch (e) {
      print('Error saving finance: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menyimpan data keuangan')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.finance == null ? 'Tambah Data Keuangan' : 'Edit Data Keuangan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              /*Navigator.pushReplacement(
                context,
                //MaterialPageRoute(builder: (context) => const LoginPage()),
              );*/
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _typeController,
              decoration: const InputDecoration(labelText: 'Tipe Data'),
            ),
            TextField(
              controller: _nominalController,
              decoration: const InputDecoration(labelText: 'Nominal'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Deskripsi'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveFinance,
              child: Text(widget.finance == null ? 'Tambah' : 'Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}