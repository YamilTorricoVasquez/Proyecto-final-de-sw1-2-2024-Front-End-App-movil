import 'dart:convert';

import 'package:app/api/ApiConst.dart';

import 'package:app/function/function.dart';
import 'package:app/function/widget.dart';
import 'package:app/lista_bebe.dart';
import 'package:app/notifications_service.dart';
import 'package:app/perfil_bebe.dart';
import 'package:app/registrar_vacunas_bebe.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
//import 'package:workmanager/workmanager.dart';

class Esquemavacunasbebe extends StatefulWidget {
  int id_bebe;
  String nombre_bebe;
  Esquemavacunasbebe(
      {super.key, required this.id_bebe, required this.nombre_bebe});

  @override
  State<Esquemavacunasbebe> createState() => _EsquemavacunasbebeState();
}

class _EsquemavacunasbebeState extends State<Esquemavacunasbebe> {
  Widget _tipo = CircularProgressIndicator();
  List<dynamic> vacunas = [];

  Future<void> obtenerEsquemasVacunasBebe(int id_bebe) async {
    final url =
        '${Api.url}/api/v1/bebe/obtenerEsquemaVacunacion/$id_bebe'; // Cambia 'localhost' si es necesario

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        setState(() {
          vacunas = data['msg']; // Actualiza el estado con las vacunas
        });

        if (vacunas.isEmpty) {
          // Si no hay vacunas, muestra un mensaje apropiado
          _tipo = MostrarTextoFelicidades(widget: widget);
        } else {
          // Llama a programar las notificaciones solo si hay vacunas
          try {
            // await programarNotificacionesVacunas(id_bebe);
          } catch (error) {
            print('Error al programar notificaciones: $error');
          }
        }
      } else if (response.statusCode == 404) {
        setState(() {
          _tipo = Text("No se encontraron datos de vacunación.");
        });
        print('Datos no encontrados');
      } else {
        print('Error en la solicitud: ${response.statusCode}');
      }
    } catch (error) {
      print('Error al realizar la solicitud: $error');
    }
  }

  DateTime fechaActual = DateTime.now();
  late DateTime fechaVacunacion;
  String _texto = '';
  int _id_vacuna = -1;
  Future<void> actualizarVacuna(
      int id_bebe, int id_vacuna, String fecha, String nombreVacuna) async {
    // URL de tu API
    String url = '${Api.url}/api/v1/bebe/actualizarEstadoVacuna';
    setState(() {
      isLoading = true; // Activar el indicador de carga
    });
    // Construir el cuerpo de la solicitud
    final Map<String, dynamic> requestBody = {
      'id_bebe': id_bebe,
      'id_vacuna': id_vacuna,
    };

    try {
      // Convertir fechas para comparación
      DateTime fechaVacunacion =
          DateTime.parse(invertirFecha2(fecha)).toLocal();
      DateTime fechaActual = DateTime.now();

// Formatear la fecha actual al formato deseado
      String fechaFormateada = DateFormat('dd/MM/yyyy').format(fechaActual);

      print(
          "Fecha vacunación: ${DateFormat('dd/MM/yyyy').format(fechaVacunacion)}");
      print("Fecha actual formateada: $fechaFormateada");

      // Comparar fechas
      if (fechaActual.isAtSameMomentAs(fechaVacunacion) ||
          fechaActual.isAfter(fechaVacunacion)) {
        // Realizar la solicitud PUT
        final response = await http.post(
          Uri.parse(url),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(requestBody),
        );
        await Future.delayed(
            Duration(seconds: 2)); // Simulación de un retraso de 2 segundos
        // Comprobar la respuesta
        if (response.statusCode == 200) {
          final jsonResponse = jsonDecode(response.body);
          obtenerEsquemasVacunasBebe(id_bebe);
          // mostrarNotificacion(
          //     '${nombreVacuna}',
          //     'Acaba registrar que su bebe tiene ya aplicada la vacuna ${nombreVacuna}',
          //     generateRandom4DigitNumber());
          print('Datos actualizados correctamente: ${jsonResponse['msg']}');
          setState(() {
            isLoading = false; // Desactivar el indicador de carga
            _id_vacuna = id_vacuna;
          });
        } else {
          print('Error en la actualización: ${response.body}');
        }
      } else {
        print(fechaFormateada);
        print(fecha);
        // Si la fecha actual es anterior a la fecha de vacunación
        print("No es posible registrar la vacuna aún.");
        setState(() {
          _id_vacuna = id_vacuna;
          _texto = "Aún no es la fecha para registrar la vacuna.";
          isLoading = false;
        });
      }
    } catch (error) {
      print('Error al conectar con el servidor: $error');
    }
  }

  bool isLoading = false; // Estado que controla si se está cargando
  @override
  void initState() {
    super.initState();

    obtenerEsquemasVacunasBebe(widget.id_bebe);
    print("VERIFICANDO FECHA-NACIMIENTO: " + widget.id_bebe.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
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

                        return Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 10), // Márgenes para el contenedor
                          decoration: BoxDecoration(
                            color: Colors.white, // Fondo blanco
                            borderRadius:
                                BorderRadius.circular(15), // Bordes redondeados
                            boxShadow: [
                              boxShadow
                            ], // Sombra similar al efecto de Card
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(
                                16.0), // Espaciado interno del contenedor
                            child: Stack(
                              children: [
                                Positioned(
                                  left: 260,
                               //   top: 1,
                                  child: GestureDetector(
                                    onTap: () {
                                      actualizarVacuna(
                                        widget.id_bebe,
                                        vacuna['id_vacuna'],
                                        fechaFormateada,
                                        vacuna['nombre_vacuna'],
                                      );
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white,
                                        boxShadow: [boxShadow],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(2),
                                        child: isLoading
                                            ? Center(
                                                child:
                                                    CircularProgressIndicator(), // Mostrar el indicador de carga
                                              )
                                            : Image.asset(
                                                'images/registrovacunas.png',
                                                scale: 14,
                                              ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 264,
                                  top: 40,
                                  child: TituloBotones(
                                    nombre: 'Aplicar',
                                    colors: Colors.black,
                                  ),
                                ),
                                Column(
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
                                    /*  SizedBox(height: 8),

                                    // Vacuna aplicada
                                    Row(
                                      children: [
                                        Icon(Icons.cancel,
                                            color: Colors
                                                .red), // Icono de vacuna aplicada
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
                                            style: styleColorRed.copyWith(
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
                                    Divider(),
                                    // Divider para separar cada vacuna visualmente
                                    if (_id_vacuna == vacuna['id_vacuna'])
                                      Text(
                                        _texto,
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold),
                                      )
                                  ],
                                ),
                              ],
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

class MostrarTextoFelicidades extends StatelessWidget {
  const MostrarTextoFelicidades({
    super.key,
    required this.widget,
  });

  final Esquemavacunasbebe widget;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 40),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [boxShadow]),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                "Felicidades usted completo el esquema de vacunacion de su hijo ${widget.nombre_bebe}",
                style: styleColorBlack,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
/*void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task == "programar_notificaciones") {
      // Asegúrate de inicializar las notificaciones
      await NotificationsService.initialize();

      final int idBebe = inputData?['id_bebe'] ?? 0;
      if (idBebe > 0) {
        // Llama a la API directamente
        final url = '${Api.url}/api/v1/bebe/obtenerEsquemaVacunacion/$idBebe';
        try {
          final response = await http.get(Uri.parse(url));
          if (response.statusCode == 200) {
            final data = json.decode(response.body);
            final List<dynamic> vacunas = data['msg'] ?? [];

            if (vacunas.isNotEmpty) {
              await programarNotificacionesVacunas(vacunas);
            } else {
              print("No se encontraron vacunas para el bebé con ID: $idBebe");
            }
          } else {
            print("Error al llamar la API: ${response.statusCode}");
          }
        } catch (error) {
          print("Error al obtener las vacunas: $error");
        }
      }
    }
    return Future.value(true); // Indica que la tarea terminó correctamente
  });
}
 Future<void> programarNotificacionesVacunas(List<dynamic> vacunas) async {
    for (var vacuna in vacunas) {
      final int idVacuna = vacuna['id_vacuna'] ?? 0;
      if (idVacuna == 0) {
        print("Vacuna con ID inválido, omitiendo...");
        continue;
      }

      final fechaVacuna =
          DateTime.tryParse(vacuna['fecha_programada']) ?? DateTime.now();
      final String nombreVacuna =
          vacuna['nombre_vacuna'] ?? 'Vacuna desconocida';
      final String estadoAplicada = vacuna['aplicada'] ?? 'pendiente';
      final ahora = DateTime.now();

      try {
        if (fechaVacuna.isAfter(ahora)) {
          final unaSemanaAntes = fechaVacuna.subtract(Duration(days: 7));
          if (unaSemanaAntes.isAfter(ahora)) {
            await NotificationsService.scheduleNotification(
              id: idVacuna * 10 + 1,
              title: "Vacuna próxima",
              body:
                  "Recuerda que $nombreVacuna está programada para ${DateFormat('dd/MM/yyyy').format(fechaVacuna)}.",
              scheduledDate: unaSemanaAntes,
            );
          }

          await NotificationsService.scheduleNotification(
            id: idVacuna * 10 + 2,
            title: "Vacuna hoy",
            body:
                "Hoy es el día de la vacuna $nombreVacuna. No olvides aplicarla.",
            scheduledDate: fechaVacuna,
          );
        } else if (estadoAplicada.toLowerCase() == 'pendiente') {
          await NotificationsService.scheduleNotification(
            id: idVacuna * 10 + 3,
            title: "Vacuna pendiente",
            body:
                "La vacuna $nombreVacuna está pendiente desde ${DateFormat('dd/MM/yyyy').format(fechaVacuna)}.",
            scheduledDate: ahora.add(Duration(seconds: 10)),
          );
        }
      } catch (e) {
        print("Error al programar notificaciones: $e");
      }
    }
  }*/