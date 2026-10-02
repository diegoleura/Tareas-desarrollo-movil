import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      title: 'Registro de Preferencias',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PreferencesScreen(),
    );
  }
}

class PreferencesScreen extends StatefulWidget {
  @override
  _PreferencesScreenState createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  String genero = 'Masculino';
  
  bool deporte = false;
  bool musica = false;
  bool cine = false;
  bool lectura = false;

  String paisSeleccionado = 'Mexico';
  List<String> paises = ['Mexico', 'Colombia', 'Argentina', 'España', 'Chile'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro de Preferencias', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12.0),
        child: Column(
          children: [
            // Seccion 1
            Card(
              color: Colors.blue.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.blue.shade200),
              ),
              child: Padding(
                padding: EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue),
                        SizedBox(width: 8),
                        Text(
                          'Seccion 1: Informacion General',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
                        ),
                      ],
                    ),
                    SizedBox(height: 6),
                    Text('Completa los siguientes datos personales basicos', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ),
            SizedBox(height: 12),

            // Seccion 2
            Card(
              color: Colors.green.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.green.shade200),
              ),
              child: Padding(
                padding: EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.person, color: Colors.green.shade700),
                        SizedBox(width: 8),
                        Text(
                          'Seccion 2: Datos Personales',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green.shade700),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    TextField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person_outline),
                        labelText: 'Nombre completo',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.calendar_today),
                        labelText: 'Edad',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 12),

            // Seccion 3
            Card(
              color: Colors.orange.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.orange.shade200),
              ),
              child: Padding(
                padding: EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.view_list, color: Colors.orange.shade800),
                        SizedBox(width: 8),
                        Text(
                          'Seccion 3: Distribucion en Filas',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.orange.shade800),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.red.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.circle, color: Colors.red, size: 18),
                          SizedBox(width: 10),
                          Text('Fila 1 - Color Rojo', style: TextStyle(fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                    SizedBox(height: 6),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.yellow.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.circle, color: Colors.yellow.shade700, size: 18),
                          SizedBox(width: 10),
                          Text('Fila 2 - Color Amarillo', style: TextStyle(fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                    SizedBox(height: 6),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.circle, color: Colors.blue, size: 18),
                          SizedBox(width: 10),
                          Text('Fila 3 - Color Azul', style: TextStyle(fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 12),

            // Seccion 4
            Card(
              color: Colors.purple.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.purple.shade200),
              ),
              child: Padding(
                padding: EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.grid_view, color: Colors.purple),
                        SizedBox(width: 8),
                        Text(
                          'Seccion 4: Cuatro Hijos en Colores',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.purple),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: 65,
                          height: 45,
                          decoration: BoxDecoration(
                            color: Colors.pink.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: Text('Hijo 1', style: TextStyle(color: Colors.pink.shade400, fontWeight: FontWeight.bold, fontSize: 12)),
                        ),
                        Container(
                          width: 65,
                          height: 45,
                          decoration: BoxDecoration(
                            color: Colors.orange.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: Text('Hijo 2', style: TextStyle(color: Colors.orange.shade400, fontWeight: FontWeight.bold, fontSize: 12)),
                        ),
                        Container(
                          width: 65,
                          height: 45,
                          decoration: BoxDecoration(
                            color: Colors.green.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: Text('Hijo 3', style: TextStyle(color: Colors.green.shade400, fontWeight: FontWeight.bold, fontSize: 12)),
                        ),
                        Container(
                          width: 65,
                          height: 45,
                          decoration: BoxDecoration(
                            color: Colors.purple.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: Text('Hijo 4', style: TextStyle(color: Colors.purple.shade400, fontWeight: FontWeight.bold, fontSize: 12)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 12),

            // Seccion 5
            Card(
              color: Colors.grey.shade100,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.shade300),
              ),
              child: Padding(
                padding: EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.add_circle_outline, color: Colors.black54),
                        SizedBox(width: 8),
                        Text(
                          'Seccion 5: Controles UI',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text('Genero:', style: TextStyle(fontWeight: FontWeight.bold)),
                    RadioListTile<String>(
                      title: Text('Masculino'),
                      value: 'Masculino',
                      groupValue: genero,
                      dense: true,
                      onChanged: (val) {
                        setState(() {
                          genero = val!;
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: Text('Femenino'),
                      value: 'Femenino',
                      groupValue: genero,
                      dense: true,
                      onChanged: (val) {
                        setState(() {
                          genero = val!;
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: Text('Otro'),
                      value: 'Otro',
                      groupValue: genero,
                      dense: true,
                      onChanged: (val) {
                        setState(() {
                          genero = val!;
                        });
                      },
                    ),
                    SizedBox(height: 10),
                    Text('Intereses:', style: TextStyle(fontWeight: FontWeight.bold)),
                    CheckboxListTile(
                      title: Text('Deporte'),
                      value: deporte,
                      dense: true,
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (val) {
                        setState(() {
                          deporte = val!;
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: Text('Musica'),
                      value: musica,
                      dense: true,
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (val) {
                        setState(() {
                          musica = val!;
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: Text('Cine'),
                      value: cine,
                      dense: true,
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (val) {
                        setState(() {
                          cine = val!;
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: Text('Lectura'),
                      value: lectura,
                      dense: true,
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (val) {
                        setState(() {
                          lectura = val!;
                        });
                      },
                    ),
                    SizedBox(height: 10),
                    Text('Pais:', style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      value: paisSeleccionado,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.language),
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      ),
                      items: paises.map((p) {
                        return DropdownMenuItem(value: p, child: Text(p));
                      }).toList(),
                      onChanged: (val) {
                        setState(() {
                          paisSeleccionado = val!;
                        });
                      },
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            onPressed: () {},
                            icon: Icon(Icons.visibility, color: Colors.white, size: 18),
                            label: Text('Mostrar Preferencias', style: TextStyle(color: Colors.white, fontSize: 12)),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            onPressed: () {},
                            icon: Icon(Icons.check_circle_outline, color: Colors.white, size: 18),
                            label: Text('Guardar Registro', style: TextStyle(color: Colors.white, fontSize: 12)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}