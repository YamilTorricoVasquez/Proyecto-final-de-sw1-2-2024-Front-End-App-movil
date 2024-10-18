import 'package:app/api/ApiConst.dart';
import 'package:app/editar_datos_bebe.dart';
import 'package:app/function/varGlobales.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ListaBebe extends StatefulWidget {
  const ListaBebe({super.key});

  @override
  State<ListaBebe> createState() => _ListaBebeState();
}

class _ListaBebeState extends State<ListaBebe> {
  List<dynamic> bebes = [];
  Widget _tipo = CircularProgressIndicator();
  Future<void> obtenerBebeUsuario(String ci) async {
    final url =
        '${Api.api}:${Api.port.toString()}/api/v1/bebe/obtener/$ci'; // Cambia 'localhost' si es necesario

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          // print(_nombreUsuario);
          bebes = data['msg']; // Actualiza el estado
        });
      } else if (response.statusCode == 404) {
        setState(() {
          _tipo = Text("No registro ningun bebe.");
        });

        print('Datos no encontrados');
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error al realizar la solicitud: $error');
    }
  }

  @override
  void initState() {
    super.initState();

    obtenerBebeUsuario(Globals.ci);
    print("VERIFICANDO VG: " + Globals.ci);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: bebes.isEmpty
          ? Center(
              child: _tipo,
            ) // Mientras carga, muestra un indicador
          : ListView.builder(
              itemCount: bebes.length,
              itemBuilder: (context, index) {
                final bebe = bebes[index];
                // Convertir la fecha desde la cadena
                DateTime fechaNacimiento =
                    DateTime.parse(bebe['fecha_nacimiento']);

                // Formatear la fecha en el formato deseado
                String fechaFormateada =
                    DateFormat('dd/MM/yyyy').format(fechaNacimiento);
                return InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditarDatosBebe(
                            nombre: bebe['nombre'],
                            fecha_nacimiento: fechaFormateada,
                            genero: bebe['genero'],
                          ),
                        ));
                  },
                  child: Card(
                    child: ListTile(
                      title: Text('Nombre: ${bebe['nombre']}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Convertir la fecha desde la cadena

                          Text('Fecha de Nacimiento: $fechaFormateada'),
                          Text('Género: ${bebe['genero']}'),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
