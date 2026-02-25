class VoucherModel {
  final String id;
  final String title;
  final double minAmount;
  final double maxAmount;
  final bool disablePurchase;
  final Map<String, int> discounts;
  final List<String> redeemSteps;

  VoucherModel({
    required this.id,
    required this.title,
    required this.minAmount,
    required this.maxAmount,
    required this.disablePurchase,
    required this.discounts,
    required this.redeemSteps,
  });

  factory VoucherModel.fromJson(Map<String, dynamic> json) {
    var discountList = json['discounts'] as List;
    Map<String, int> discountMap = {};
    for (var item in discountList) {
      discountMap[item['method']] = item['percent'];
    }
    return VoucherModel(
      id: json['id'],
      title: json['title'],
      minAmount: json['minAmount'].toDouble(),
      maxAmount: json['maxAmount'].toDouble(),
      disablePurchase: json['disablePurchase'],
      discounts: discountMap,
      redeemSteps: List<String>.from(json['redeemSteps']),
    );
  }
}