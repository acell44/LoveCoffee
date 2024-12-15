class CartItem {
  int? id;
  String itemName;
  String size;
  int quantity;
  double price;
  String category;

  CartItem({
    this.id,
    required this.itemName,
    required this.size,
    required this.quantity,
    required this.price,
    required this.category,
  });

  // Konversi dari JSON
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: _parseId(json['id']), // parsing khusus
      itemName: json['itemname'] ?? json['itemName'] ?? '',
      size: json['size'] ?? '',
      quantity: _parseInt(json['quantity']),
      price: _parseDouble(json['price']),
      category: json['category'] ?? '',
    );
  }

  // Konversi ke JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'itemname': itemName,
      'size': size,
      'quantity': quantity,
      'price': price,
      'category': category,
    };
  }

  static int? _parseId(dynamic id) {
    if (id == null) return null;
    if (id is int) return id;
    if (id is String) return int.tryParse(id);
    return null;
  }

  static int _parseInt(dynamic value, {int defaultValue = 1}) {
    if (value == null) return defaultValue;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? defaultValue;
    if (value is double) return value.toInt();
    return defaultValue;
  }

  static double _parseDouble(dynamic value, {double defaultValue = 0.0}) {
    if (value == null) return defaultValue;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? defaultValue;
    return defaultValue;
  }
}
