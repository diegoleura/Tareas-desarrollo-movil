import 'package:flutter/material.dart';
import '../models/game.dart';
import '../services/espn_service.dart';
import '../widgets/game_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final EspnService _service = EspnService();
  late Future<List<Game>> _gamesFuture;

  final TextEditingController _searchController = TextEditingController();

  String _searchText = '';

  @override
  void initState() {
    super.initState();
    _loadGames();

    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text.toLowerCase();
      });
    });
  }

  void _loadGames() {
    _gamesFuture = _service.getGames();
  }

  Future<void> _refresh() async {
    setState(_loadGames);
    await _gamesFuture;
  }

  List<Game> _filterGames(List<Game> games) {
    if (_searchText.trim().isEmpty) {
      return games;
    }

    return games.where((game) {
      final homeTeam = game.homeTeam.name.toLowerCase();
      final awayTeam = game.awayTeam.name.toLowerCase();

      final homeAbbreviation =
          game.homeTeam.abbreviation.toLowerCase();

      final awayAbbreviation =
          game.awayTeam.abbreviation.toLowerCase();

      return homeTeam.contains(_searchText) ||
          awayTeam.contains(_searchText) ||
          homeAbbreviation.contains(_searchText) ||
          awayAbbreviation.contains(_searchText);
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF123B63),
        foregroundColor: Colors.white,
        title: const Row(
          children: [
            Icon(Icons.sports_football),
            SizedBox(width: 10),
            Text(
              'NFL Scoreboard',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Actualizar',
            onPressed: _refresh,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),

      body: RefreshIndicator(
        onRefresh: _refresh,

        child: FutureBuilder<List<Game>>(
          future: _gamesFuture,

          builder: (context, snapshot) {

            // Cargando información
            if (snapshot.connectionState ==
                ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            // Error
            if (snapshot.hasError) {
              return _ErrorView(
                onRetry: _refresh,
              );
            }

            final games = snapshot.data ?? [];

            // No hay partidos
            if (games.isEmpty) {
              return const Center(
                child: Text(
                  'No hay partidos disponibles.',
                ),
              );
            }

            // Filtrar partidos
            final filteredGames = _filterGames(games);

            return ListView(
              physics:
                  const AlwaysScrollableScrollPhysics(),

              padding: const EdgeInsets.fromLTRB(
                16,
                20,
                16,
                30,
              ),

              children: [

                const Text(
                  'Partidos de la semana',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  'Busca tu equipo para encontrar su partido',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 18),

                // BUSCADOR
                TextField(
                  controller: _searchController,

                  decoration: InputDecoration(
                    hintText:
                        'Buscar equipo...',

                    prefixIcon: const Icon(
                      Icons.search,
                    ),

                    suffixIcon:
                        _searchText.isNotEmpty
                            ? IconButton(
                                icon: const Icon(
                                  Icons.clear,
                                ),
                                onPressed: () {
                                  _searchController.clear();
                                },
                              )
                            : null,

                    filled: true,

                    fillColor: Colors.white,

                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(15),

                      borderSide: BorderSide.none,
                    ),

                    focusedBorder:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(15),

                      borderSide: const BorderSide(
                        color: Color(0xFF123B63),
                        width: 2,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // RESULTADOS
                if (filteredGames.isEmpty)
                  _NoResultsView(
                    searchText: _searchText,
                  )
                else
                  ...filteredGames.map(
                    (game) => GameCard(
                      game: game,
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _NoResultsView extends StatelessWidget {
  final String searchText;

  const _NoResultsView({
    required this.searchText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        children: [
          Icon(
            Icons.search_off,
            size: 55,
            color: Colors.grey.shade400,
          ),

          const SizedBox(height: 15),

          const Text(
            'No encontramos ese equipo',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'No hay partidos para "$searchText" '
            'en la semana actual.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final Future<void> Function() onRetry;

  const _ErrorView({
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),

        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,

          children: [

            Icon(
              Icons.cloud_off,
              size: 64,
              color: Colors.grey.shade500,
            ),

            const SizedBox(height: 16),

            const Text(
              'No pudimos cargar los partidos',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            Text(
              'Revisa tu conexión a internet '
              'e inténtalo de nuevo.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 20),

            FilledButton.icon(
              onPressed: onRetry,

              icon: const Icon(
                Icons.refresh,
              ),

              label: const Text(
                'Intentar de nuevo',
              ),
            ),
          ],
        ),
      ),
    );
  }
}