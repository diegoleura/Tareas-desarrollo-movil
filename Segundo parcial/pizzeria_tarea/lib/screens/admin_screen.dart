import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/pizzeria_provider.dart';
import '../widgets/pizza_card.dart';
import 'add_pizza_screen.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PizzeriaProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel administrador'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddPizzaScreen()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Nueva pizza'),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Text(
              'Pizzas registradas: ${provider.pizzas.length}\n',
              style: const TextStyle(fontSize: 16),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: provider.pizzas.length,
              itemBuilder: (context, index) {
                final pizza = provider.pizzas[index];
                return PizzaCard(
                  pizza: pizza,
                  showDelete: true,
                  onTap: () {},
                  onDelete: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Eliminar pizza'),
                        content: Text(
                          '¿Seguro que quieres eliminar "${pizza.name}"?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancelar'),
                          ),
                          FilledButton(
                            onPressed: () {
                              context
                                  .read<PizzeriaProvider>()
                                  .deletePizza(pizza.id);
                              Navigator.pop(context);
                            },
                            child: const Text('Eliminar'),
                          ),
                        ],
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
