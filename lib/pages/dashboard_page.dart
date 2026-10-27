// File: lib/pages/dashboard_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';
import '../providers/auth_provider.dart';
import 'login_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Memantau provider transaksi
    final provider = context.watch<TransactionProvider>();
    
    // Mengambil data kasir yang sedang login (hanya read, tidak perlu watch terus menerus)
    final authProvider = context.read<AuthProvider>();
    final employeeName = authProvider.currentEmployee?.name ?? 'Kasir';

    // Kalkulasi total pendapatan
    double totalRevenue = 0;
    for (var tx in provider.transactions) {
      totalRevenue += tx.totalAmount;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard - $employeeName'), // Menampilkan nama kasir aktif
        actions: [
          // Tombol Log Out / Ganti Akun
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Log Out',
            onPressed: () {
              // 1. Menghapus sesi login di AuthProvider
              context.read<AuthProvider>().logout();
              
              // 2. Navigasi ke LoginPage & menghapus seluruh tumpukan halaman sebelumnya
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        const Text('Total Pendapatan', style: TextStyle(color: Colors.white, fontSize: 18)),
                        const SizedBox(height: 10),
                        Text('Rp ${totalRevenue.toStringAsFixed(0)}', 
                          style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Card(
                            elevation: 2,
                            child: Center(
                              child: Text(
                                'Total Struk:\n${provider.transactions.length}', 
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              )
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
    );
  }
}