class Products {
  String? docId;
  String name;
  int total;
  String size;
  int price;

  Products({
    this.docId,
    required this.name,
    required this.total,
    required this.size,
    required this.price
  });

  factory Products.fromJson(Map<String, dynamic> json, String docId) {
    return Products(
      docId: docId,
      name: json['name'],
      total: json['total'],
      size: json['size'],
      price: json['price']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'total': total,
      'size': size,
      'price': price
    };
  }
}