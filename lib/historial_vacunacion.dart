import 'package:app/api/ApiConst.dart';
import 'package:app/function/widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';

class HistorialVacunacion extends StatefulWidget {
  int id_bebe;
  String nombre;
  HistorialVacunacion({super.key, required this.id_bebe, required this.nombre});

  @override
  State<HistorialVacunacion> createState() => _HistorialVacunacionState();
}

class _HistorialVacunacionState extends State<HistorialVacunacion> {
  

  Widget _tipo = CircularProgressIndicator();
  List<dynamic> vacunas = [];
  Future<void> obtenerEsquemasVacunasBebe(int id_bebe) async {
    final url =
        '${Api.url}/api/v1/bebe/obtenerEsquemaVacunacionAplicado/$id_bebe'; // Cambia 'localhost' si es necesario

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        setState(() {
          // print(_nombreUsuario);
          vacunas = data['msg']; // Actualiza el estado
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

    obtenerEsquemasVacunasBebe(widget.id_bebe);
    //print("VERIFICANDO FECHA-NACIMIENTO: " + widget.id_bebe.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //  decoration: fondoApp,
      // height: double.infinity,
      // width: double.infinity,
      child: Column(
        children: [
          /* Container(
              decoration: BoxDecoration(
                // border: Border.all(color: Colors.white),
                // borderRadius: BorderRadius.circular(20),
                boxShadow: [boxShadow],
                color: Colors.white,
              ),
              //height: 100,
              //color: Colors.white,
              child: SafeArea(
                child: Stack(
                  children: [
                    Positioned(
                        child: Container(
                      width: 400,
                      height: 60,
                      child: Column(
                        children: [
                          Text(
                            "Historial de vacunacion",
                            style: styleColorPink,
                          ),
                          Text("Bebe: ${widget.nombre}",
                              style: styleColorBlack),
                        ],
                      ),
                    ) /* ListTile(
                        title: Text(
                          "ESQUEMA DE VACUNACION",
                          style: styleColorPink,
                        ),
                        subtitle: Text("NOMBRE: ${widget.nombre_bebe}",
                            style: styleColorBlack),
                      ),*/
                        ),
                    Positioned(
                        left: 10,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              //  border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [boxShadow],
                              color: Colors.white,
                            ),
                            child: const Icon(
                              Icons.arrow_back,
                              size: 45,
                            ),
                          ),
                        ))
                  ],
                ),
              ),
            ),*/
          vacunas.isEmpty
              ? Center(
                  child: _tipo, // Widget que se muestra mientras carga
                )
              : Expanded(
                  // Envuelve el ListView en Expanded
                  child: Center(
                    child: ListView.builder(
                      itemCount: vacunas.length,
                      itemBuilder: (context, index) {
                        final vacuna = vacunas[index];
                        // Convertir la fecha desde la cadena
                        DateTime fechaNacimiento =
                            DateTime.parse(vacuna['fecha_programada']);

                        // Formatear la fecha en el formato deseado
                        String fechaFormateada =
                            DateFormat('dd/MM/yyyy').format(fechaNacimiento);

                        return InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () {
                            // Aquí puedes manejar el evento de tap
                          },
                          child: InkWell(
                            onTap: () {
                              /* Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RegistrarVacunasBebe(
                                      fecha_vacunacion: fechaFormateada,
                                      nombre: vacuna['nombre_vacuna'],
                                      estado: vacuna['aplicada'],
                                      id_bebe: widget.id_bebe,
                                      id_vacuna: vacuna['id_vacuna'],
                                    ),
                                  ),
                                ).then((result) {
                                  if (result == true) {
                                    // Recargar datos o ejecutar las funciones que necesitas
                                    setState(() {
                                      obtenerEsquemasVacunasBebe(
                                          widget.id_bebe);
                                      // Aquí puedes llamar las funciones o métodos que recargan la página
                                      //  obtenerNombreUsuario(Globals.emailAux);
                                    });
                                  }
                                });*/
                              /* Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RegistrarVacunasBebe(
                                      fecha_vacunacion: fechaFormateada,
                                      nombre: vacuna['nombre_vacuna'],
                                      estado: vacuna['aplicada'],
                                      id_bebe: widget.id_bebe,
                                      id_vacuna: vacuna['id_vacuna'],
                                    ),
                                  ),
                                );*/
                            },
                            child: Card(
                              elevation:
                                  4, // Agrega una sombra para el efecto visual
                              margin: EdgeInsets.symmetric(
                                  vertical: 5,
                                  horizontal: 10), // Márgenes para las tarjetas
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      15)), // Bordes redondeados
                              child: Padding(
                                padding: const EdgeInsets.all(
                                    16.0), // Espaciado interno de la tarjeta
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Nombre de la vacuna
                                    Row(
                                      children: [
                                        Image.asset(
                                          'images/vacunas.png',
                                          width: 25,
                                          height: 25,
                                        ), // Icono para la vacuna
                                        SizedBox(width: 10),
                                        Text(
                                          'Nombre: ',
                                          style: styleColorPink.copyWith(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                        Expanded(
                                          child: Text(
                                            vacuna['nombre_vacuna'],
                                            style: styleColorBlack.copyWith(
                                                fontSize: 16),
                                          ),
                                        ),
                                      ],
                                    ),
                                   /* SizedBox(height: 8),

                                    // Vacuna aplicada
                                    Row(
                                      children: [
                                        Icon(Icons.check_circle,
                                            color: Colors
                                                .green), // Icono de vacuna aplicada
                                        SizedBox(width: 10),
                                        Text(
                                          'Vacuna Aplicada: ',
                                          style: styleColorPink.copyWith(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                        Expanded(
                                          child: Text(
                                            vacuna['aplicada'],
                                            style: styleColorBlue.copyWith(
                                                fontSize: 16),
                                          ),
                                        ),
                                      ],
                                    ),*/
                                    SizedBox(height: 8),

                                    // Fecha de aplicación
                                    Row(
                                      children: [
                                        Icon(Icons.date_range,
                                            color:
                                                Colors.blue), // Icono de fecha
                                        SizedBox(width: 10),
                                        Text(
                                          'Fecha: ',
                                          style: styleColorPink.copyWith(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                        Expanded(
                                          child: Text(
                                            fechaFormateada,
                                            style: styleColorBlack.copyWith(
                                                fontSize: 16),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Divider(), // Divider para separar cada vacuna visualmente
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
