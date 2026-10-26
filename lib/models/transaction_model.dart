// File: lib/models/transaction_model.dart

// 1. Abstract Class (Blueprint Utama)
abstract class StoreTransaction {
  // Encapsulation: Private attributes
  int? _id;
  String _receiptNumber; // Nomor struk belanja
  double _totalAmount;   // Total nominal belanja
  DateTime _date;        // Tanggal transaksi
  int _employeeId;       // ID Kasir yang menangani transaksi

  // Constructor
  StoreTransaction(this._id, this._receiptNumber, this._totalAmount, this._date, this._employeeId);

  // Getter untuk mengakses private attributes dengan aman
  int? get id => _id;
  String get receiptNumber => _receiptNumber;
  double get totalAmount => _totalAmount;
  DateTime get date => _date;
  int get employeeId => _employeeId;

  // Abstract methods untuk Polymorphism
  String getPaymentMethod();
  String getReceiptHeader();

  // Helper method untuk konversi ke Map (SQLite)
  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'receipt_number': _receiptNumber,
      'total_amount': _totalAmount,
      'date': _date.toIso8601String(),
      'payment_method': getPaymentMethod(),
      'employee_id': _employeeId,
    };
  }
}

// 2. Class Turunan Pertama (Transaksi Tunai)
class CashTransaction extends StoreTransaction {
  CashTransaction({
    int? id,
    required String receiptNumber,
    required double totalAmount,
    required DateTime date,
    required int employeeId,
  }) : super(id, receiptNumber, totalAmount, date, employeeId);

  @override
  String getPaymentMethod() => 'Tunai';

  @override
  String getReceiptHeader() {
    return "Struk Tunai: $receiptNumber"; 
  }
}

// 3. Class Turunan Kedua (Transaksi QRIS / Non-Tunai)
class QrisTransaction extends StoreTransaction {
  QrisTransaction({
    int? id,
    required String receiptNumber,
    required double totalAmount,
    required DateTime date,
    required int employeeId,
  }) : super(id, receiptNumber, totalAmount, date, employeeId);

  @override
  String getPaymentMethod() => 'QRIS';

  @override
  String getReceiptHeader() {
    return "Struk Digital (QRIS): $receiptNumber"; 
  }
}