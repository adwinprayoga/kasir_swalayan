// File: lib/pages/add_transaction_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/transaction_model.dart';
import '../providers/transaction_provider.dart';
import '../providers/auth_provider.dart';

class AddTransactionPage extends StatefulWidget {
  const AddTransactionPage({super.key});

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  final _formKey = GlobalKey<FormState>();
  final _receiptController = TextEditingController();
  final _amountController = TextEditingController();

  String _paymentMethod = 'Tunai';
  DateTime? _selectedDate;

  @override
  void dispose() {
    _receiptController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() && _selectedDate != null) {
      final amount = double.parse(_amountController.text);
      final receipt = _receiptController.text.trim();

      // Ambil ID kasir yang sedang login dari AuthProvider
      final currentEmployeeId = context.read<AuthProvider>().currentEmployee!.id!;

      StoreTransaction newTransaction;
      if (_paymentMethod == 'Tunai') {
        newTransaction = CashTransaction(
          receiptNumber: receipt,
          totalAmount: amount,
          date: _selectedDate!,
          employeeId: currentEmployeeId,
        );
      } else {
        newTransaction = QrisTransaction(
          receiptNumber: receipt,
          totalAmount: amount,
          date: _selectedDate!,
          employeeId: currentEmployeeId,
        );
      }

      // Simpan transaksi melalui TransactionProvider
      context.read<TransactionProvider>().addTransaction(newTransaction);

      // Tampilkan SnackBar feedback
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Struk berhasil disimpan!')),
      );

      // Reset Form setelah berhasil submit
      _receiptController.clear();
      _amountController.clear();
      setState(() {
        _selectedDate = null;
        _paymentMethod = 'Tunai';
      });
    } else if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih tanggal transaksi terlebih dahulu!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Input Struk Baru')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Field Nomor Struk
            TextFormField(
              controller: _receiptController,
              decoration: const InputDecoration(
                labelText: 'Nomor Struk',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.receipt),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) return 'Nomor struk wajib diisi';
                if (value.trim().length < 4) return 'Minimal 4 karakter';
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // Field Total Belanja
            TextFormField(
              controller: _amountController,
              decoration: const InputDecoration(
                labelText: 'Total Belanja (Rp)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.attach_money),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) return 'Nominal wajib diisi';
                if (double.tryParse(value) == null) return 'Harus berupa angka valid';
                if (double.parse(value) <= 0) return 'Nominal harus lebih dari 0';
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // Input Pilihan 1: Dropdown Metode Pembayaran
            DropdownButtonFormField<String>(
              value: _paymentMethod,
              decoration: const InputDecoration(
                labelText: 'Metode Pembayaran',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.payment),
              ),
              items: ['Tunai', 'QRIS']
                  .map((method) => DropdownMenuItem(value: method, child: Text(method)))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _paymentMethod = value);
                }
              },
            ),
            const SizedBox(height: 16),
            
            // Input Pilihan 2: Date Picker
            ListTile(
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(4),
              ),
              title: Text(
                _selectedDate == null
                    ? 'Pilih Tanggal Transaksi'
                    : 'Tanggal: ${_selectedDate.toString().split(' ')[0]}',
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                );
                if (picked != null) {
                  setState(() => _selectedDate = picked);
                }
              },
            ),
            const SizedBox(height: 24),
            
            // Tombol Submit Form
            ElevatedButton.icon(
              onPressed: _submitForm,
              icon: const Icon(Icons.save),
              label: const Text('Simpan Struk'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}