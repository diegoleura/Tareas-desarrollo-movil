import 'pizza.dart';

class CartItem {
  final Pizza pizza;
  final List<String> extras;
  int quantity;

  CartItem({
    required this.pizza,
    required this.extras,
    this.quantity = 1,
  });

  double get extrasCost => extras.length * 15.0;

  double get unitPrice => pizza.price + extrasCost;

  double get subtotal => unitPrice * quantity;
}
