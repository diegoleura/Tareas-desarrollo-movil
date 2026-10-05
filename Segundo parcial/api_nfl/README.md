# NFL Scoreboard - Flutter

Aplicación Flutter que consume la API pública de ESPN para mostrar los partidos de NFL.

## API utilizada

https://site.api.espn.com/apis/site/v2/sports/football/nfl/scoreboard


## Estructura

- `lib/main.dart`: inicia la aplicación.
- `lib/models/game.dart`: transforma el JSON de ESPN en objetos Dart.
- `lib/services/espn_service.dart`: realiza la petición HTTP.
- `lib/screens/home_screen.dart`: pantalla principal y estados de carga/error.
- `lib/widgets/game_card.dart`: tarjeta visual de cada partido.

## Flujo

API ESPN -> HTTP GET -> JSON -> Game.fromJson -> HomeScreen -> GameCard
