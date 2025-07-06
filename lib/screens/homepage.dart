import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';
import '../database/db_helper.dart';
import '../services/weather_service.dart';
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
  final _currencyFormatter = NumberFormat('#,##0', 'id_ID');
  final DBHelper _dbHelper = DBHelper();

  late String currentUsername;
  List<Map<String, dynamic>> allTransactions = [];
  List<Map<String, dynamic>> filteredTransactions = [];
  double totalBalance = 0;
  double income = 0;
  double expense = 0;
  String _selectedFilter = "all";
  int _selectedIndex = 0;
  Uint8List? _photoBytes;

  final WeatherService _weatherService = WeatherService();
  String _weatherInfo = "Memuat cuaca...";

  @override
  void initState() {
    super.initState();
    currentUsername = widget.username;
    _loadTransactions();
    _loadUserProfile();
    _loadWeather();
  }

  void _loadWeather() async {
    try {
      final weatherData = await _weatherService.getWeather();
      if (mounted) {
        final String city = weatherData['city'];
        final int temp = weatherData['temp'];
        final String description = weatherData['description'];

        setState(() {
          _weatherInfo = "$city, $temp°C - $description";
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _weatherInfo = "Cuaca tidak tersedia";
        });
      }
    }
  }

  void _loadUserProfile() async {
    final user = await _dbHelper.getUserByUsername(currentUsername);
    if (user != null) {
      if (mounted) {
        setState(() {
          _photoBytes = user.photo;
        });
      }
    }
  }

  void _updateUsername(String newUsername) {
    setState(() {
      currentUsername = newUsername;
    });
    _loadUserProfile();
  }

  void _loadTransactions() async {
    final data = await _dbHelper.getAllFinance();
    if (mounted) {
      setState(() {
        allTransactions = data;
      });
    }
    _applyFilter();
  }

  void _applyFilter() {
    List<Map<String, dynamic>> filtered = [];
    final now = DateTime.now();

    for (var trx in allTransactions) {
      final date = trx['date'];
      if (date == null) continue;
      final trxDate = DateTime.tryParse(date);
      if (trxDate == null) continue;

      bool include = false;
      switch (_selectedFilter) {
        case "all":
          include = true;
          break;
        case "day":
          include = trxDate.year == now.year && trxDate.month == now.month && trxDate.day == now.day;
          break;
        case "week":
          final weekStart = now.subtract(Duration(days: now.weekday - 1));
          final weekEnd = weekStart.add(const Duration(days: 6));
          include = trxDate.isAfter(weekStart.subtract(const Duration(seconds: 1))) && trxDate.isBefore(weekEnd.add(const Duration(days: 1)));
          break;
        case "month":
          include = trxDate.year == now.year && trxDate.month == now.month;
          break;
      }
      if (include) filtered.add(trx);
    }

    double pemasukan = 0;
    double pengeluaran = 0;
    for (var trx in filtered) {
      final nominal = double.tryParse(trx['nominal']) ?? 0;
      if (trx['type'] == 'income') {
        pemasukan += nominal;
      } else {
        pengeluaran += nominal;
      }
    }

    if (mounted) {
      setState(() {
        filteredTransactions = filtered;
        income = pemasukan;
        expense = pengeluaran;
        totalBalance = pemasukan - pengeluaran;
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
    return AdaptiveScaffold(
      selectedIndex: _selectedIndex,
      onSelectedIndexChange: (index) async {
        if (index == 1) {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const FinanceFormPage()),
          );
          if (result == true) _loadTransactions();
        } else {
          setState(() => _selectedIndex = index);
        }
      },
      destinations: const [
        NavigationDestination(icon: Icon(Icons.home), label: 'Beranda'),
        NavigationDestination(icon: Icon(Icons.add), label: 'Transaksi'),
        NavigationDestination(icon: Icon(Icons.person), label: 'Akun'),
      ],
      body: (_) => IndexedStack(
        index: _selectedIndex,
        children: [
          _buildDashboard(),
          Container(),
          ProfilePage(
            username: currentUsername,
            onProfileUpdated: _updateUsername,
            onBack: () {
              setState(() => _selectedIndex = 0);
              _loadUserProfile();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDashboard() {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.white,
                    backgroundImage: _photoBytes != null ? MemoryImage(_photoBytes!) : null,
                    child: _photoBytes == null
                        ? const Icon(Icons.person, color: Colors.blue)
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Halo, Selamat siang!",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        Row(
                          children: [
                            Text(currentUsername, style: const TextStyle(fontSize: 14)),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _weatherInfo,
                                style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.notifications_none),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const NotificationsPage()),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
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
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildFilterChip("Semua", "all"),
                          const SizedBox(width: 8),
                          _buildFilterChip("Bulan Ini", "month"),
                          const SizedBox(width: 8),
                          _buildFilterChip("Minggu Ini", "week"),
                          const SizedBox(width: 8),
                          _buildFilterChip("Hari Ini", "day"),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Transaksi Terakhir",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: filteredTransactions.isEmpty
                          ? const Text("Belum ada transaksi.")
                          : ListView.builder(
                        itemCount: filteredTransactions.length,
                        itemBuilder: (context, index) {
                          final trx = filteredTransactions[index];
                          final nominal = double.tryParse(trx['nominal']) ?? 0;
                          return Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: trx['type'] == 'income' ? Colors.green : Colors.red,
                                child: Icon(
                                  trx['type'] == 'income'
                                      ? Icons.arrow_downward
                                      : Icons.arrow_upward,
                                  color: Colors.white,
                                ),
                              ),
                              title: Text(trx['description'],
                                  style: const TextStyle(fontWeight: FontWeight.bold)),
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
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
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

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _selectedFilter == value;

    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
          fontWeight: FontWeight.w500,
        ),
      ),
      selected: isSelected,
      showCheckmark: false,
      selectedColor: Colors.blue[800],
      backgroundColor: Colors.white,
      shape: StadiumBorder(
        side: BorderSide(
          color: isSelected ? Colors.transparent : Colors.grey.shade300,
        ),
      ),
      onSelected: (_) {
        setState(() {
          _selectedFilter = value;
          _applyFilter();
        });
      },
    );
  }
}