import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/pizzeria_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PizzeriaProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Mi carrito')),
      body: provider.cart.isEmpty
          ? const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.shopping_cart_outlined, size: 72),
                  SizedBox(height: 12),
                  Text(
                    'Tu carrito está vacío',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: provider.cart.length,
                    itemBuilder: (context, index) {
                      final item = provider.cart[index];
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.local_pizza),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      item.pizza.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      context
                                          .read<PizzeriaProvider>()
                                          .removeCartItem(item);
                                    },
                                    icon: const Icon(Icons.close),
                                  ),
                                ],
                              ),
                              if (item.extras.isNotEmpty)
                                Text(
                                  'Extras: ${item.extras.join(', ')}',
                                  style: const TextStyle(color: Colors.black54),
                                ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      context
                                          .read<PizzeriaProvider>()
                                          .decreaseQuantity(item);
                                    },
                                    icon: const Icon(Icons.remove_circle_outline),
                                  ),
                                  Text(
                                    '${item.quantity}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      context
                                          .read<PizzeriaProvider>()
                                          .increaseQuantity(item);
                                    },
                                    icon: const Icon(Icons.add_circle_outline),
                                  ),
                                  const Spacer(),
                                  Text(
                                    '\$${item.subtotal.toStringAsFixed(0)}',
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SafeArea(
                  top: false,
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 8,
                          color: Colors.black12,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '\$${provider.cartTotal.toStringAsFixed(0)} MXN',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFFC62828),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        FilledButton.icon(
                          style: FilledButton.styleFrom(
                            minimumSize: const Size.fromHeight(52),
                          ),
                          onPressed: () {
                            provider.clearCart();
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Pedido generado'),
                                content: const Text(
                                  'Tu pedido fue registrado correctamente. ',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Aceptar'),
                                  ),
                                ],
                              ),
                            );
                          },
                          icon: const Icon(Icons.receipt_long),
                          label: const Text('Generar pedido'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
