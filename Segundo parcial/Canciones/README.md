# Biblioteca de Canciones

Aplicación Flutter para administrar una biblioteca de canciones usando Supabase.

## Funciones

- Listar canciones.
- Buscar por título, artista o álbum.
- Filtrar por favoritas.
- Filtrar por año.
- Filtrar por artista.
- Agregar canciones.
- Editar canciones.
- Eliminar canciones.
- Marcar/desmarcar favoritas.

## Estructura

- `lib/main.dart`: inicia Flutter y Supabase.
- `lib/models/cancion.dart`: modelo de datos.
- `lib/services/canciones_service.dart`: operaciones CRUD.
- `lib/screens/home_screen.dart`: biblioteca, búsqueda y filtros.
- `lib/screens/form_cancion_screen.dart`: alta y edición.
