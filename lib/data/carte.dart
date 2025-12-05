import '../models/product.dart';

class Cart {
  
  static final List<Product> items = [];

  static void add(Product p) {
    items.add(p);
  }

  static void remove(Product p) {
    items.remove(p);
  }

  static double get total {
    double sum = 0;
    for (var item in items) {
      sum += item.price;
    }
    return sum;
  }

  static void clear() {
    items.clear();
  }
}
