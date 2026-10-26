// File: lib/pages/detail_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/transaction_model.dart';
import '../providers/transaction_provider.dart';

class DetailPage extends StatelessWidget {
  final StoreTransaction transaction;

  const DetailPage({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Struk')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Header: ${transaction.getReceiptHeader()}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text('Nominal: Rp ${transaction.totalAmount.toStringAsFixed(0)}'),
            Text('Tanggal: ${transaction.date.toString().split(' ')[0]}'),
            Text('Metode: ${transaction.getPaymentMethod()}'),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {
                  // Mengirim 2 argumen: transaction.id dan transaction.employeeId
                  context.read<TransactionProvider>().deleteTransaction(
                        transaction.id!,
                        transaction.employeeId,
                      );
                  Navigator.pop(context);
                },
                child: const Text('Hapus Data', style: TextStyle(color: Colors.white)),
              ),
            )
          ],
        ),
      ),
    );
  }
}