import 'package:app/api/ApiConst.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Recomendaciones extends StatefulWidget {
  final String nombre;
  final int id_bebe;
  Recomendaciones({super.key, required this.nombre, required this.id_bebe});

  @override
  State<Recomendaciones> createState() => _RecomendacionesState();
}

class _RecomendacionesState extends State<Recomendaciones> {
  List<dynamic> recomendaciones = [];
  Map<String, List<String>> groupedData = {};
  List<dynamic> interpretadores = [];
  bool cargando = true;
  String mensajeError = "";

  @override
  void initState() {
    super.initState();
    obtenerdatosinterpretadorbebe(widget.id_bebe);
  }

  Future<void> obtenerRecomendaciones(String nombre) async {
    final url = '${Api.url}/api/v1/recomendacion/obtener/$nombre';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        List<dynamic> recs = data['msg'];
        Map<String, List<String>> grouped = {};
        
        for (var item in recs) {
          final titulo = item['titulo'];
          final descripcion = item['descripcion'];

          if (!grouped.containsKey(titulo)) {
            grouped[titulo] = [];
          }
          grouped[titulo]?.add(descripcion);
        }

        // return {'recomendaciones': recs, 'groupedData': grouped};
      } else {
        return null;
      }
    } catch (error) {
      print('Error al realizar la solicitud: $error');
      return null;
    }
  }

  Future<void> obtenerdatosinterpretadorbebe(int id_bebe) async {
    setState(() {
      cargando = true;
      mensajeError = "";
    });

    final url = '${Api.url}/api/v1/informacion/obtener/$id_bebe';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['msg'] != null && data['msg'] is List) {
          setState(() {
            interpretadores = data['msg'];
            cargando = false;
          });
        } else {
          setState(() {
            mensajeError = "No se encontraron datos para este bebé.";
            interpretadores = [];
            cargando = false;
          });
        }
      } else {
        setState(() {
          mensajeError =
              "Error ${response.statusCode}: No se pudo cargar la información.";
          interpretadores = [];
          cargando = false;
        });
      }
    } catch (error) {
      setState(() {
        mensajeError = "Error al realizar la solicitud: $error";
        interpretadores = [];
        cargando = false;
      });
    }
  }

void mostrarModalRecomendaciones(String nombreInterpretador) async {
    // Mostrar modal con indicador de carga
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 20),
                Text('Cargando recomendaciones...'),
              ],
            ),
          ),
        );
      },
    );

    // Codificar el nombre del interpretador para la URL
    final nombreCodificado = Uri.encodeComponent(nombreInterpretador);
    final url = '${Api.url}/api/v1/recomendacion/obtener/$nombreCodificado';
    
    try {
      final response = await http.get(Uri.parse(url));
      
      // Cerrar modal de carga
      Navigator.of(context).pop();

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<dynamic> recs = data['msg'] ?? [];
        
        // Agrupar por el texto antes de los dos puntos
        Map<String, List<String>> grouped = {};
        
        for (var item in recs) {
          final nombreCompleto = item['nombre'] ?? '';
          
          // Separar por los dos puntos
          List<String> partes = nombreCompleto.split(':');
          
          String titulo;
          String descripcion;
          
          if (partes.length >= 2) {
            titulo = partes[0].trim(); // Texto antes de los dos puntos
            descripcion = partes.sublist(1).join(':').trim(); // Todo después de los dos puntos
          } else {
            // Si no hay dos puntos, usar todo como descripción
            titulo = 'Recomendaciones generales';
            descripcion = nombreCompleto;
          }

          if (!grouped.containsKey(titulo)) {
            grouped[titulo] = [];
          }
          grouped[titulo]?.add(descripcion);
        }

        // Mostrar modal con recomendaciones
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header del modal
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              'Recomendaciones: $nombreInterpretador',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.close, color: Colors.white),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
                    ),
                    // Contenido del modal
                    Flexible(
                      child: recs.isEmpty
                          ? Padding(
                              padding: EdgeInsets.all(40),
                              child: Text(
                                'No se encontraron recomendaciones',
                                style: TextStyle(fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              padding: EdgeInsets.all(20),
                              itemCount: grouped.length,
                              itemBuilder: (context, index) {
                                String titulo = grouped.keys.elementAt(index);
                                List<String> descripciones = grouped[titulo]!;
                                
                                return Card(
                                  margin: EdgeInsets.only(bottom: 15),
                                  elevation: 2,
                                  child: Padding(
                                    padding: EdgeInsets.all(15),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          titulo,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        ...descripciones.map((desc) => Padding(
                                          padding: EdgeInsets.only(bottom: 8),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('• ', style: TextStyle(fontSize: 16, color: Colors.blue)),
                                              Expanded(
                                                child: Text(
                                                  desc,
                                                  style: TextStyle(fontSize: 14, height: 1.4),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )).toList(),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      } else if (response.statusCode == 404) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Sin recomendaciones'),
              content: Text('No se encontraron recomendaciones para "$nombreInterpretador"'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error ${response.statusCode}'),
              content: Text('No se pudieron cargar las recomendaciones.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (error) {
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
      
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Error al realizar la solicitud: $error'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    if (cargando) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    if (mensajeError.isNotEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            mensajeError,
            style: TextStyle(color: Colors.red, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (interpretadores.isEmpty) {
      return Center(
        child: Text(
          'No hay interpretadores disponibles',
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.all(10),
      child: ListView.builder(
        itemCount: interpretadores.length,
        itemBuilder: (context, i) {
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              leading: CircleAvatar(
                backgroundColor: Colors.blue,
                child: Icon(Icons.lightbulb_outline, color: Colors.white),
              ),
              title: Text(
                interpretadores[i]['nombre_interpretador'],
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
              onTap: () {
                mostrarModalRecomendaciones(
                  interpretadores[i]['nombre_interpretador'],
                );
              },
            ),
          );
        },
      ),
    );
  }
}