import 'package:flutter/material.dart';

import '../models/branch.dart';
import '../models/cart_item.dart';
import '../models/pizza.dart';

class PizzeriaProvider extends ChangeNotifier {
  final List<Pizza> _pizzas = [
    const Pizza(
      id: '1',
      name: 'Pepperoni Clásica',
      description: 'Salsa de tomate, mozzarella y pepperoni.',
      price: 139,
      ingredients: ['Salsa de tomate', 'Mozzarella', 'Pepperoni'],
    ),
    const Pizza(
      id: '2',
      name: 'Hawaiana',
      description: 'Jamón, piña, mozzarella y salsa de tomate.',
      price: 149,
      ingredients: ['Salsa de tomate', 'Mozzarella', 'Jamón', 'Piña'],
    ),
    const Pizza(
      id: '3',
      name: 'Mexicana',
      description: 'Chorizo, jalapeño, cebolla y mucho queso.',
      price: 165,
      ingredients: ['Salsa de tomate', 'Mozzarella', 'Chorizo', 'Jalapeño', 'Cebolla'],
    ),
    const Pizza(
      id: '4',
      name: 'Vegetariana',
      description: 'Pimiento, champiñón, cebolla, aceitunas y queso.',
      price: 155,
      ingredients: ['Mozzarella', 'Pimiento', 'Champiñón', 'Cebolla', 'Aceitunas'],
    ),
  ];

  final List<CartItem> _cart = [];

  final List<String> availableExtras = const [
    'Queso extra',
    'Pepperoni extra',
    'Jamón',
    'Champiñones',
    'Jalapeños',
    'Piña',
    'Aceitunas',
    'Tocino',
  ];

  final List<Branch> branches = const [
    Branch(
      name: 'Pizza LeDo Centro',
      address: 'Centro Histórico, San Luis Potosí',
      latitude: 22.1516,
      longitude: -100.9760,
      schedule: 'Lun-Dom 12:00 - 22:30',
    ),
    Branch(
      name: 'Pizza LeDo Tangamanga',
      address: 'Zona Tangamanga, San Luis Potosí',
      latitude: 22.1397,
      longitude: -101.0017,
      schedule: 'Lun-Dom 13:00 - 23:00',
    ),
    Branch(
      name: 'Pizza LeDo Oriente',
      address: 'Zona Oriente, San Luis Potosí',
      latitude: 22.1537,
      longitude: -100.9398,
      schedule: 'Lun-Dom 12:00 - 22:00',
    ),
  ];

  List<Pizza> get pizzas => List.unmodifiable(_pizzas);
  List<CartItem> get cart => List.unmodifiable(_cart);

  int get cartCount => _cart.fold(0, (sum, item) => sum + item.quantity);

  double get cartTotal => _cart.fold(0, (sum, item) => sum + item.subtotal);

  void addPizza(Pizza pizza) {
    _pizzas.add(pizza);
    notifyListeners();
  }

  void deletePizza(String id) {
    _pizzas.removeWhere((pizza) => pizza.id == id);
    _cart.removeWhere((item) => item.pizza.id == id);
    notifyListeners();
  }

  void addToCart(Pizza pizza, List<String> extras) {
    final sameExtras = [...extras]..sort();

    for (final item in _cart) {
      final existingExtras = [...item.extras]..sort();
      if (item.pizza.id == pizza.id &&
          existingExtras.join('|') == sameExtras.join('|')) {
        item.quantity++;
        notifyListeners();
        return;
      }
    }

    _cart.add(
      CartItem(
        pizza: pizza,
        extras: List.from(extras),
      ),
    );
    notifyListeners();
  }

  void increaseQuantity(CartItem item) {
    item.quantity++;
    notifyListeners();
  }

  void decreaseQuantity(CartItem item) {
    if (item.quantity > 1) {
      item.quantity--;
    } else {
      _cart.remove(item);
    }
    notifyListeners();
  }

  void removeCartItem(CartItem item) {
    _cart.remove(item);
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }
}
