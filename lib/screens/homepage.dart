import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../database/db_helper.dart';
import 'finance_form_page.dart';
import 'profile_page.dart';
import 'notifications_page.dart';

class HomePage extends StatefulWidget {
  final String username;
  const HomePage({super.key, required this.username});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final _currencyFormatter = NumberFormat('#,##0', 'id_ID');
  final DBHelper _dbHelper = DBHelper();

  List<Map<String, dynamic>> transactions = [];
  double totalBalance = 0;
  double income = 0;
  double expense = 0;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  void _loadTransactions() async {
    final data = await _dbHelper.getAllFinance();
    double pemasukan = 0;
    double pengeluaran = 0;

    for (var trx in data) {
      final nominal = double.tryParse(trx['nominal']) ?? 0;
      if (trx['type'] == 'income') {
        pemasukan += nominal;
      } else {
        pengeluaran += nominal;
      }
    }

    setState(() {
      transactions = data;
      income = pemasukan;
      expense = pengeluaran;
      totalBalance = pemasukan - pengeluaran;
    });
  }

  void _onItemTapped(int index) async {
    if (index == 1) {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const FinanceFormPage()),
      );
      if (result == true) _loadTransactions();
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  void _confirmDelete(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi'),
        content: const Text('Yakin ingin menghapus transaksi ini?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Hapus')),
        ],
      ),
    );

    if (confirm == true) {
      await _dbHelper.deleteFinance(id);
      _loadTransactions();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildDashboard(),
          Container(),
          ProfilePage(
            username: widget.username,
            onBack: () {
              setState(() {
                _selectedIndex = 0;
              });
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue[800],
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle), label: 'Transaksi'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Akun'),
        ],
      ),
    );
  }

  Widget _buildDashboard() {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, color: Colors.blue),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Halo, Selamat siang!", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Text(widget.username, style: const TextStyle(fontSize: 14)),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.notifications_none),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const NotificationsPage()),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.blue[800],
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Saldo Anda", style: TextStyle(color: Colors.white70)),
                    const SizedBox(height: 8),
                    Text(
                      "Rp ${_currencyFormatter.format(totalBalance)}",
                      style: const TextStyle(fontSize: 28, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _summaryCard("Pemasukan", income, Icons.arrow_downward, Colors.green),
                        _summaryCard("Pengeluaran", expense, Icons.arrow_upward, Colors.red),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Transaksi Terakhir",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
              transactions.isEmpty
                  ? const Text("Belum ada transaksi.")
                  : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  final trx = transactions[index];
                  final nominal = double.tryParse(trx['nominal']) ?? 0;

                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: trx['type'] == 'income' ? Colors.green : Colors.red,
                        child: Icon(
                          trx['type'] == 'income' ? Icons.arrow_downward : Icons.arrow_upward,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(
                        trx['description'],
                        style: const TextStyle(fontWeight: FontWeight.bold), // ✅ Deskripsi bold
                      ),
                      subtitle: Text("Rp ${_currencyFormatter.format(nominal)}"),
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) async {
                          if (value == 'edit') {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => FinanceFormPage(finance: trx),
                              ),
                            );
                            if (result == true) _loadTransactions();
                          } else if (value == 'delete') {
                            _confirmDelete(trx['id']);
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'edit',
                            child: ListTile(
                              leading: Icon(Icons.edit),
                              title: Text('Edit'),
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: ListTile(
                              leading: Icon(Icons.delete),
                              title: Text('Hapus'),
                            ),
                          ),
                        ],
                        icon: const Icon(Icons.more_vert),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _summaryCard(String label, double value, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, color: color),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
            Text("Rp ${_currencyFormatter.format(value)}",
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }
}
