// File: lib/pages/dashboard_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Memantau perubahan data secara reaktif
    final provider = context.watch<TransactionProvider>();
    
    // Kalkulasi total pendapatan
    double totalRevenue = 0;
    for (var tx in provider.transactions) {
      totalRevenue += tx.totalAmount;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard Swalayan')),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator()) // Handling UI saat loading
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
                            child: Center(child: Text('Total Struk:\n${provider.transactions.length}', textAlign: TextAlign.center)),
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