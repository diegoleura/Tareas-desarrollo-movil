import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/pizza.dart';
import '../providers/pizzeria_provider.dart';

class PizzaDetailScreen extends StatefulWidget {
  final Pizza pizza;

  const PizzaDetailScreen({
    super.key,
    required this.pizza,
  });

  @override
  State<PizzaDetailScreen> createState() => _PizzaDetailScreenState();
}

class _PizzaDetailScreenState extends State<PizzaDetailScreen> {
  final Set<String> selectedExtras = {};

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PizzeriaProvider>();
    final total = widget.pizza.price + selectedExtras.length * 15;

    return Scaffold(
      appBar: AppBar(title: Text(widget.pizza.name)),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Container(
            height: 190,
            decoration: BoxDecoration(
              color: const Color(0xFFFFE0B2),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Icon(
              Icons.local_pizza,
              size: 120,
              color: Color(0xFFC62828),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            widget.pizza.name,
            style: const TextStyle(
              fontSize: 27,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(widget.pizza.description),
          const SizedBox(height: 16),
          const Text(
            'Ingredientes incluidos',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.pizza.ingredients
                .map((ingredient) => Chip(label: Text(ingredient)))
                .toList(),
          ),
          const SizedBox(height: 22),
          const Text(
            'Ingredientes extra (+\$15 c/u)',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
          const SizedBox(height: 8),
          ...provider.availableExtras.map(
            (extra) => CheckboxListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: Text(extra),
              value: selectedExtras.contains(extra),
              onChanged: (value) {
                setState(() {
                  if (value == true) {
                    selectedExtras.add(extra);
                  } else {
                    selectedExtras.remove(extra);
                  }
                });
              },
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(54),
            ),
            onPressed: () {
              context.read<PizzeriaProvider>().addToCart(
                    widget.pizza,
                    selectedExtras.toList(),
                  );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Pizza agregada al carrito'),
                ),
              );
            },
            icon: const Icon(Icons.add_shopping_cart),
            label: Text('Agregar al carrito - \$${total.toStringAsFixed(0)}'),
          ),
        ],
      ),
    );
  }
}
