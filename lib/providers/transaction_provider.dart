// File: lib/providers/transaction_provider.dart
import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../services/database_helper.dart';

class TransactionProvider extends ChangeNotifier {
  List<StoreTransaction> _transactions = [];
  bool _isLoading = false;

  // Getter
  List<StoreTransaction> get transactions => _transactions;
  bool get isLoading => _isLoading;

  // Memuat transaksi khusus milik pegawai yang sedang login
  Future<void> fetchTransactionsByEmployee(int employeeId) async {
    _isLoading = true;
    notifyListeners();

    final dataList = await DatabaseHelper.instance.queryTransactionsByEmployee(employeeId);

    _transactions = dataList.map((item) {
      if (item['payment_method'] == 'Tunai') {
        return CashTransaction(
          id: item['id'],
          receiptNumber: item['receipt_number'],
          totalAmount: item['total_amount'],
          date: DateTime.parse(item['date']),
          employeeId: item['employee_id'], // Parameter wajib yang sebelumnya kurang
        );
      } else {
        return QrisTransaction(
          id: item['id'],
          receiptNumber: item['receipt_number'],
          totalAmount: item['total_amount'],
          date: DateTime.parse(item['date']),
          employeeId: item['employee_id'], // Parameter wajib yang sebelumnya kurang
        );
      }
    }).toList();

    _isLoading = false;
    notifyListeners();
  }

  // Menambah transaksi baru
  Future<void> addTransaction(StoreTransaction transaction) async {
    await DatabaseHelper.instance.insert(transaction.toMap());
    await fetchTransactionsByEmployee(transaction.employeeId);
  }

  // Menghapus transaksi
  Future<void> deleteTransaction(int id, int employeeId) async {
    await DatabaseHelper.instance.delete(id);
    await fetchTransactionsByEmployee(employeeId);
  }
}