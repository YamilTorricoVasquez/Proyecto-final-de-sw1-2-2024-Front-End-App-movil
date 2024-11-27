import 'package:app/GraficaBarras.dart';
import 'package:app/GraficaTorta.dart';
import 'package:app/SharedPreferences.dart';
import 'package:app/api/ApiConst.dart';
import 'package:app/callbackDispatcher.dart';
import 'package:app/editar_datos_bebe.dart';
import 'package:app/esquemaVacunasBebe.dart';
import 'package:app/function/varGlobales.dart';

import 'package:app/function/widget.dart';
import 'package:app/historial_vacunacion.dart';
import 'package:app/interpretador.dart';

import 'package:app/lista_medicamentos.dart';
import 'package:app/recomendaciones.dart';
import 'package:app/registro_medicamentos.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:workmanager/workmanager.dart';

class PerfilBebe extends StatefulWidget {
  String nombre;
  String fecha;
  String genero;
  int id_bebe;
  PerfilBebe(
      {super.key,
      required this.nombre,
      required this.fecha,
      required this.genero,
      required this.id_bebe});

  @override
  State<PerfilBebe> createState() => _PerfilBebeState();
}

class _PerfilBebeState extends State<PerfilBebe> {
  String _nombreBebe = '';
  String _fechaBebe = '';
  String _generoBebe = '';
  String _fechaFormateada = '';

  Future<void> obtenerDatoBebe(int id_bebe) async {
    final url =
        '${Api.url}/api/v1/bebe/obtenerBebe/$id_bebe'; // Cambia 'localhost' si es necesario

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          // print(_nombreUsuario);
          _nombreBebe = data['msg']['nombre']; // Actualiza el estado
          _fechaBebe = data['msg']['fecha_nacimiento'];
          _fechaBebe = _fechaBebe.replaceAll('T', ' ').replaceAll('Z', '');
          // Convertir la fecha desde la cadena
          DateTime fechaNacimiento = DateTime.parse(_fechaBebe);

          // Formatear la fecha en el formato deseado
          _fechaFormateada = DateFormat('dd/MM/yyyy').format(fechaNacimiento);
          _generoBebe = data['msg']['genero'];
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

Future<void> solicitarPermisos() async {
  if (await Permission.microphone.request().isGranted) {
    print("Permiso de micrófono concedido.");
  } else {
    print("Permiso de micrófono denegado.");
  }
}
  Future<void> asignarEsquemaDeVacunacion(int id_bebe) async {
    final url = Uri.parse(
        '${Api.url}/api/v1/bebe/asignarVacuna'); // Cambia la URL a la de tu API
    final headers = {'Content-Type': 'application/json'};

    final body = json.encode({'id_bebe': id_bebe});

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['ok']) {
          // Manejar respuesta exitosa
          print('Asignacion exitosa');
          // print('Token: ${data['msg']['token']}');

          // Navegar a la siguiente pantalla o realizar acciones necesarias
        } else {
          // Manejar error en el registro
          print('Error en el registro: ${data['msg']}');
        }
      } else {
        print('Error en la solicitud: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void initState() {
    super.initState();
     solicitarPermisos();
    setState(() {
      obtenerDatoBebe(widget.id_bebe);
      // Programa la tarea diaria
      /* Workmanager().registerPeriodicTask(
        "1", // ID único
        "mostrar_notificacion_desde_api", // Nombre de la tarea
        frequency: const Duration(
            minutes: 15), // Intervalo mínimo permitido por WorkManager
      );*/
    });
    // Vincula el método setState con Globals.actualizarPantalla
    Globals.actualizarPantalla = () {
      setState(() {
        Globals.pantallaActual =
            Recomendaciones(nombre: Globals.nombre_interpretador);
      }); // Redibuja el widget principal
    };

    print("VERIFICANDO VG: " + widget.id_bebe.toString());
  }

  /*void printSavedBabyIds() async {
    final babyIds = await BabyIdsStorage.getBabyIds();
    print("IDs guardados: $babyIds");
  }*/

  Color _colorBEdit = Colors.black;
  Color _colorBEgraf = Colors.white;
  Color _colorB1 = Colors.white;
  Color _colorB2 = Colors.white;
  Color _colorB3 = Colors.white;
  Color _colorB4 = Colors.white;
  Color _colorB5 = Colors.grey;
  Color _colorB6 = Colors.white;
  Color _colorT1 = Colors.black;
  Color _colorT2 = Colors.black;
  Color _colorT3 = Colors.black;
  Color _colorT4 = Colors.black;
  Color _colorT5 = Colors.grey;
  Color _colorT6 = Colors.black;
  Widget _pantalla = Interpretador();
// Navigator.pop(context, true);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.amber,
      body: Container(
        clipBehavior: Clip.none,
        decoration: BoxDecoration(
          //color: Colors.white,
          /* image: DecorationImage(
            // image: AssetImage("assets/background.jpg"), fit: BoxFit.fill),
            image: AssetImage("images/image.png"),
            fit: BoxFit.cover,
          ),*/
          gradient: LinearGradient(
            colors: [Colors.pinkAccent, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Container(
              height: 160,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [boxShadow],
              ),
              child: Stack(
                children: [
                  Positioned(
                    left: 10,
                    top: 70,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context, true);
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
                    ),
                  ),
                  Positioned(
                    top: 50,
                    left: 120,
                    child: Column(
                      children: [
                        Text(
                          "Perfil del Bebe",
                          style: styleColorPink.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 70,
                    left: 70,
                    child: Row(
                      children: [
                        Text(
                          "Nombre: ",
                          style: styleColorRed,
                        ),
                        Text(
                          "$_nombreBebe",
                          style: styleColorBlack,
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 90,
                    left: 70,
                    child: Row(
                      children: [
                        Text(
                          "Fecha: ",
                          style: styleColorRed,
                        ),
                        Text(
                          "$_fechaFormateada",
                          style: styleColorBlack,
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 110,
                    left: 70,
                    child: Row(
                      children: [
                        Text(
                          "Género: ",
                          style: styleColorRed,
                        ),
                        Text(
                          "$_generoBebe",
                          style: styleColorBlack,
                        ),
                      ],
                    ),
                  ),

                  // Icono de edición
                  Positioned(
                    top: 110,
                    left: 180,
                    child: IconButton(
                      onPressed: () {
                        _colorT1 = Colors.black;
                        _colorT2 = Colors.black;
                        _colorT3 = Colors.black;
                        _colorT4 = Colors.black;
                        _colorT5 = Colors.black;
                        _colorT6 = Colors.black;
                        _colorB1 = Colors.white;
                        _colorB2 = Colors.white;
                        _colorB3 = Colors.white;
                        _colorB4 = Colors.white;
                        _colorB5 = Colors.white;
                        _colorB6 = Colors.white;
                        _colorBEdit = Colors.blue;
                        _colorBEgraf = Colors.white;
                        setState(() {
                          Globals.idBebe = widget.id_bebe;
                          _pantalla = EditarDatosBebe(
                            id_bebe: Globals.idBebe,
                            nombre: _nombreBebe,
                            fecha_nacimiento: _fechaFormateada,
                            genero: _generoBebe,
                            onUpdate: () {
                              obtenerDatoBebe(widget
                                  .id_bebe); // Actualizar los datos en la pantalla principal
                            },
                          );
                        });
                      },
                      icon: Icon(
                        Icons.edit,
                        size: 25,
                        color: _colorBEdit, // Cambia el color
                      ),
                    ),
                  ),
                  Positioned(
                      top: 90,
                      right: 20,
                      child: InkWell(
                        onTap: () {
                          //print("Tarea programada");
                          _colorT1 = Colors.black;
                          _colorT2 = Colors.black;
                          _colorT3 = Colors.black;
                          _colorT4 = Colors.black;
                          _colorT5 = Colors.black;
                          _colorT6 = Colors.black;
                          _colorB1 = Colors.white;
                          _colorB2 = Colors.white;
                          _colorB3 = Colors.white;
                          _colorB4 = Colors.white;
                          _colorB5 = Colors.white;
                          _colorB6 = Colors.white;
                          _colorBEdit = Colors.black;
                          _colorBEgraf = Colors.grey;
                          setState(() {
                            _pantalla = GraficaTorta();
                          });
                        },
                        child: Column(
                          children: [
                            Container(
                              height: 45,
                              width: 45,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: _colorBEgraf,
                                  boxShadow: [boxShadow]),
                              child: ImagenIcon(url: 'images/grafico.png'),
                            ),
                            TituloBotones(
                                nombre: 'Estadiscas', colors: Colors.black)
                          ],
                        ),
                      )),
                ],
              ),
            ),
            SizedBox(height: 10),
            //Cuerpo
            Expanded(flex: 5, child: _pantalla),
            //Botones
            BotonesInferiores()
          ],
        ),
      ),
    );
  }

  Container BotonesInferiores() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [boxShadow]
      ),
      height: 90,
      // flex: 2,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  left: 1,
                  top: 55,
                  child: Column(
                    children: [
                      TituloBotones(
                        nombre: "Esquema",
                        colors: _colorT1,
                      ),
                      TituloBotones(
                        nombre: "Vacunacion",
                        colors: _colorT1,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () async {
                      // Registra una tarea única (One-Off Task)
                      /* Workmanager().registerOneOffTask(
                        "2", // ID único
                        "mostrar_notificacion_desde_api", // Nombre de la tarea
                      );*/

                      //   printSavedBabyIds();
                      await asignarEsquemaDeVacunacion(widget.id_bebe);
                      setState(() {
                        _colorT1 = Colors.grey;
                        _colorT2 = Colors.black;
                        _colorT3 = Colors.black;
                        _colorT4 = Colors.black;
                        _colorT5 = Colors.black;
                        _colorT6 = Colors.black;
                        _colorB1 = Colors.grey;
                        _colorB2 = Colors.white;
                        _colorB3 = Colors.white;
                        _colorB4 = Colors.white;
                        _colorB5 = Colors.white;
                        _colorB6 = Colors.white;
                        _colorBEdit = Colors.black;
                        _colorBEgraf = Colors.white;
                        _pantalla = Esquemavacunasbebe(
                          id_bebe: widget.id_bebe,
                          nombre_bebe:
                              _nombreBebe, //Aqui hay que acomodar para asignar el esquema de vacunacion
                        );
                      });
                    },
                    child: Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                        color: _colorB1,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [boxShadow],
                      ),
                      child: ImagenIcon(url: 'images/calendarioVacuna.png'),
                    ),
                  ),
                )
              ],
            ),
            Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  left: 10,
                  top: 55,
                  child: Column(
                    children: [
                      TituloBotones(
                        nombre: "Historial",
                        colors: _colorT2,
                      ),
                      TituloBotones(
                        nombre: "Vacunas",
                        colors: _colorT2,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      setState(() {
                        _colorT1 = Colors.black;
                        _colorT2 = Colors.grey;
                        _colorT3 = Colors.black;
                        _colorT4 = Colors.black;
                        _colorT5 = Colors.black;
                        _colorT6 = Colors.black;
                        _colorB1 = Colors.white;
                        _colorB2 = Colors.grey;
                        _colorB3 = Colors.white;
                        _colorB4 = Colors.white;
                        _colorB5 = Colors.white;
                        _colorB6 = Colors.white;
                        _colorBEdit = Colors.black;
                        _colorBEgraf = Colors.white;
                        _pantalla = HistorialVacunacion(
                          id_bebe: widget.id_bebe,
                          nombre:
                              _nombreBebe, //Aqui hay que acomodar para asignar el esquema de vacunacion
                        );
                      });
                    },
                    child: Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                        color: _colorB2,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [boxShadow],
                      ),
                      child: ImagenIcon(url: 'images/historialVacuna.png'),
                    ),
                  ),
                )
              ],
            ),
            //SizedBox(width: 100),
            Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  left: -1.2,
                  top: 55,
                  child: Column(
                    children: [
                      TituloBotones(
                        nombre: "Interpretador",
                        colors: _colorT5,
                      ),
                      TituloBotones(
                        nombre: "Llanto",
                        colors: _colorT5,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      setState(() {
                        _colorT1 = Colors.black;
                        _colorT2 = Colors.black;
                        _colorT3 = Colors.black;
                        _colorT4 = Colors.black;
                        _colorT5 = Colors.grey;
                        _colorT6 = Colors.black;
                        _colorB1 = Colors.white;
                        _colorB2 = Colors.white;
                        _colorB3 = Colors.white;
                        _colorB4 = Colors.white;
                        _colorB5 = Colors.grey;
                        _colorB6 = Colors.white;
                        _colorBEdit = Colors.black;
                        _colorBEgraf = Colors.white;
                        _pantalla = Interpretador();
                      });
                    },
                    child: Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                        color: _colorB5,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [boxShadow],
                      ),
                      child: ImagenIcon(url: 'images/audio.png'),
                    ),
                  ),
                )
              ],
            ),

            Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  left: -5,
                  top: 55,
                  child: Column(
                    children: [
                      TituloBotones(
                        nombre: "Registro",
                        colors: _colorT3,
                      ),
                      TituloBotones(
                        nombre: "Medicamentos",
                        colors: _colorT3,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      setState(() {
                        _colorT1 = Colors.black;
                        _colorT2 = Colors.black;
                        _colorT3 = Colors.grey;
                        _colorT4 = Colors.black;
                        _colorT5 = Colors.black;
                        _colorT6 = Colors.black;
                        _colorB1 = Colors.white;
                        _colorB2 = Colors.white;
                        _colorB3 = Colors.grey;
                        _colorB4 = Colors.white;
                        _colorB5 = Colors.white;
                        _colorB6 = Colors.white;
                        _colorBEdit = Colors.black;
                        _colorBEgraf = Colors.white;
                        _pantalla = RegistroMedicamentos(
                          id_bebe: widget.id_bebe,
                        );
                      });
                    },
                    child: Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                        color: _colorB3,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [boxShadow],
                      ),
                      child: ImagenIcon(url: 'images/listaMedicamentos.png'),
                    ),
                  ),
                )
              ],
            ),
            Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  left: 10,
                  top: 55,
                  child: Column(
                    children: [
                      TituloBotones(
                        nombre: "Lista",
                        colors: _colorT4,
                      ),
                      TituloBotones(
                        nombre: "Vacunas",
                        colors: _colorT4,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      _colorT1 = Colors.black;
                      _colorT2 = Colors.black;
                      _colorT3 = Colors.black;
                      _colorT4 = Colors.grey;
                      _colorT5 = Colors.black;
                      _colorT6 = Colors.black;
                      _colorB1 = Colors.white;
                      _colorB2 = Colors.white;
                      _colorB3 = Colors.white;
                      _colorB4 = Colors.grey;
                      _colorB5 = Colors.white;
                      _colorB6 = Colors.white;
                      _colorBEdit = Colors.black;
                      _colorBEgraf = Colors.white;
                      setState(() {
                        _pantalla = ListaMedicamentos(
                          id_bebe: widget.id_bebe,
                          nombre: widget.nombre,
                        );
                      });
                    },
                    child: Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                        color: _colorB4,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [boxShadow],
                      ),
                      child:
                          ImagenIcon(url: 'images/recordatorioMedicamento.png'),
                    ),
                  ),
                )
              ],
            ),

            Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  left: 1,
                  top: 55,
                  child: Column(
                    children: [
                      TituloBotones(
                        nombre: "Recomenda",
                        colors: _colorT6,
                      ),
                      TituloBotones(
                        nombre: "ciones",
                        colors: _colorT6,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      _colorT1 = Colors.black;
                      _colorT2 = Colors.black;
                      _colorT3 = Colors.black;
                      _colorT4 = Colors.black;
                      _colorT5 = Colors.black;
                      _colorT6 = Colors.grey;
                      _colorB1 = Colors.white;
                      _colorB2 = Colors.white;
                      _colorB3 = Colors.white;
                      _colorB4 = Colors.white;
                      _colorB5 = Colors.white;
                      _colorB6 = Colors.grey;
                      _colorBEdit = Colors.black;
                      _colorBEgraf = Colors.white;
                      setState(() {
                        _pantalla = Recomendaciones(
                            nombre: Globals.nombre_interpretador);
                      });
                    },
                    child: Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                        color: _colorB6,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [boxShadow],
                      ),
                      child: ImagenIcon(url: 'images/consejomedico.png'),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ImagenIcon extends StatelessWidget {
  final String url;

  ImagenIcon({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      url,
      width: 50,
      height: 50,
    );
  }
}

class TituloBotones extends StatelessWidget {
  String nombre;
  Color colors;
  TituloBotones({super.key, required this.nombre, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Text(
      nombre,
      style:
          TextStyle(fontSize: 11, color: colors, fontWeight: FontWeight.bold),
      maxLines: 1, // Limitar a una línea
      overflow: TextOverflow.ellipsis, // Mostrar "..." si el texto es muy largo
      softWrap: false,
    );
  }
}
