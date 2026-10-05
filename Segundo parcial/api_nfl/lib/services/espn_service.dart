import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/game.dart';

class EspnService {
  static const String _baseUrl =
      'https://site.api.espn.com/apis/site/v2/sports/football/nfl/scoreboard';

  Future<List<Game>> getGames() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode != 200) {
      throw Exception('No se pudo obtener la información de ESPN.');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final events = (data['events'] as List?) ?? [];

    return events
        .map((event) => Game.fromJson(event as Map<String, dynamic>))
        .toList();
  }
}
