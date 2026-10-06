class Cancion {
  final int id;
  final String titulo;
  final String artista;
  final String? album;
  final int? anio;
  final int? duracionSeg;
  final bool favorita;
  final DateTime? createdAt;

  const Cancion({
    required this.id,
    required this.titulo,
    required this.artista,
    this.album,
    this.anio,
    this.duracionSeg,
    required this.favorita,
    this.createdAt,
  });

  factory Cancion.fromMap(Map<String, dynamic> map) {
    return Cancion(
      id: (map['id'] as num).toInt(),
      titulo: map['titulo'] as String,
      artista: map['artista'] as String,
      album: map['album'] as String?,
      anio: (map['anio'] as num?)?.toInt(),
      duracionSeg: (map['duracion_seg'] as num?)?.toInt(),
      favorita: map['favorita'] as bool? ?? false,
      createdAt: map['created_at'] == null
          ? null
          : DateTime.tryParse(map['created_at'].toString()),
    );
  }

  Map<String, dynamic> toInsertMap() {
    return {
      'titulo': titulo,
      'artista': artista,
      'album': album,
      'anio': anio,
      'duracion_seg': duracionSeg,
      'favorita': favorita,
    };
  }

  Map<String, dynamic> toUpdateMap() {
    return toInsertMap();
  }
}
