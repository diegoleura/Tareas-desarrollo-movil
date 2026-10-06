import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/cancion.dart';

class CancionesService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<List<Cancion>> obtenerCanciones() async {
    final data = await _client
        .from('canciones')
        .select()
        .order('titulo', ascending: true);

    return (data as List)
        .map((item) => Cancion.fromMap(Map<String, dynamic>.from(item)))
        .toList();
  }

  Future<void> agregarCancion({
    required String titulo,
    required String artista,
    String? album,
    int? anio,
    int? duracionSeg,
    required bool favorita,
  }) async {
    await _client.from('canciones').insert({
      'titulo': titulo,
      'artista': artista,
      'album': album,
      'anio': anio,
      'duracion_seg': duracionSeg,
      'favorita': favorita,
    });
  }

  Future<void> actualizarCancion({
    required int id,
    required String titulo,
    required String artista,
    String? album,
    int? anio,
    int? duracionSeg,
    required bool favorita,
  }) async {
    await _client.from('canciones').update({
      'titulo': titulo,
      'artista': artista,
      'album': album,
      'anio': anio,
      'duracion_seg': duracionSeg,
      'favorita': favorita,
    }).eq('id', id);
  }

  Future<void> cambiarFavorita(int id, bool favorita) async {
    await _client
        .from('canciones')
        .update({'favorita': favorita})
        .eq('id', id);
  }

  Future<void> eliminarCancion(int id) async {
    await _client.from('canciones').delete().eq('id', id);
  }
}
