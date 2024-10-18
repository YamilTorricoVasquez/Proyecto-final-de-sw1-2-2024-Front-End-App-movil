import 'package:app/api/ApiConst.dart';
import 'package:app/home_page.dart';
import 'package:app/lista_bebe.dart';
import 'package:app/login.dart';
import 'package:app/registro_bebe.dart';
import 'package:app/function/varGlobales.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Inicio extends StatefulWidget {
  const Inicio({super.key});

  @override
  State<Inicio> createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  String _nombreUsuario = '';
  @override
  void initState() {
    super.initState();

    obtenerNombreUsuario(Globals.email);
    obtenerCiUsuario(Globals.email);
    print("VERIFICANDO VG: " + Globals.ci);
  }

  Future<void> obtenerNombreUsuario(String email) async {
    final url =
        '${Api.api}:${Api.port.toString()}/api/v1/users/nombre/$email'; // Cambia 'localhost' si es necesario

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          // print(_nombreUsuario);
          _nombreUsuario = data['msg']; // Actualiza el estado
        });
      } else if (response.statusCode == 404) {
        print('Usuario no encontrado');
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error al realizar la solicitud: $error');
    }
  }

  Future<void> obtenerCiUsuario(String email) async {
    final url =
        '${Api.api}:${Api.port.toString()}/api/v1/users/ci/$email'; // Cambia 'localhost' si es necesario

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          // print(_nombreUsuario);
          Globals.ci = data['msg']; // Actualiza el estado
        });
      } else if (response.statusCode == 404) {
        print('Usuario no encontrado');
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error al realizar la solicitud: $error');
    }
  }

  Widget _widget = const Text("Bienvenido");
  late Color _colors = Colors.pink;
  late Color _colors1 = Colors.pink;
  late Color _colors2 = Colors.pink;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.pink[200]),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green[200],
              ),
              // child: Text("FOTO"),

              child: InkWell(
                child: Column(
                  children: [
                    Image.asset(
                      'images/logoBaby.png',
                      width: 100,
                    ),
                    Text(_nombreUsuario)
                  ],
                ),
                onTap: () {
                  setState(() {
                    _widget = const Text("Bienvenido");
                    //_widget = widget.prueba;
                  });
                },
              ),
            ),
            ListTile(
              title: Text(
                "INTERPRETADOR DE LLANTOS",
                style: TextStyle(
                  fontSize: 15, // Tamaño de la fuente
                  fontWeight: FontWeight.bold, // Peso de la fuente (negrita)
                  //fontStyle: FontStyle., // Fuente en cursiva
                  color: _colors, // Color del texto
                  letterSpacing: 4.0, // Espaciado entre letras
                  fontFamily:
                      'Roboto', // Familia de la fuente, puedes usar la que prefieras
                ),
              ),
            //  textColor: ,
              onTap: () {
                setState(
                  () {
                    _colors = Colors.green.shade200;
                    _colors1 = Colors.pink;
                    _colors2 = Colors.pink;
                    _widget = const HomePage();
                  },
                );
              },
            ),
            ListTile(
              title: Text(
                "REGISTRAR BEBE",
                style: TextStyle(
                  fontSize: 15, // Tamaño de la fuente
                  fontWeight: FontWeight.bold, // Peso de la fuente (negrita)
                  //fontStyle: FontStyle., // Fuente en cursiva
                  color: _colors1, // Color del texto
                  letterSpacing: 4.0, // Espaciado entre letras
                  fontFamily:
                      'Roboto', // Familia de la fuente, puedes usar la que prefieras
                ),
              ),
              onTap: () {
                setState(
                  () {
                    _colors = Colors.pink;
                    _colors1 = Colors.green.shade200;
                    _colors2 = Colors.pink;
                    _widget = const RegistroBebe();
                    //_widget = Text(Globals.ci);
                  },
                );
              },
            ),
            ListTile(
              title: Text(
                "LISTA BEBE",
                style: TextStyle(
                  fontSize: 15, // Tamaño de la fuente
                  fontWeight: FontWeight.bold, // Peso de la fuente (negrita)
                  //fontStyle: FontStyle., // Fuente en cursiva
                  color: _colors2, // Color del texto
                  letterSpacing: 4.0, // Espaciado entre letras
                  fontFamily:
                      'Roboto', // Familia de la fuente, puedes usar la que prefieras
                ),
              ),
             // textColor: ,
              onTap: () {
                setState(
                  () {
                    _colors2 = Colors.green.shade200;
                    _colors = Colors.pink;
                    _colors1 = Colors.pink;
                    _widget = const ListaBebe();
                  },
                );
              },
            ),
            ListTile(
              title: const Text("C E R R A R   S E S I O N"),
              textColor: Colors.pink,
              onTap: () async {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Login(),
                  ),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
      body: _widget,
    );
  }
}
