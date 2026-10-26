// File: lib/pages/main_page.dart
import 'package:flutter/material.dart';

// Import 3 halaman utama yang akan kita buat pada tahap selanjutnya
import 'dashboard_page.dart';
import 'add_transaction_page.dart';
import 'history_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  // Daftar minimal 3 halaman utama
  final List<Widget> _pages = [
    const DashboardPage(),
    const AddTransactionPage(),
    const HistoryPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      // Komponen bilah navigasi bawah
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Mengubah halaman aktif
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box),
            label: 'Input Struk',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Riwayat',
          ),
        ],
      ),
    );
  }
}