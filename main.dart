import 'package:demo/page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'logic.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => VoucherProvider()..loadVoucher({
        "id": "zepto-100",
        "title": "Zepto Instant Voucher",
        "minAmount": 50,
        "maxAmount": 10000,
        "disablePurchase": false,
        "discounts": [
          {"method": "UPI", "percent": 4},
          {"method": "CARD", "percent": 4}
        ],
        "redeemSteps": [
          "Login to Zepto Platform",
          "Click on My profile Settings",
          "Go to Zepto Cash & Gift Card",
          "Click on Add Card option"
        ]
      }),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: VoucherScreen(),
    );
  }
}