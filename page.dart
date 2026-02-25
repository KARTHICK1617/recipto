import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'logic.dart';

class VoucherScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = context.watch<VoucherProvider>();
    final voucher = state.voucher;

    if (voucher == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: UnconstrainedBox(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              children: [
                Icon(Icons.share_outlined, size: 14),
                SizedBox(width: 4),
                Text("REFER & EARN ₹500", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
        leadingWidth: 150,
        actions: [IconButton(icon: const Icon(Icons.close), onPressed: () {})],
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 180,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Center(
                child: Image.asset(
                  'assets/voucher.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'W',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            TextField(
              onChanged: state.setAmount,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Enter your desired / bill amount",
                prefixText: "₹ ",
                suffixText: "Max: ₹${(voucher.maxAmount/1000).toInt()}K",
                border: const OutlineInputBorder(),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.deepPurple, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.green.withOpacity(0.05), borderRadius: BorderRadius.circular(8)),
              child: Row(
                children: [
                  Expanded(child: _buildSummary("YOU PAY", "₹${state.youPay.toStringAsFixed(2)}", Colors.green)),
                  Container(width: 1, height: 40, color: Colors.grey.shade300),
                  Expanded(child: _buildSummary("SAVINGS", "₹${state.savings.toStringAsFixed(2)}", Colors.black)),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                _methodTile(state, "UPI"),
                const SizedBox(width: 8),
                _methodTile(state, "CARD"),
                const Spacer(),
                _quantityStepper(state),
              ],
            ),

            const SizedBox(height: 24),
            const Text("HOW TO REDEEM", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...voucher.redeemSteps.map((step) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text("• $step", style: const TextStyle(color: Colors.grey)),
            )),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(child: _buildActionBtn("About Brand")),
                const SizedBox(width: 12),
                Expanded(child: _buildActionBtn("Terms & Conditions")),
              ],
            ),
            SizedBox(height: 50),
          ],
        ),
      ),
      bottomNavigationBar: _payButton(state),
    );
  }

  // Helper for the Brand/Terms black boxes
  Widget _buildActionBtn(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
      ),
    );
  }

  Widget _buildSummary(String label, String value, Color valColor) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: valColor)),
      ],
    );
  }

  Widget _methodTile(VoucherProvider state, String method) {
    bool isSelected = state.paymentMethod == method;
    return GestureDetector(
      onTap: () => state.setPaymentMethod(method),
      child: Container(
        height: 60,
        width: 100,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: isSelected ? Colors.deepPurple : Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(method, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text("${state.voucher?.discounts[method]}% OFF", style: const TextStyle(fontSize: 10, color: Colors.deepPurple)),
          ],
        ),
      ),
    );
  }

  Widget _quantityStepper(VoucherProvider state) {
    return Column(
      children: [
        const Text("QUANTITY", style: TextStyle(fontSize: 10, color: Colors.grey)),
        Row(
          children: [
            IconButton(icon: const Icon(Icons.remove), onPressed: () => state.setQuantity(state.quantity - 1)),
            Text(state.quantity.toString().padLeft(2, '0')),
            IconButton(icon: const Icon(Icons.add), onPressed: () => state.setQuantity(state.quantity + 1)),
          ],
        )
      ],
    );
  }

  Widget _payButton(VoucherProvider state) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurple,
          disabledBackgroundColor: Colors.grey,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        ),

        onPressed: state.isPayEnabled
            ? () {
          print("Payment Processed: ₹${state.youPay}");
        }
            : null,
        child: Text("Pay ₹${state.youPay.toStringAsFixed(2)}", style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}