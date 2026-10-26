// File: lib/pages/history_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';
import 'detail_page.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TransactionProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat Penjualan')),
      body: provider.transactions.isEmpty
          ? const Center(child: Text('Belum ada transaksi.')) // Handling UI saat data kosong
          : ListView.builder(
              itemCount: provider.transactions.length,
              itemBuilder: (context, index) {
                final tx = provider.transactions[index];
                return Card(
                  child: ListTile(
                    title: Text(tx.getReceiptHeader()), // Implementasi Polymorphism
                    subtitle: Text('Rp ${tx.totalAmount.toStringAsFixed(0)}'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      // Navigasi & Passing Data secara valid
                      Navigator.push(context, MaterialPageRoute(builder: (context) => DetailPage(transaction: tx)));
                    },
                  ),
                );
              },
            ),
    );
  }
}