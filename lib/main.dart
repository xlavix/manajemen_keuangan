import 'package:flutter/material.dart';
import 'dbhelper.dart';
import 'finance_form_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Keuangan',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainPage(), // Langsung arahkan ke MainPage
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final dbHelper _dbHelper = dbHelper.instance;
  List<Map<String, dynamic>> _finances = [];

  @override
  void initState() {
    super.initState();
    _refreshFinances();
  }

  Future<void> _refreshFinances() async {
    final data = await _dbHelper.getFinances();
    setState(() {
      _finances = data;
    });
  }

  Future<void> _navigateToAddFinance() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FinanceFormPage()),
    );
    if (result == true) {
      _refreshFinances();
    }
  }

  Future<void> _navigateToEditFinance(Map<String, dynamic> finance) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FinanceFormPage(finance: finance)),
    );
    if (result == true) {
      _refreshFinances();
    }
  }

  void _deleteFinance(int id) async {
    await _dbHelper.deleteFinance(id);
    _refreshFinances();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Keuangan'),
      ),
      body: ListView.builder(
        itemCount: _finances.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_finances[index]['type']),
            subtitle: Text(_finances[index]['description']),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _navigateToEditFinance(_finances[index]),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _deleteFinance(_finances[index]['id']),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddFinance,
        child: const Icon(Icons.add),
      ),
    );
  }
}