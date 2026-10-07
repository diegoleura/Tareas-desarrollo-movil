import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/pizzeria_provider.dart';
import '../widgets/pizza_card.dart';
import 'branches_screen.dart';
import 'cart_screen.dart';
import 'pizza_detail_screen.dart';

class ClientHomeScreen extends StatelessWidget {
  const ClientHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PizzeriaProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Menú de pizzas'),
        actions: [
          IconButton(
            tooltip: 'Sucursales',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const BranchesScreen()),
              );
            },
            icon: const Icon(Icons.location_on_outlined),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                tooltip: 'Carrito',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CartScreen()),
                  );
                },
                icon: const Icon(Icons.shopping_cart_outlined),
              ),
              if (provider.cartCount > 0)
                Positioned(
                  right: 5,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.amber,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${provider.cartCount}',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFFFFE0B2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              children: [
                Icon(Icons.local_fire_department, size: 38),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Elige tu pizza y personalízala con ingredientes extra.',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: provider.pizzas.length,
              itemBuilder: (context, index) {
                final pizza = provider.pizzas[index];
                return PizzaCard(
                  pizza: pizza,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PizzaDetailScreen(pizza: pizza),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
