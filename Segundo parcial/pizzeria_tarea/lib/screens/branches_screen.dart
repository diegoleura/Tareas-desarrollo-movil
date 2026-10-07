import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../providers/pizzeria_provider.dart';

class BranchesScreen extends StatelessWidget {
  const BranchesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PizzeriaProvider>();
    final branches = provider.branches;

    return Scaffold(
      appBar: AppBar(title: const Text('Sucursales')),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: FlutterMap(
              options: const MapOptions(
                initialCenter: LatLng(22.1516, -100.9760),
                initialZoom: 12.5,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.pizzeria_tarea',
                ),
                MarkerLayer(
                  markers: branches
                      .map(
                        (branch) => Marker(
                          point: LatLng(branch.latitude, branch.longitude),
                          width: 52,
                          height: 52,
                          child: Tooltip(
                            message: branch.name,
                            child: const Icon(
                              Icons.location_pin,
                              size: 46,
                              color: Color(0xFFC62828),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: branches.length,
              itemBuilder: (context, index) {
                final branch = branches[index];
                return Card(
                  child: ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.storefront),
                    ),
                    title: Text(branch.name),
                    subtitle: Text(
                      '${branch.address}\n${branch.schedule}',
                    ),
                    isThreeLine: true,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
