import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/pizza.dart';
import '../providers/pizzeria_provider.dart';

class AddPizzaScreen extends StatefulWidget {
  const AddPizzaScreen({super.key});

  @override
  State<AddPizzaScreen> createState() => _AddPizzaScreenState();
}

class _AddPizzaScreenState extends State<AddPizzaScreen> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final ingredientsController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    ingredientsController.dispose();
    super.dispose();
  }

  void savePizza() {
    if (!formKey.currentState!.validate()) return;

    final ingredients = ingredientsController.text
        .split(',')
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList();

    final pizza = Pizza(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: nameController.text.trim(),
      description: descriptionController.text.trim(),
      price: double.parse(priceController.text.trim()),
      ingredients: ingredients,
    );

    context.read<PizzeriaProvider>().addPizza(pizza);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pizza creada correctamente')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear nueva pizza')),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            const Icon(
              Icons.add_circle_outline,
              size: 75,
              color: Color(0xFFC62828),
            ),
            const SizedBox(height: 18),
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nombre de la pizza',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value == null || value.trim().isEmpty ? 'Escribe un nombre' : null,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Descripción',
                border: OutlineInputBorder(),
              ),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Escribe una descripción'
                  : null,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: priceController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Precio',
                prefixText: '\$ ',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                final number = double.tryParse(value ?? '');
                if (number == null || number <= 0) {
                  return 'Escribe un precio válido';
                }
                return null;
              },
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: ingredientsController,
              decoration: const InputDecoration(
                labelText: 'Ingredientes',
                hintText: 'Queso, pepperoni, salsa...',
                helperText: 'Sepáralos con comas',
                border: OutlineInputBorder(),
              ),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Agrega al menos un ingrediente'
                  : null,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(54),
              ),
              onPressed: savePizza,
              icon: const Icon(Icons.save),
              label: const Text('Guardar pizza'),
            ),
          ],
        ),
      ),
    );
  }
}
