class Game {
  final String id;
  final String name;
  final DateTime date;
  final String venue;
  final String status;
  final String statusDescription;
  final String statusDetail;
  final Team homeTeam;
  final Team awayTeam;
  final String homeScore;
  final String awayScore;

  const Game({
    required this.id,
    required this.name,
    required this.date,
    required this.venue,
    required this.status,
    required this.statusDescription,
    required this.statusDetail,
    required this.homeTeam,
    required this.awayTeam,
    required this.homeScore,
    required this.awayScore,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    final competition = (json['competitions'] as List).first;
    final competitors = competition['competitors'] as List;

    final home = competitors.firstWhere(
      (item) => item['homeAway'] == 'home',
    );
    final away = competitors.firstWhere(
      (item) => item['homeAway'] == 'away',
    );

    final statusData = competition['status']['type'];

    return Game(
      id: json['id']?.toString() ?? '',
      name: json['shortName']?.toString() ?? '',
      date: DateTime.parse(json['date'].toString()).toLocal(),
      venue: competition['venue']?['fullName']?.toString() ?? 'Estadio no disponible',
      status: statusData['state']?.toString() ?? 'pre',
      statusDescription: statusData['description']?.toString() ?? '',
      statusDetail: statusData['shortDetail']?.toString() ?? '',
      homeTeam: Team.fromJson(home['team']),
      awayTeam: Team.fromJson(away['team']),
      homeScore: home['score']?.toString() ?? '0',
      awayScore: away['score']?.toString() ?? '0',
    );
  }
}

class Team {
  final String name;
  final String abbreviation;
  final String logo;

  const Team({
    required this.name,
    required this.abbreviation,
    required this.logo,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      name: json['displayName']?.toString() ?? 'Equipo',
      abbreviation: json['abbreviation']?.toString() ?? '',
      logo: json['logo']?.toString() ?? '',
    );
  }
}
