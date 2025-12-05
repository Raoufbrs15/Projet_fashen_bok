import 'product.dart';

class Order {
  final List<Product> items;
  final double total;
  final String address;
  final String paymentMethod;
  final DateTime date;

  Order({
    required this.items,
    required this.total,
    required this.address,
    required this.paymentMethod,
    required this.date,
  });
}

/// Liste simple des commandes passées (en mémoire seulement)
class OrderStore {
  static final List<Order> orders = [];
}
