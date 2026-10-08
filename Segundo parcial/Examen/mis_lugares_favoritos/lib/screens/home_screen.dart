import 'package:flutter/material.dart';

import '../models/place.dart';
import '../services/supabase_service.dart';
import '../utils/app_helpers.dart';
import 'auth_screen.dart';
import 'map_screen.dart';
import 'place_form_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Place> _places = [];
  bool _loading = true;
  String _search = '';
  String _category = 'Todas';

  final List<String> _categories = const [
    'Todas',
    'Comida',
    'Estudio',
    'Diversión',
    'Ejercicio',
    'Trabajo',
    'Viaje',
    'Otro',
  ];

  @override
  void initState() {
    super.initState();
    _loadPlaces();
  }

  Future<void> _loadPlaces() async {
    setState(() => _loading = true);
    try {
      final places = await SupabaseService.getPlaces();
      if (mounted) setState(() => _places = places);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(readableError(error))),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  List<Place> get _filteredPlaces {
    final query = _search.trim().toLowerCase();
    return _places.where((place) {
      final matchesName =
          query.isEmpty || place.name.toLowerCase().contains(query);
      final matchesCategory =
          _category == 'Todas' || place.category == _category;
      return matchesName && matchesCategory;
    }).toList();
  }

  Future<void> _addPlace() async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const PlaceFormScreen()),
    );
    _loadPlaces();
  }

  Future<void> _editPlace(Place place) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PlaceFormScreen(place: place),
      ),
    );
    _loadPlaces();
  }

  Future<void> _deletePlace(Place place) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar lugar'),
        content: Text('¿Quieres eliminar "${place.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await SupabaseService.deletePlace(place);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lugar eliminado')),
      );
      _loadPlaces();
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(readableError(error))),
      );
    }
  }

  void _openMap() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MapScreen(places: _places),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final visible = _filteredPlaces;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mis Lugares',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: [
          IconButton(
            tooltip: 'Mapa',
            onPressed: _openMap,
            icon: const Icon(Icons.map_outlined),
          ),
          IconButton(
            tooltip: 'Perfil',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            ),
            icon: const Icon(Icons.person_outline_rounded),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addPlace,
        icon: const Icon(Icons.add_location_alt_outlined),
        label: const Text('Agregar'),
      ),
      body: RefreshIndicator(
        onRefresh: _loadPlaces,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tus lugares guardados',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${_places.length} ${_places.length == 1 ? 'lugar' : 'lugares'}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      onChanged: (value) => setState(() => _search = value),
                      decoration: const InputDecoration(
                        hintText: 'Buscar por nombre...',
                        prefixIcon: Icon(Icons.search_rounded),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 42,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _categories.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          final category = _categories[index];
                          return FilterChip(
                            label: Text(category),
                            selected: _category == category,
                            onSelected: (_) =>
                                setState(() => _category = category),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
            if (_loading)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(child: CircularProgressIndicator()),
              )
            else if (visible.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: _EmptyState(
                  hasPlaces: _places.isNotEmpty,
                  onAdd: _addPlace,
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
                sliver: SliverList.builder(
                  itemCount: visible.length,
                  itemBuilder: (context, index) {
                    final place = visible[index];
                    return _PlaceCard(
                      place: place,
                      onEdit: () => _editPlace(place),
                      onDelete: () => _deletePlace(place),
                      onMap: _openMap,
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _PlaceCard extends StatelessWidget {
  final Place place;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onMap;

  const _PlaceCard({
    required this.place,
    required this.onEdit,
    required this.onDelete,
    required this.onMap,
  });

  @override
  Widget build(BuildContext context) {
    final color = categoryColor(context, place.category);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onMap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              SizedBox(
                width: 78,
                height: 78,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(13),
                  child: place.photoUrl != null && place.photoUrl!.isNotEmpty
                      ? Image.network(
                          place.photoUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              _CategoryBox(color: color, place: place),
                        )
                      : _CategoryBox(color: color, place: place),
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      place.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(
                          categoryIcon(place.category),
                          size: 16,
                          color: color,
                        ),
                        const SizedBox(width: 5),
                        Text(place.category),
                      ],
                    ),
                    if (place.description.isNotEmpty) ...[
                      const SizedBox(height: 5),
                      Text(
                        place.description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'edit') onEdit();
                  if (value == 'delete') onDelete();
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(
                    value: 'edit',
                    child: Text('Editar'),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Text('Eliminar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryBox extends StatelessWidget {
  final Color color;
  final Place place;

  const _CategoryBox({required this.color, required this.place});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color.withValues(alpha: 0.12),
      child: Icon(
        categoryIcon(place.category),
        color: color,
        size: 32,
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final bool hasPlaces;
  final VoidCallback onAdd;

  const _EmptyState({
    required this.hasPlaces,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              hasPlaces
                  ? Icons.search_off_rounded
                  : Icons.location_off_outlined,
              size: 62,
            ),
            const SizedBox(height: 14),
            Text(
              hasPlaces
                  ? 'No encontré lugares con esos filtros'
                  : 'Todavía no tienes lugares',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            if (!hasPlaces) ...[
              const SizedBox(height: 8),
              const Text(
                'Agrega tu primer lugar y selecciónalo directamente en el mapa.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 18),
              FilledButton.icon(
                onPressed: onAdd,
                icon: const Icon(Icons.add),
                label: const Text('Agregar lugar'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
