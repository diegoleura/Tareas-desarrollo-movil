#  Pizza LeDo

Aplicación de pizzería creada como proyecto de Fundamentos de Desarrollo Móvil.

## Funciones incluidas

### Cliente
- Ver catálogo de pizzas.
- Consultar ingredientes y precio.
- Agregar ingredientes extra.
- Agregar productos al carrito.
- Cambiar cantidades.
- Eliminar productos del carrito.
- Ver total del pedido.
- Generar pedido.
- Ver sucursales en un mapa real con OpenStreetMap.

### Administrador
- Ver las pizzas registradas.
- Crear nuevas pizzas.
- Definir nombre, descripción, precio e ingredientes.
- Eliminar pizzas.

## Importante
Este proyecto guarda la información únicamente mientras la aplicación está abierta.
Eso lo hace fácil de ejecutar 



## Mapa
Se usa `flutter_map` + OpenStreetMap, por lo que NO necesitas crear una API Key
de Google Maps.

## Estructura importante

lib/
- main.dart
- models/
  - pizza.dart
  - cart_item.dart
  - branch.dart
- providers/
  - pizzeria_provider.dart
- screens/
  - role_screen.dart
  - client_home_screen.dart
  - pizza_detail_screen.dart
  - cart_screen.dart
  - branches_screen.dart
  - admin_screen.dart
  - add_pizza_screen.dart
- widgets/
  - pizza_card.dart
