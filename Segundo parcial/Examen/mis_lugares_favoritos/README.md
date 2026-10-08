# Mis Lugares Favoritos

Aplicación Flutter para guardar lugares favoritos y visualizarlos en OpenStreetMap.


## 4. Android

Al probar en un celular, acepta el permiso de ubicación cuando la aplicación lo solicite.

## 5. iPhone

El archivo `ios/Runner/Info.plist` incluye los mensajes para ubicación y fotos.

## 6. Lo que incluye

- Registro
- Inicio de sesion
- Sesion persistente
- Cerrar sesion
- Lista de lugares
- Busqueda por nombre
- Filtro por categoria
- Alta, edicion y eliminacion
- Seleccion de coordenadas tocando el mapa
- Ubicacion actual del celular
- Pines de lugares
- OpenStreetMap con flutter_map
- Fotos en Supabase Storage
- Perfil
- Contador de lugares
- Confirmacion antes de eliminar
- Modo claro/oscuro segun el sistema
- Manejo basico de errores y falta de conexion

## 7. Prueba recomendada

1. Crea una cuenta.
2. Inicia sesión.
3. Pulsa "Agregar".
4. Permite la ubicación.
5. Toca un punto del mapa.
6. Selecciona una foto.
7. Guarda.
8. Comprueba que aparece en la lista.
9. Abre el mapa y verifica el pin.
10. Edita el lugar.
11. Prueba búsqueda y categorías.
12. Elimina el lugar y confirma.

## Importante

No se usa Firebase. El backend es Supabase y el mapa usa OpenStreetMap.
