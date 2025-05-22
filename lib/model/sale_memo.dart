class SaleMemo {
  final String productName;
  final String productSize;
  final int amount;
  final double price;
  final double percent;
  final double totalAmount;
  final DateTime dateTime;

  SaleMemo({
    required this.productName,
    required this.productSize,
    required this.amount,
    required this.price,
    required this.percent,
    required this.totalAmount,
    required this.dateTime,
  });

  factory SaleMemo.fromJson(Map<String, dynamic> json) {
    return SaleMemo(
      productName: json['productName'],
      productSize: json['productSize'],
      amount: json['amount'],
      price: json['price'],
      percent: json['percent'],
      totalAmount: json['totalAmount'],
      dateTime: DateTime.parse(json['dateTime']),
    );
  }
}
