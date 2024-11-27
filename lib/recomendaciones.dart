import 'package:app/api/ApiConst.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Recomendaciones extends StatefulWidget {
  final String nombre;
  Recomendaciones({super.key, required this.nombre});

  @override
  State<Recomendaciones> createState() => _RecomendacionesState();
}

class _RecomendacionesState extends State<Recomendaciones> {
  List<dynamic> recomendaciones = [];
  Map<String, List<String>> groupedData = {};
  Widget _tipo = CircularProgressIndicator();

  @override
  void initState() {
    super.initState();
    obtenerRecomendaciones(widget.nombre);
  }

  Future<void> obtenerRecomendaciones(String nombre) async {
    final url =
        '${Api.url}/api/v1/recomendacion/obtener/$nombre'; // Cambia la URL según tu API

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        setState(() {
          recomendaciones = data['msg'];
          // Agrupamos los datos por título
          groupedData = {};
          for (var item in recomendaciones) {
            final titulo = item['titulo'];
            final nombre = item['nombre'];

            if (!groupedData.containsKey(titulo)) {
              groupedData[titulo] = [];
            }
            groupedData[titulo]?.add(nombre);
          }

          if (recomendaciones.isEmpty) {
            _tipo = Text("No se encontraron recomendaciones.");
          }
        });
      } else if (response.statusCode == 404) {
        setState(() {
          _tipo = Text("No se encontraron recomendaciones.");
        });
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error al realizar la solicitud: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: groupedData.isEmpty
          ? Center(child: _tipo)
          : ListView.builder(
              itemCount: groupedData.keys.length,
              itemBuilder: (context, index) {
                final titulo = groupedData.keys.elementAt(index);
                final nombres = groupedData[titulo]!;

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            titulo,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.pink,
                            ),
                          ),
                          SizedBox(height: 10),
                          ...nombres.map((nombre) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text(
                                '- $nombre',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            );
                          }).toList(),
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
