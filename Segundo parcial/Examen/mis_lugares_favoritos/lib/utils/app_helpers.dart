import 'package:flutter/material.dart';

IconData categoryIcon(String category) {
  switch (category) {
    case 'Comida':
      return Icons.restaurant_rounded;
    case 'Estudio':
      return Icons.menu_book_rounded;
    case 'Diversión':
      return Icons.sports_esports_rounded;
    case 'Ejercicio':
      return Icons.fitness_center_rounded;
    case 'Trabajo':
      return Icons.work_rounded;
    case 'Viaje':
      return Icons.luggage_rounded;
    default:
      return Icons.place_rounded;
  }
}

Color categoryColor(BuildContext context, String category) {
  switch (category) {
    case 'Comida':
      return Colors.orange;
    case 'Estudio':
      return Colors.indigo;
    case 'Diversión':
      return Colors.purple;
    case 'Ejercicio':
      return Colors.green;
    case 'Trabajo':
      return Colors.blue;
    case 'Viaje':
      return Colors.teal;
    default:
      return Theme.of(context).colorScheme.primary;
  }
}

String readableError(Object error) {
  final text = error.toString();
  if (text.contains('Invalid login credentials')) {
    return 'El correo o la contraseña no son correctos.';
  }
  if (text.contains('User already registered')) {
    return 'Ese correo ya está registrado.';
  }
  if (text.contains('Email not confirmed')) {
    return 'Confirma tu correo antes de iniciar sesión.';
  }
  if (text.contains('SocketException') || text.contains('Network')) {
    return 'No hay conexión a internet.';
  }
  return 'Ocurrió un error. Intenta nuevamente.';
}
