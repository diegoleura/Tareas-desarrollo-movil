import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Reserva de Viaje',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Color(0xFFF4F6F8),
      ),
      home: PantallaReserva(),
    );
  }
}

class PantallaReserva extends StatefulWidget {
  @override
  _PantallaReservaState createState() => _PantallaReservaState();
}

class _PantallaReservaState extends State<PantallaReserva> {
  // Controllers
  TextEditingController nombreController = TextEditingController();
  TextEditingController correoController = TextEditingController();

  // Variables de estado
  String destinoSeleccionado = 'Playa';
  String transporteSeleccionado = 'Avion';
  
  bool hotelIncluido = false;
  bool tourGuiado = false;
  bool seguroViaje = false;
  bool recibirNotificaciones = true;

  double presupuesto = 3000;
  DateTime? fechaViaje;

  // Limpiar campos
  void limpiarCampos() {
    setState(() {
      nombreController.clear();
      correoController.clear();
      destinoSeleccionado = 'Playa';
      transporteSeleccionado = 'Avion';
      hotelIncluido = false;
      tourGuiado = false;
      seguroViaje = false;
      recibirNotificaciones = true;
      presupuesto = 3000;
      fechaViaje = null;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Formulario limpiado')),
    );
  }

  // Helper para mostrar SnackBar
  void mostrarSnackBar(String mensaje) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        duration: Duration(seconds: 2),
      ),
    );
  }

  // Formatear fecha
  String obtenerTextoFecha() {
    if (fechaViaje == null) {
      return 'Toca para elegir fecha';
    }
    return '${fechaViaje!.day.toString().padLeft(2, '0')}/${fechaViaje!.month.toString().padLeft(2, '0')}/${fechaViaje!.year}';
  }

  // Obtener cadena de extras
  String obtenerExtrasTexto() {
    List<String> extras = [];
    if (hotelIncluido) extras.add('Hotel');
    if (tourGuiado) extras.add('Tour');
    if (seguroViaje) extras.add('Seguro');
    return extras.isEmpty ? 'Ninguno' : extras.join(', ');
  }

  // Validaciones
  bool esFormularioValido() {
    String nombre = nombreController.text.trim();
    String correo = correoController.text.trim();
    return nombre.isNotEmpty && correo.contains('@') && fechaViaje != null;
  }

  // Mostrar Dialog de Error
  void mostrarDialogoError() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.red.shade100,
              child: Icon(Icons.error_outline, color: Colors.red),
            ),
            SizedBox(width: 10),
            Text('Faltan datos'),
          ],
        ),
        content: Text('Completa nombre, correo válido (@) y selecciona la fecha del viaje.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Entendido', style: TextStyle(color: Colors.teal)),
          ),
        ],
      ),
    );
  }

  // Mostrar Dialog Resumen
  void mostrarDialogoResumen() {
    if (!esFormularioValido()) {
      mostrarDialogoError();
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.teal.shade100,
              child: Icon(Icons.cleaning_services, color: Colors.teal),
            ),
            SizedBox(width: 10),
            Text('Resumen del Viaje', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              dense: true,
              leading: Icon(Icons.person, color: Colors.teal),
              title: Text('Nombre: ${nombreController.text}'),
            ),
            ListTile(
              dense: true,
              leading: Icon(Icons.email, color: Colors.teal),
              title: Text('Correo: ${correoController.text}'),
            ),
            ListTile(
              dense: true,
              leading: Icon(Icons.location_on, color: Colors.teal),
              title: Text('Destino: $destinoSeleccionado'),
            ),
            ListTile(
              dense: true,
              leading: Icon(Icons.directions_bus, color: Colors.teal),
              title: Text('Transporte: $transporteSeleccionado'),
            ),
            ListTile(
              dense: true,
              leading: Icon(Icons.star, color: Colors.teal),
              title: Text('Extras: ${obtenerExtrasTexto()}'),
            ),
            ListTile(
              dense: true,
              leading: Icon(Icons.notifications, color: Colors.teal),
              title: Text('Notificaciones: ${recibirNotificaciones ? 'Activadas' : 'Desactivadas'}'),
            ),
            ListTile(
              dense: true,
              leading: Icon(Icons.attach_money, color: Colors.teal),
              title: Text('Presupuesto: \$${presupuesto.toInt()}'),
            ),
            ListTile(
              dense: true,
              leading: Icon(Icons.calendar_today, color: Colors.teal),
              title: Text('Fecha: ${obtenerTextoFecha()}'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cerrar', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              irAPantallaBoleto();
            },
            child: Text('Confirmar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void irAPantallaBoleto() {
    if (!esFormularioValido()) {
      mostrarDialogoError();
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PantallaBoleto(
          nombre: nombreController.text,
          correo: correoController.text,
          destino: destinoSeleccionado,
          transporte: transporteSeleccionado,
          extras: obtenerExtrasTexto(),
          notificaciones: recibirNotificaciones ? 'Activadas' : 'Desactivadas',
          presupuesto: presupuesto.toInt().toString(),
          fecha: obtenerTextoFecha(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reserva de Viaje', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal.shade700,
        actions: [
          IconButton(
            icon: Icon(Icons.cleaning_services, color: Colors.white),
            onPressed: limpiarCampos,
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12.0),
        child: Column(
          children: [
            // Sección 1
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.teal.shade50,
                          child: Icon(Icons.info_outline, color: Colors.teal),
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Seccion 1 - Informacion general', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                            Text('Completa tu reserva paso a paso', style: TextStyle(color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                    Divider(height: 20),
                    Text('Llena tus datos, elige destino y confirma tu viaje.', style: TextStyle(color: Colors.grey.shade700)),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),

            // Sección 2
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.green.shade50,
                          child: Icon(Icons.person, color: Colors.green),
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Sección 2 - Datos del viajero', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.green.shade800)),
                            Text('¿Quién se va de viaje?', style: TextStyle(color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    TextField(
                      controller: nombreController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person, color: Colors.green),
                        hintText: 'Ej: Ana Garcia',
                        labelText: 'Nombre completo',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: correoController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email, color: Colors.green),
                        hintText: 'Ej: ana@correo.com',
                        labelText: 'Correo electronico',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),

            // Sección 3
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.orange.shade50,
                          child: Icon(Icons.location_on, color: Colors.orange.shade800),
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Sección 3 - Destino y transporte', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.orange.shade800)),
                            Text('Elige tu aventura', style: TextStyle(color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _tarjetaDestino('Playa', Icons.beach_access, Colors.blue),
                        _tarjetaDestino('Ciudad', Icons.location_city, Colors.orange),
                        _tarjetaDestino('Montaña', Icons.landscape, Colors.green),
                      ],
                    ),
                    SizedBox(height: 12),
                    Text('Transporte:', style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      value: transporteSeleccionado,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.directions_bus, color: Colors.orange.shade800),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      ),
                      items: ['Avion', 'Autobus', 'Tren', 'Barco'].map((t) {
                        return DropdownMenuItem(value: t, child: Text(t));
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() {
                            transporteSeleccionado = val;
                          });
                          mostrarSnackBar('Transporte seleccionado: $val');
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),

            // Sección 4
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.purple.shade50,
                          child: Icon(Icons.tune, color: Colors.purple),
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Sección 4 - Extras y preferencias', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.purple)),
                            Text('Personaliza tu experiencia', style: TextStyle(color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    _checkboxContainer('Hotel incluido', '+\$1200', Icons.hotel, hotelIncluido, (val) {
                      setState(() { hotelIncluido = val!; });
                      mostrarSnackBar(hotelIncluido ? 'Hotel agregado' : 'Hotel removido');
                    }),
                    SizedBox(height: 6),
                    _checkboxContainer('Tour guiado', '+\$600', Icons.tour, tourGuiado, (val) {
                      setState(() { tourGuiado = val!; });
                      mostrarSnackBar(tourGuiado ? 'Tour agregado' : 'Tour removido');
                    }),
                    SizedBox(height: 6),
                    _checkboxContainer('Seguro de viaje', '+\$400', Icons.health_and_safety, seguroViaje, (val) {
                      setState(() { seguroViaje = val!; });
                      mostrarSnackBar(seguroViaje ? 'Seguro agregado' : 'Seguro removido');
                    }),
                    SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: recibirNotificaciones ? Colors.purple.shade50 : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: SwitchListTile(
                        title: Text('Recibir notificaciones', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        subtitle: Text(recibirNotificaciones ? 'Activadas' : 'Desactivadas', style: TextStyle(color: Colors.teal)),
                        value: recibirNotificaciones,
                        activeColor: Colors.purple,
                        onChanged: (val) {
                          setState(() { recibirNotificaciones = val; });
                          mostrarSnackBar(recibirNotificaciones ? 'Notificaciones activadas' : 'Notificaciones desactivadas');
                        },
                      ),
                    ),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Presupuesto:', style: TextStyle(fontWeight: FontWeight.bold)),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.purple,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text('\$${presupuesto.toInt()}', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    Slider(
                      value: presupuesto,
                      min: 500,
                      max: 10000,
                      divisions: 20,
                      activeColor: Colors.purple,
                      onChanged: (val) {
                        setState(() { presupuesto = val; });
                      },
                    ),
                    SizedBox(height: 10),
                    InkWell(
                      onTap: () async {
                        DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2030),
                        );
                        if (picked != null) {
                          setState(() { fechaViaje = picked; });
                          mostrarSnackBar('Fecha seleccionada: ${obtenerTextoFecha()}');
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.purple.shade50,
                              child: Icon(Icons.calendar_month, color: Colors.purple),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Fecha del viaje', style: TextStyle(color: Colors.grey, fontSize: 12)),
                                  Text(obtenerTextoFecha(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                ],
                              ),
                            ),
                            Icon(Icons.chevron_right, color: Colors.grey),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),

            // Sección 5
            Container(
              padding: EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.teal.shade800,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.check_circle_outline, color: Colors.white),
                      SizedBox(width: 8),
                      Text('Sección 5 · Confirmar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text('Revisa tus datos antes de despegar', style: TextStyle(color: Colors.white70, fontSize: 12)),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.teal.shade800,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: mostrarDialogoResumen,
                          icon: Icon(Icons.visibility_outlined, size: 18),
                          label: Text('Ver Resumen', style: TextStyle(fontSize: 12)),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: irAPantallaBoleto,
                          icon: Icon(Icons.send, size: 18),
                          label: Text('Confirmar', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tarjetaDestino(String nombre, IconData icono, Color color) {
    bool seleccionada = destinoSeleccionado == nombre;
    return InkWell(
      onTap: () {
        setState(() {
          destinoSeleccionado = nombre;
        });
        mostrarSnackBar('Destino seleccionado: $nombre');
      },
      child: Container(
        width: 90,
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: seleccionada ? color.withOpacity(0.15) : Colors.grey.shade50,
          border: Border.all(
            color: seleccionada ? color : Colors.grey.shade300,
            width: seleccionada ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Icon(icono, color: color, size: 28),
            SizedBox(height: 6),
            Text(
              nombre,
              style: TextStyle(
                color: color,
                fontWeight: seleccionada ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _checkboxContainer(String titulo, String precio, IconData icono, bool valor, ValueChanged<bool?> onChanged) {
    return Container(
      decoration: BoxDecoration(
        color: valor ? Colors.purple.shade50 : Colors.white,
        border: Border.all(color: valor ? Colors.purple : Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: CheckboxListTile(
        title: Text(titulo, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        subtitle: Text(precio, style: TextStyle(color: Colors.grey, fontSize: 12)),
        secondary: Icon(icono, color: Colors.grey.shade700),
        value: valor,
        activeColor: Colors.purple,
        onChanged: onChanged,
      ),
    );
  }
}

// Pantalla 2: Mi Boleto
class PantallaBoleto extends StatelessWidget {
  final String nombre;
  final String correo;
  final String destino;
  final String transporte;
  final String extras;
  final String notificaciones;
  final String presupuesto;
  final String fecha;

  PantallaBoleto({
    required this.nombre,
    required this.correo,
    required this.destino,
    required this.transporte,
    required this.extras,
    required this.notificaciones,
    required this.presupuesto,
    required this.fecha,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mi Boleto', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal.shade700,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 3,
                child: Column(
                  children: [
                    // Header del Boleto
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.teal.shade700,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(Icons.flight_takeoff, color: Colors.white),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.amber,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(fecha, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: Colors.white24,
                            child: Icon(Icons.flight, color: Colors.white, size: 28),
                          ),
                          SizedBox(height: 8),
                          Text('¡Buen viaje, $nombre!', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                          Text(destino.toUpperCase(), style: TextStyle(color: Colors.white70, fontSize: 12, letterSpacing: 1.5)),
                        ],
                      ),
                    ),
                    
                    // Imagen / Ilustración
                    ClipRRect(
                      child: Image.network(
                        'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=500',
                        height: 120,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (ctx, err, stack) => Container(
                          height: 100,
                          color: Colors.teal.shade50,
                          child: Icon(Icons.landscape, size: 50, color: Colors.teal),
                        ),
                      ),
                    ),

                    // Detalles del Boleto
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: ListView(
                          children: [
                            ListTile(
                              dense: true,
                              leading: CircleAvatar(backgroundColor: Colors.teal.shade50, child: Icon(Icons.email, color: Colors.teal, size: 18)),
                              title: Text('Correo', style: TextStyle(fontSize: 11, color: Colors.grey)),
                              subtitle: Text(correo, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                            ),
                            ListTile(
                              dense: true,
                              leading: CircleAvatar(backgroundColor: Colors.orange.shade50, child: Icon(Icons.location_on, color: Colors.orange, size: 18)),
                              title: Text('Destino', style: TextStyle(fontSize: 11, color: Colors.grey)),
                              subtitle: Text(destino, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                              trailing: Container(
                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.grey.shade300),
                                ),
                                child: Text(transporte, style: TextStyle(fontSize: 12)),
                              ),
                            ),
                            ListTile(
                              dense: true,
                              leading: CircleAvatar(backgroundColor: Colors.purple.shade50, child: Icon(Icons.star, color: Colors.purple, size: 18)),
                              title: Text('Extras', style: TextStyle(fontSize: 11, color: Colors.grey)),
                              subtitle: Text(extras, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                            ),
                            ListTile(
                              dense: true,
                              leading: CircleAvatar(backgroundColor: Colors.blue.shade50, child: Icon(Icons.notifications, color: Colors.blue, size: 18)),
                              title: Text('Notificaciones', style: TextStyle(fontSize: 11, color: Colors.grey)),
                              subtitle: Text(notificaciones, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                              trailing: Text('\$$presupuesto', style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold, fontSize: 16)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal.shade800,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back, color: Colors.white),
                label: Text('Regresar y editar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}