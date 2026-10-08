import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../models/place.dart';
import '../utils/app_helpers.dart';

class MapScreen extends StatefulWidget {
  final List<Place> places;

  const MapScreen({super.key, required this.places});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final _mapController = MapController();
  final LatLng _defaultCenter = const LatLng(22.1565, -100.9855);
  LatLng? _myLocation;
  Place? _selectedPlace;

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) return;

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      final point = LatLng(position.latitude, position.longitude);
      if (!mounted) return;
      setState(() => _myLocation = point);
      _mapController.move(point, 15);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final markers = <Marker>[
      ...widget.places.map(
        (place) => Marker(
          point: LatLng(place.latitude, place.longitude),
          width: 52,
          height: 60,
          child: GestureDetector(
            onTap: () => setState(() => _selectedPlace = place),
            child: Icon(
              categoryIcon(place.category),
              size: 42,
              color: categoryColor(context, place.category),
            ),
          ),
        ),
      ),
      if (_myLocation != null)
        Marker(
          point: _myLocation!,
          width: 48,
          height: 48,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).colorScheme.primary.withValues(alpha: .2),
            ),
            child: Center(
              child: Container(
                width: 15,
                height: 15,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.primary,
                  border: Border.all(color: Colors.white, width: 3),
                ),
              ),
            ),
          ),
        ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mapa',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _myLocation ?? _defaultCenter,
              initialZoom: 12.5,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.mislugaresfavoritos',
              ),
              MarkerLayer(markers: markers),
              RichAttributionWidget(
                attributions: [
                  TextSourceAttribution(
                    'OpenStreetMap contributors',
                    onTap: () {},
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            right: 14,
            top: 14,
            child: FloatingActionButton.small(
              heroTag: 'myLocationMap',
              onPressed: _getLocation,
              child: const Icon(Icons.my_location_rounded),
            ),
          ),
          if (_selectedPlace != null)
            Positioned(
              left: 14,
              right: 14,
              bottom: 18,
              child: _PlaceMapCard(
                place: _selectedPlace!,
                onClose: () => setState(() => _selectedPlace = null),
              ),
            ),
        ],
      ),
    );
  }
}

class _PlaceMapCard extends StatelessWidget {
  final Place place;
  final VoidCallback onClose;

  const _PlaceMapCard({
    required this.place,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final color = categoryColor(context, place.category);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            SizedBox(
              width: 62,
              height: 62,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: place.photoUrl != null && place.photoUrl!.isNotEmpty
                    ? Image.network(
                        place.photoUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Icon(
                          categoryIcon(place.category),
                          color: color,
                          size: 34,
                        ),
                      )
                    : Icon(
                        categoryIcon(place.category),
                        color: color,
                        size: 34,
                      ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    place.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  Text(place.category),
                  if (place.description.isNotEmpty)
                    Text(
                      place.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            IconButton(
              onPressed: onClose,
              icon: const Icon(Icons.close),
            ),
          ],
        ),
      ),
    );
  }
}
