import 'package:flutter/material.dart';

import '../models/cancion.dart';
import '../services/canciones_service.dart';

class FormCancionScreen extends StatefulWidget {
  final Cancion? cancion;

  const FormCancionScreen({super.key, this.cancion});

  @override
  State<FormCancionScreen> createState() => _FormCancionScreenState();
}

class _FormCancionScreenState extends State<FormCancionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _service = CancionesService();

  late final TextEditingController _tituloController;
  late final TextEditingController _artistaController;
  late final TextEditingController _albumController;
  late final TextEditingController _anioController;
  late final TextEditingController _duracionController;

  bool _favorita = false;
  bool _guardando = false;

  bool get _editando => widget.cancion != null;

  @override
  void initState() {
    super.initState();

    final c = widget.cancion;

    _tituloController = TextEditingController(text: c?.titulo ?? '');
    _artistaController = TextEditingController(text: c?.artista ?? '');
    _albumController = TextEditingController(text: c?.album ?? '');
    _anioController =
        TextEditingController(text: c?.anio?.toString() ?? '');
    _duracionController =
        TextEditingController(text: c?.duracionSeg?.toString() ?? '');
    _favorita = c?.favorita ?? false;
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _artistaController.dispose();
    _albumController.dispose();
    _anioController.dispose();
    _duracionController.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _guardando = true);

    try {
      final titulo = _tituloController.text.trim();
      final artista = _artistaController.text.trim();
      final album = _albumController.text.trim();
      final anioTexto = _anioController.text.trim();
      final duracionTexto = _duracionController.text.trim();

      final anio = anioTexto.isEmpty ? null : int.parse(anioTexto);
      final duracion =
          duracionTexto.isEmpty ? null : int.parse(duracionTexto);

      if (_editando) {
        await _service.actualizarCancion(
          id: widget.cancion!.id,
          titulo: titulo,
          artista: artista,
          album: album.isEmpty ? null : album,
          anio: anio,
          duracionSeg: duracion,
          favorita: _favorita,
        );
      } else {
        await _service.agregarCancion(
          titulo: titulo,
          artista: artista,
          album: album.isEmpty ? null : album,
          anio: anio,
          duracionSeg: duracion,
          favorita: _favorita,
        );
      }

      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      setState(() => _guardando = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo guardar: $e')),
      );
    }
  }

  String? _validarTexto(String? value, String campo) {
    if (value == null || value.trim().isEmpty) {
      return 'Escribe el $campo';
    }

    if (value.trim().length > 120) {
      return 'Máximo 120 caracteres';
    }

    return null;
  }

  String? _validarAnio(String? value) {
    if (value == null || value.trim().isEmpty) return null;

    final anio = int.tryParse(value.trim());

    if (anio == null) return 'Debe ser un número';
    if (anio < 1900 || anio > 2100) {
      return 'Usa un año entre 1900 y 2100';
    }

    return null;
  }

  String? _validarDuracion(String? value) {
    if (value == null || value.trim().isEmpty) return null;

    final duracion = int.tryParse(value.trim());

    if (duracion == null) return 'Debe ser un número';
    if (duracion <= 0) return 'Debe ser mayor que 0';

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_editando ? 'Editar canción' : 'Nueva canción'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              _editando
                  ? 'Modifica los datos de la canción'
                  : 'Agrega una canción a tu biblioteca',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 22),
            TextFormField(
              controller: _tituloController,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Título',
                prefixIcon: Icon(Icons.music_note),
              ),
              validator: (v) => _validarTexto(v, 'título'),
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _artistaController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Artista',
                prefixIcon: Icon(Icons.person_outline),
              ),
              validator: (v) => _validarTexto(v, 'artista'),
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _albumController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Álbum (opcional)',
                prefixIcon: Icon(Icons.album_outlined),
              ),
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _anioController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Año (opcional)',
                prefixIcon: Icon(Icons.calendar_today_outlined),
              ),
              validator: _validarAnio,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _duracionController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Duración en segundos (opcional)',
                prefixIcon: Icon(Icons.timer_outlined),
              ),
              validator: _validarDuracion,
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Marcar como favorita'),
              subtitle: const Text('Aparecerá al usar el filtro de favoritas'),
              value: _favorita,
              onChanged: _guardando
                  ? null
                  : (value) => setState(() => _favorita = value),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _guardando ? null : _guardar,
              icon: _guardando
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save_outlined),
              label: Text(_guardando ? 'Guardando...' : 'Guardar canción'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
