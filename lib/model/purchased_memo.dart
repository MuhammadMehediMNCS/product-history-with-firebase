class PurchasedMemo {
  final String productName;
  final String productSize;
  final int newProduct;
  final int orderProduct;
  final int dueProduct;
  final double price;
  final double totalAmount;
  final DateTime dateTime;

  PurchasedMemo({
    required this.productName,
    required this.productSize,
    required this.newProduct,
    required this.orderProduct,
    required this.dueProduct,
    required this.price,
    required this.totalAmount,
    required this.dateTime,
  });

  factory PurchasedMemo.fromJson(Map<String, dynamic> json) {
    return PurchasedMemo(
      productName: json['productName'],
      productSize: json['productSize'],
      newProduct: json['newProduct'],
      orderProduct: json['orderProduct'],
      dueProduct: json['dueProduct'],
      price: json['price'],
      totalAmount: json['totalAmount'],
      dateTime: DateTime.parse(json['dateTime'])
    );
  }
}