import 'package:flutter/material.dart';

import '../services/supabase_service.dart';
import 'auth_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Quieres cerrar tu sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Cerrar sesión'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    await SupabaseService.signOut();
    if (!context.mounted) return;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const AuthScreen()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = SupabaseService.currentUser;
    final name = user?.userMetadata?['display_name']?.toString();
    final email = user?.email ?? '';

    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          CircleAvatar(
            radius: 44,
            child: Text(
              (name?.isNotEmpty == true ? name![0] : email.isNotEmpty ? email[0] : '?')
                  .toUpperCase(),
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              name?.isNotEmpty == true ? name! : 'Mi cuenta',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
          ),
          const SizedBox(height: 5),
          Center(child: Text(email)),
          const SizedBox(height: 28),
          Card(
            child: Column(
              children: [
                const ListTile(
                  leading: Icon(Icons.cloud_done_outlined),
                  title: Text('Datos sincronizados'),
                  subtitle: Text('Tus lugares se guardan en Supabase'),
                ),
                const Divider(height: 1),
                const ListTile(
                  leading: Icon(Icons.map_outlined),
                  title: Text('Mapa'),
                  subtitle: Text('OpenStreetMap para visualizar tus lugares'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          OutlinedButton.icon(
            onPressed: () => _logout(context),
            icon: const Icon(Icons.logout_rounded),
            label: const Text('Cerrar sesión'),
          ),
        ],
      ),
    );
  }
}
