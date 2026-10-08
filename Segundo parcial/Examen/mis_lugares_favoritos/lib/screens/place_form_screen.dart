import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';

import '../config/app_config.dart';
import '../models/place.dart';
import '../services/supabase_service.dart';
import '../utils/app_helpers.dart';

class PlaceFormScreen extends StatefulWidget {
  final Place? place;

  const PlaceFormScreen({super.key, this.place});

  @override
  State<PlaceFormScreen> createState() => _PlaceFormScreenState();
}

class _PlaceFormScreenState extends State<PlaceFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _description = TextEditingController();
  final _mapController = MapController();

  final List<String> _categories = const [
    'Comida',
    'Estudio',
    'Diversión',
    'Ejercicio',
    'Trabajo',
    'Viaje',
    'Otro',
  ];

  String _category = 'Otro';
  LatLng _selected = const LatLng(22.1565, -100.9855);
  Uint8List? _photoBytes;
  String? _photoExtension;
  String? _photoContentType;
  bool _loading = false;
  bool _gettingLocation = false;

  @override
  void initState() {
    super.initState();
    final place = widget.place;
    if (place != null) {
      _name.text = place.name;
      _description.text = place.description;
      _category = _categories.contains(place.category) ? place.category : 'Otro';
      _selected = LatLng(place.latitude, place.longitude);
    } else {
      _useCurrentLocation(silent: true);
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _useCurrentLocation({bool silent = false}) async {
    if (_gettingLocation) return;
    setState(() => _gettingLocation = true);

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Activa la ubicación del celular.');
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        throw Exception('No se concedió permiso para usar la ubicación.');
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      final point = LatLng(position.latitude, position.longitude);
      if (!mounted) return;
      setState(() => _selected = point);
      _mapController.move(point, 16);
    } catch (error) {
      if (!silent && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.toString().replaceFirst('Exception: ', ''))),
        );
      }
    } finally {
      if (mounted) setState(() => _gettingLocation = false);
    }
  }

  Future<void> _pickPhoto() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 82,
      maxWidth: 1400,
    );

    if (image == null) return;

    final bytes = await image.readAsBytes();
    final extension = image.name.split('.').last.toLowerCase();

    setState(() {
      _photoBytes = bytes;
      _photoExtension = extension == 'png' ? 'png' : 'jpg';
      _photoContentType = extension == 'png' ? 'image/png' : 'image/jpeg';
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      String? photoUrl = widget.place?.photoUrl;
      String? photoPath = widget.place?.photoPath;

      if (_photoBytes != null) {
        final user = SupabaseService.currentUser;
        if (user == null) throw Exception('No hay una sesión iniciada.');

        final stamp = DateTime.now().millisecondsSinceEpoch;
        photoPath =
            '${user.id}/$stamp.${_photoExtension ?? 'jpg'}';

        photoUrl = await SupabaseService.uploadPhoto(
          bytes: _photoBytes!,
          path: photoPath,
          contentType: _photoContentType ?? 'image/jpeg',
        );
      }

      if (widget.place == null) {
        await SupabaseService.createPlace(
          name: _name.text.trim(),
          category: _category,
          description: _description.text.trim(),
          latitude: _selected.latitude,
          longitude: _selected.longitude,
          photoUrl: photoUrl,
          photoPath: photoPath,
        );
      } else {
        await SupabaseService.updatePlace(
          id: widget.place!.id,
          name: _name.text.trim(),
          category: _category,
          description: _description.text.trim(),
          latitude: _selected.latitude,
          longitude: _selected.longitude,
          photoUrl: photoUrl,
          photoPath: photoPath,
        );
      }

      if (!mounted) return;
      Navigator.pop(context);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(readableError(error))),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.place != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(editing ? 'Editar lugar' : 'Nuevo lugar'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 30),
          children: [
            TextFormField(
              controller: _name,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Nombre del lugar',
                prefixIcon: Icon(Icons.place_outlined),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Escribe un nombre';
                }
                return null;
              },
            ),
            const SizedBox(height: 14),
            DropdownButtonFormField<String>(
              value: _category,
              decoration: const InputDecoration(
                labelText: 'Categoría',
                prefixIcon: Icon(Icons.category_outlined),
              ),
              items: _categories
                  .map(
                    (item) => DropdownMenuItem(
                      value: item,
                      child: Text(item),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) setState(() => _category = value);
              },
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _description,
              maxLines: 3,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Descripción',
                alignLabelWithHint: true,
                prefixIcon: Icon(Icons.notes_outlined),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Ubicación',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: SizedBox(
                height: 310,
                child: Stack(
                  children: [
                    FlutterMap(
                      mapController: _mapController,
                      options: MapOptions(
                        initialCenter: _selected,
                        initialZoom: 15,
                        onTap: (_, point) {
                          setState(() => _selected = point);
                        },
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.example.mislugaresfavoritos',
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: _selected,
                              width: 54,
                              height: 54,
                              child: const Icon(
                                Icons.location_pin,
                                size: 50,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Positioned(
                      right: 12,
                      top: 12,
                      child: FloatingActionButton.small(
                        heroTag: 'currentLocation',
                        onPressed: _gettingLocation
                            ? null
                            : () => _useCurrentLocation(),
                        child: _gettingLocation
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.my_location_rounded),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Toca el mapa para elegir el punto exacto.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 18),
            Text(
              'Foto',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: _pickPhoto,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                height: 190,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Theme.of(context).dividerColor,
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                child: _photoBytes != null
                    ? Image.memory(_photoBytes!, fit: BoxFit.cover)
                    : widget.place?.photoUrl != null
                        ? Image.network(
                            widget.place!.photoUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                const _PhotoPlaceholder(),
                          )
                        : const _PhotoPlaceholder(),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 52,
              child: FilledButton.icon(
                onPressed: _loading ? null : _save,
                icon: _loading
                    ? const SizedBox(
                        width: 19,
                        height: 19,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.save_outlined),
                label: Text(editing ? 'Guardar cambios' : 'Guardar lugar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PhotoPlaceholder extends StatelessWidget {
  const _PhotoPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add_a_photo_outlined, size: 42),
          SizedBox(height: 8),
          Text('Toca para seleccionar una foto'),
        ],
      ),
    );
  }
}
