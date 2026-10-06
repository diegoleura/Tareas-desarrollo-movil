import 'package:flutter/material.dart';

import '../models/cancion.dart';
import '../services/canciones_service.dart';
import 'form_cancion_screen.dart';

enum FiltroBiblioteca { todas, favoritas }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CancionesService _service = CancionesService();
  final TextEditingController _buscadorController = TextEditingController();

  List<Cancion> _canciones = [];
  bool _cargando = true;
  String? _error;
  FiltroBiblioteca _filtro = FiltroBiblioteca.todas;
  int? _anioSeleccionado;
  String? _artistaSeleccionado;

  @override
  void initState() {
    super.initState();
    _cargarCanciones();
    _buscadorController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _buscadorController.dispose();
    super.dispose();
  }

  Future<void> _cargarCanciones() async {
    setState(() {
      _cargando = true;
      _error = null;
    });

    try {
      final canciones = await _service.obtenerCanciones();
      if (!mounted) return;
      setState(() {
        _canciones = canciones;
        _cargando = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _cargando = false;
        _error = 'No se pudieron cargar las canciones.\n$e';
      });
    }
  }

  List<Cancion> get _filtradas {
    final texto = _buscadorController.text.trim().toLowerCase();

    final resultado = _canciones.where((c) {
      final coincideBusqueda = texto.isEmpty ||
          c.titulo.toLowerCase().contains(texto) ||
          c.artista.toLowerCase().contains(texto) ||
          (c.album?.toLowerCase().contains(texto) ?? false);

      final coincideFavorita =
          _filtro == FiltroBiblioteca.todas || c.favorita;

      final coincideAnio =
          _anioSeleccionado == null || c.anio == _anioSeleccionado;

      final coincideArtista =
          _artistaSeleccionado == null || c.artista == _artistaSeleccionado;

      return coincideBusqueda &&
          coincideFavorita &&
          coincideAnio &&
          coincideArtista;
    }).toList();

    return resultado;
  }

  List<int> get _anios {
    final valores = _canciones
        .map((c) => c.anio)
        .whereType<int>()
        .toSet()
        .toList()
      ..sort((a, b) => b.compareTo(a));
    return valores;
  }

  List<String> get _artistas {
    final valores = _canciones.map((c) => c.artista).toSet().toList()
      ..sort();
    return valores;
  }

  Future<void> _abrirFormulario([Cancion? cancion]) async {
    final resultado = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => FormCancionScreen(cancion: cancion),
      ),
    );

    if (resultado == true) {
      await _cargarCanciones();
    }
  }

  Future<void> _eliminar(Cancion cancion) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar canción'),
        content: Text('¿Quieres eliminar "${cancion.titulo}"?'),
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

    if (confirmar != true) return;

    try {
      await _service.eliminarCancion(cancion.id);
      await _cargarCanciones();
      if (!mounted) return;
      _mostrarMensaje('Canción eliminada');
    } catch (e) {
      if (!mounted) return;
      _mostrarMensaje('No se pudo eliminar: $e');
    }
  }

  Future<void> _toggleFavorita(Cancion cancion) async {
    try {
      await _service.cambiarFavorita(cancion.id, !cancion.favorita);
      await _cargarCanciones();
    } catch (e) {
      if (!mounted) return;
      _mostrarMensaje('No se pudo actualizar la favorita: $e');
    }
  }

  void _mostrarMensaje(String mensaje) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(mensaje)));
  }

  void _limpiarFiltros() {
    setState(() {
      _filtro = FiltroBiblioteca.todas;
      _anioSeleccionado = null;
      _artistaSeleccionado = null;
      _buscadorController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final canciones = _filtradas;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mi Biblioteca',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            tooltip: 'Actualizar',
            onPressed: _cargarCanciones,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _abrirFormulario(),
        icon: const Icon(Icons.add),
        label: const Text('Agregar'),
      ),
      body: RefreshIndicator(
        onRefresh: _cargarCanciones,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
          children: [
            const Text(
              'Tus canciones',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              '${_canciones.length} canciones en tu biblioteca',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 18),
            TextField(
              controller: _buscadorController,
              decoration: InputDecoration(
                hintText: 'Buscar por título, artista o álbum',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _buscadorController.text.isNotEmpty
                    ? IconButton(
                        onPressed: _buscadorController.clear,
                        icon: const Icon(Icons.clear),
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 14),
            _buildFiltros(context),
            const SizedBox(height: 18),
            if (_cargando)
              const Padding(
                padding: EdgeInsets.all(40),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_error != null)
              _buildError()
            else if (canciones.isEmpty)
              _buildVacio()
            else
              ...canciones.map(_buildCancionCard),
          ],
        ),
      ),
    );
  }

  Widget _buildFiltros(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ChoiceChip(
          label: const Text('Todas'),
          selected: _filtro == FiltroBiblioteca.todas,
          onSelected: (_) => setState(() {
            _filtro = FiltroBiblioteca.todas;
          }),
        ),
        ChoiceChip(
          label: const Text('⭐ Favoritas'),
          selected: _filtro == FiltroBiblioteca.favoritas,
          onSelected: (_) => setState(() {
            _filtro = FiltroBiblioteca.favoritas;
          }),
        ),
        DropdownButtonHideUnderline(
          child: DropdownButton<int>(
            value: _anios.contains(_anioSeleccionado) ? _anioSeleccionado : null,
            hint: const Text('Año'),
            items: [
              const DropdownMenuItem<int>(
                value: null,
                child: Text('Todos los años'),
              ),
              ..._anios.map(
                (anio) => DropdownMenuItem<int>(
                  value: anio,
                  child: Text(anio.toString()),
                ),
              ),
            ],
            onChanged: (value) => setState(() => _anioSeleccionado = value),
          ),
        ),
        DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: _artistas.contains(_artistaSeleccionado)
                ? _artistaSeleccionado
                : null,
            hint: const Text('Artista'),
            items: [
              const DropdownMenuItem<String>(
                value: null,
                child: Text('Todos los artistas'),
              ),
              ..._artistas.map(
                (artista) => DropdownMenuItem<String>(
                  value: artista,
                  child: Text(
                    artista,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
            onChanged: (value) =>
                setState(() => _artistaSeleccionado = value),
          ),
        ),
        if (_filtro != FiltroBiblioteca.todas ||
            _anioSeleccionado != null ||
            _artistaSeleccionado != null ||
            _buscadorController.text.isNotEmpty)
          TextButton.icon(
            onPressed: _limpiarFiltros,
            icon: const Icon(Icons.filter_alt_off),
            label: const Text('Limpiar'),
          ),
      ],
    );
  }

  Widget _buildCancionCard(Cancion cancion) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 8),
          leading: CircleAvatar(
            radius: 28,
            child: Icon(
              cancion.favorita
                  ? Icons.music_note_rounded
                  : Icons.library_music_rounded,
            ),
          ),
          title: Text(
            cancion.titulo,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              [
                cancion.artista,
                if (cancion.album != null && cancion.album!.isNotEmpty)
                  cancion.album!,
                if (cancion.anio != null) cancion.anio.toString(),
                if (cancion.duracionSeg != null) _formatearDuracion(cancion.duracionSeg!),
              ].join(' • '),
            ),
          ),
          trailing: PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'favorita') _toggleFavorita(cancion);
              if (value == 'editar') _abrirFormulario(cancion);
              if (value == 'eliminar') _eliminar(cancion);
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                value: 'favorita',
                child: Row(
                  children: [
                    Icon(
                      cancion.favorita
                          ? Icons.star
                          : Icons.star_border,
                    ),
                    const SizedBox(width: 10),
                    Text(cancion.favorita
                        ? 'Quitar favorita'
                        : 'Marcar favorita'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'editar',
                child: Row(
                  children: [
                    Icon(Icons.edit_outlined),
                    SizedBox(width: 10),
                    Text('Editar'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'eliminar',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline),
                    SizedBox(width: 10),
                    Text('Eliminar'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVacio() {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            const Icon(Icons.library_music_outlined, size: 60),
            const SizedBox(height: 12),
            const Text(
              'No encontramos canciones',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const Text(
              'Prueba con otro filtro o agrega una canción nueva.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: _limpiarFiltros,
              child: const Text('Limpiar filtros'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError() {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(Icons.error_outline, size: 48),
            const SizedBox(height: 12),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _cargarCanciones,
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }

  String _formatearDuracion(int segundos) {
    final minutos = segundos ~/ 60;
    final restantes = segundos % 60;
    return '$minutos:${restantes.toString().padLeft(2, '0')}';
  }
}
