import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/app_config.dart';
import '../models/place.dart';

class SupabaseService {
  SupabaseService._();

  static final SupabaseClient client = Supabase.instance.client;

  static User? get currentUser => client.auth.currentUser;

  static Future<List<Place>> getPlaces() async {
    final response = await client
        .from('places')
        .select()
        .order('created_at', ascending: false);

    return (response as List)
        .map((item) => Place.fromMap(item as Map<String, dynamic>))
        .toList();
  }

  static Future<Place> createPlace({
    required String name,
    required String category,
    required String description,
    required double latitude,
    required double longitude,
    String? photoUrl,
    String? photoPath,
  }) async {
    final user = currentUser;
    if (user == null) {
      throw Exception('No hay una sesión iniciada.');
    }

    final response = await client
        .from('places')
        .insert({
          'user_id': user.id,
          'name': name,
          'category': category,
          'description': description,
          'latitude': latitude,
          'longitude': longitude,
          'photo_url': photoUrl,
          'photo_path': photoPath,
        })
        .select()
        .single();

    return Place.fromMap(response);
  }

  static Future<void> updatePlace({
    required String id,
    required String name,
    required String category,
    required String description,
    required double latitude,
    required double longitude,
    String? photoUrl,
    String? photoPath,
  }) async {
    await client.from('places').update({
      'name': name,
      'category': category,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'photo_url': photoUrl,
      'photo_path': photoPath,
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', id);
  }

  static Future<void> deletePlace(Place place) async {
    if (place.photoPath != null && place.photoPath!.isNotEmpty) {
      try {
        await client.storage
            .from(AppConfig.storageBucket)
            .remove([place.photoPath!]);
      } catch (_) {
        // El registro se elimina aunque la foto ya no exista.
      }
    }

    await client.from('places').delete().eq('id', place.id);
  }

  static Future<String> uploadPhoto({
    required Uint8List bytes,
    required String path,
    required String contentType,
  }) async {
    await client.storage.from(AppConfig.storageBucket).uploadBinary(
          path,
          bytes,
          fileOptions: FileOptions(
            contentType: contentType,
            upsert: true,
          ),
        );

    return client.storage.from(AppConfig.storageBucket).getPublicUrl(path);
  }

  static Future<void> signOut() async {
    await client.auth.signOut();
  }
}
