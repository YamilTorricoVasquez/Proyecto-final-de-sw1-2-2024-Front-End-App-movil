import 'package:app/api/ApiConst.dart';
import 'package:app/function/function.dart';
import 'package:app/function/widget.dart';
import 'package:flutter/material.dart';
import 'dart:convert'; // Para usar jsonEncode
import 'package:http/http.dart' as http;

class RegistrarVacunasBebe extends StatefulWidget {
  String nombre;
  String fecha_vacunacion;
  String estado;
  int id_bebe;
  int id_vacuna;
  RegistrarVacunasBebe(
      {super.key,
      required this.nombre,
      required this.fecha_vacunacion,
      required this.estado,
      required this.id_bebe,
      required this.id_vacuna});

  @override
  State<RegistrarVacunasBebe> createState() => _RegistrarVacunasBebeState();
}

class _RegistrarVacunasBebeState extends State<RegistrarVacunasBebe> {
  Widget _icono = Text(
    "Registrar vacuna",
    style: styleColorBlackBotones,
  );

  DateTime fechaActual = DateTime.now();
  late DateTime fechaVacunacion;
  Future<void> actualizarDatosUsuario(int id_bebe, int id_vacuna) async {
    // URL de tu API
    String url =
        '${Api.url}/api/v1/bebe/actualizarEstadoVacuna'; // Reemplaza con la URL correcta si es necesario

    // Construir el cuerpo de la solicitud
    final Map<String, dynamic> requestBody = {
      'id_bebe': id_bebe,
      'id_vacuna': id_vacuna
    };

    try {
      fechaVacunacion = DateTime.parse(invertirFecha2(widget.fecha_vacunacion));
      // Realizar la solicitud PUT
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody), // Convertir el cuerpo a JSON
      );
      if (fechaActual.isAtSameMomentAs(fechaVacunacion) ||
          fechaActual.isAfter(fechaVacunacion)) {
// Comprobar la respuesta
        if (response.statusCode == 200) {
          final jsonResponse = jsonDecode(response.body);

          print('Datos actualizados correctamente: ${jsonResponse['msg']}');
          setState(() {
            _icono = Text(
              "Registrar vacuna",
              style: styleColorBlackBotones,
            );
          });
          Navigator.pop(context, true);
        } else {
          print('Error en la actualización: ${response.body}');
        }
      } else {
        setState(() {
          _icono = Text(
            "Registrar vacuna",
            style: styleColorBlackBotones,
          );
        });
        print("No es posible registrar la vacuna aún.");
      }
    } catch (error) {
      print('Error al conectar con el servidor: $error');
      setState(() {
        _icono = Text(
          "Registrar vacuna",
          style: styleColorBlackBotones,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: fondoApp,
        height: double.infinity,
        width: double.infinity,
        child: Column(
          children: [
            Text("Registre la vucna de su bebe"),
            //  SizedBox(height: 15), // Separación entre el título y la información
            Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [boxShadow]),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          "Informacion de la vacuna",
                          style: styleColorPink,
                        ),
                      ),
                      SizedBox(
                          height:
                              15), // Separación entre el título y la información
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          children: [
                            Text(
                              "Nombre: ",
                              style: styleColorPink.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 16, // Definir un tamaño estándar
                              ),
                            ),
                            Expanded(
                              child: Text(
                                widget.nombre,
                                style: styleColorBlack,
                                overflow: TextOverflow
                                    .ellipsis, // Manejar textos largos
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          children: [
                            Text(
                              "Fecha de Vacunación: ",
                              style: styleColorPink.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                widget.fecha_vacunacion,
                                style: styleColorBlack,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          children: [
                            Text(
                              "Estado: ",
                              style: styleColorPink.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                widget.estado,
                                style: styleColorRed,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            InkWell(
              child: Container(
                width: 318,
                height: 50,
                decoration: BoxDecoration(
                  //   border: Border.all(color: Colors.pink.shade200),
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.pink[200],
                  boxShadow: [boxShadow],
                ),
                child: Center(
                  child: _icono,
                ),
              ),
              onTap: () async {
                bool? confirmDelete = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Confirmar vacunacion'),
                      content: Text(
                          '¿Estás seguro que tu hijo ya fue vacunado con: ${widget.nombre}?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(false); // No eliminar
                          },
                          child: Text('Cancelar'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pop(true); // Confirmar eliminación
                          },
                          child: Text('confirmar'),
                        ),
                      ],
                    );
                  },
                );

                // Si el usuario confirma la eliminación, procede
                if (confirmDelete == true) {
                  setState(() {
                    _icono = CircularProgressIndicator();
                  });
                  await actualizarDatosUsuario(
                      widget.id_bebe, widget.id_vacuna);
                  // await eliminarBebe(bebe['nombre'], Globals.ci);
                  setState(() {});
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
/*InkWell(
            child: Container(
              width: 318,
              height: 50,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.pink.shade200),
                borderRadius: BorderRadius.circular(20),
                color: Colors.pink[200],
                boxShadow: [boxShadow],
              ),
              child: Center(
                child: Text(
                  "Registrar vacuna",
                  style: styleColorBlackBotones,
                ),
              ),
            ),
            onTap: () async {},
          ),*/