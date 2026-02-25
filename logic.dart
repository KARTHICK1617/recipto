import 'package:flutter/material.dart';

import 'VoucherModel.dart';

class VoucherProvider extends ChangeNotifier {
  VoucherModel? _voucher;
  double _inputAmount = 100.0;
  int _quantity = 1;
  String _paymentMethod = "UPI";

  VoucherModel? get voucher => _voucher;
  double get inputAmount => _inputAmount;
  int get quantity => _quantity;
  String get paymentMethod => _paymentMethod;

  double get discountPercent => (_voucher?.discounts[_paymentMethod] ?? 0).toDouble();
  double get discountAmount => _inputAmount * (discountPercent / 100);
  double get youPay => (_inputAmount - discountAmount) * _quantity;
  double get savings => discountAmount * _quantity;

  bool get isPayEnabled {
    if (_voucher == null || _voucher!.disablePurchase) return false;
    return _inputAmount >= _voucher!.minAmount && _inputAmount <= _voucher!.maxAmount;
  }

  void setAmount(String val) {
    _inputAmount = double.tryParse(val) ?? 0;
    notifyListeners();
  }

  void setQuantity(int val) {
    if (val >= 1) {
      _quantity = val;
      notifyListeners();
    }
  }

  void setPaymentMethod(String method) {
    _paymentMethod = method;
    notifyListeners();
  }

  void loadVoucher(Map<String, dynamic> mockJson) {
    _voucher = VoucherModel.fromJson(mockJson);
    notifyListeners();
  }
}