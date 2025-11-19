import 'package:app/api/ApiConst.dart';
import 'package:app/editar_medicamentos.dart';
import 'package:app/function/function.dart';
import 'package:app/function/widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ListaMedicamentos extends StatefulWidget {
  int id_bebe;
  String nombre;
  ListaMedicamentos({super.key, required this.id_bebe, required this.nombre});

  @override
  State<ListaMedicamentos> createState() => _ListaMedicamentosState();
}

class _ListaMedicamentosState extends State<ListaMedicamentos> {
  Widget _tipo = CircularProgressIndicator();
  List<dynamic> medicamentos = [];
  Future<void> obtenerMedicamentos(int id_bebe) async {
    final url =
        '${Api.url}/api/v1/medicamento/obtener/$id_bebe'; // Cambia 'localhost' si es necesario

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        setState(() {
          medicamentos = data['msg'];

          // Si la lista de bebés está vacía, muestra el mensaje
          if (medicamentos.isEmpty) {
            // _tipo = Text("No registro ningun bebe.");
          }
        });
      } else if (response.statusCode == 404) {
        print('Datos no encontrados');
        setState(() {
          medicamentos = []; // Vacía la lista si no se encuentran datos
          //   _tipo = Text("No registro ningun bebe.");
          _tipo = Text(
            "No tiene medicamentos registrado.",
            textAlign: TextAlign.center,
            style: styleColorBlack,
          );
        });
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error al realizar la solicitud: $error');
    }
  }

  Future<void> eliminarMedicamento(int id_recordatorio, int id_bebe) async {
    final String apiUrl =
        '${Api.url}/api/v1/medicamento/eliminar'; // Cambia por la URL real de tu API

    try {
      // Crear el cuerpo de la solicitud
      final Map<String, dynamic> body = {
        'id_recordatorio': id_recordatorio,
        'id_bebe': id_bebe,
      };

      // Realizar la solicitud POST
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      // Comprobar si la respuesta es exitosa
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);

        if (responseBody['ok']) {
          await obtenerMedicamentos(widget.id_bebe);

          // Bebé eliminado correctamente
          print('Bebé eliminado correctamente');
        } else {
          // Mostrar el mensaje de error de la API
          print('Error de la API: ${responseBody['msg']}');
        }
      } else {
        // Mostrar mensaje de error en caso de fallo en la API
        print('Error al eliminar el bebé. Intente nuevamente.');
      }
    } catch (e) {
      // Manejar el error en caso de que falle la solicitud
      print('Error: $e');
      print('Hubo un problema con la solicitud.');
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      obtenerMedicamentos(widget.id_bebe);
    });

    // print("VERIFICANDO VG: " + Globals.ci);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
       // decoration: fondoApp,
        height: double.infinity,
        width: double.infinity,
        child: Column(
          children: [
            /*  Container(
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
                              "Lista de medicamentos",
                              style: styleColorPink,
                            ),
                            Text(
                              widget.nombre,
                              style: styleColorBlack,
                            ),
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
            medicamentos.isEmpty
                ? Center(
                    child: _tipo,
                  ) // Mientras carga, muestra un indicador
                : Expanded(
                    child: ListView.builder(
                      itemCount: medicamentos.length,
                      itemBuilder: (context, index) {
                        final medicamento = medicamentos[index];
                        // Convertir la fecha desde la cadena
                        DateTime fechaInicio =
                            DateTime.parse(medicamento['fecha_inicio']);

                        // Formatear la fecha en el formato deseado
                        String fechaInicioFormateada =
                            DateFormat('dd/MM/yyyy').format(fechaInicio);
                        // Convertir la fecha desde la cadena
                        DateTime fechaFin =
                            DateTime.parse(medicamento['fecha_inicio']);

                        // Formatear la fecha en el formato deseado
                        String fechaFinFormateada =
                            DateFormat('dd/MM/yyyy').format(fechaFin);
                        return InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () {
                            /*Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditarDatosBebe(
                                nombre: bebe['nombre'],
                                fecha_nacimiento: fechaFormateada,
                                genero: bebe['genero'],
                                id_bebe: bebe['id'],
                              ),
                            ),
                          ).then((result) {
                            if (result == true) {
                              // Recargar datos o ejecutar las funciones que necesitas
                              setState(() {
                                // Aquí puedes llamar las funciones o métodos que recargan la página
                                obtenerBebeUsuario(Globals.ci);
                              });
                            }
                          });*/
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [boxShadow],
                              ),
                              child: Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Sección Nombre del Medicamento
                                        Text(
                                          'Nombre medicamento:',
                                          style: styleColorPink,
                                        ),
                                        Text(
                                          '${medicamento['nombre_medicamento']}',
                                          style: styleColorBlack,
                                        ),
                                        SizedBox(height: 8),

                                        // Detalle del Medicamento
                                        Text(
                                          'Detalle del medicamento:',
                                          style: styleColorPink,
                                        ),
                                        Text(
                                          '${medicamento['descripcion_medicamento']}',
                                          style: styleColorBlack,
                                        ),
                                        Divider(), // Separador entre secciones

                                        // Hora de administración
                                        Text(
                                          'Hora de administración:',
                                          style: styleColorPink,
                                        ),
                                        Text(
                                          '${convertirHora(medicamento['hora'])}',
                                          style: styleColorBlack,
                                        ),
                                        SizedBox(height: 8),

                                        // Fechas
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Fecha inicio:',
                                                  style: styleColorPink,
                                                ),
                                                Text(
                                                  '$fechaInicioFormateada',
                                                  style: styleColorBlack,
                                                ),
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Fecha fin:',
                                                  style: styleColorPink,
                                                ),
                                                Text(
                                                  '$fechaFinFormateada',
                                                  style: styleColorBlack,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Divider(),

                                        // Tipo y Cantidad
                                        Text(
                                          'Tipo:',
                                          style: styleColorPink,
                                        ),
                                        Text(
                                          '${medicamento['tipo']}',
                                          style: styleColorBlack,
                                        ),
                                        SizedBox(height: 8),

                                        Text(
                                          'Cantidad:',
                                          style: styleColorPink,
                                        ),
                                        Text(
                                          '${quitarDecimales(medicamento['cantidad'])} ${medicamento['unidad']}',
                                          style: styleColorBlack,
                                        ),
                                        Divider(),

                                        // Frecuencia
                                        Text(
                                          'Frecuencia:',
                                          style: styleColorPink,
                                        ),
                                        Text(
                                          '${medicamento['frecuencia']}',
                                          style: styleColorBlack,
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Icono de eliminar
                                  Positioned(
                                    top: 325,
                                    right: 8,
                                    child: IconButton(
                                      onPressed: () async {
                                        bool? confirmDelete = await showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title:
                                                  Text('Confirmar eliminación'),
                                              content: Text(
                                                  '¿Estás seguro de que deseas eliminar ${medicamento['nombre_medicamento']}?'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop(
                                                        false); // No eliminar
                                                  },
                                                  child: Text('Cancelar'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop(
                                                        true); // Confirmar eliminación
                                                  },
                                                  child: Text('Eliminar'),
                                                ),
                                              ],
                                            );
                                          },
                                        );

                                        if (confirmDelete == true) {
                                          setState(() {
                                            eliminarMedicamento(
                                                medicamento['id_recordatorio'],
                                                widget.id_bebe);
                                          });
                                        }
                                      },
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: IconButton(
                                      onPressed: () async {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                EditarMedicamentos(
                                              nombre: medicamento[
                                                  'nombre_medicamento'],
                                              fecha_inicio:
                                                  fechaInicioFormateada,
                                              descripcion: medicamento[
                                                  'descripcion_medicamento'],
                                              cantidad: quitarDecimales(
                                                  medicamento['cantidad']),
                                              fecha_fin: fechaFinFormateada,
                                              frecuencia:
                                                  medicamento['frecuencia'],
                                              hora: convertirHora(
                                                  medicamento['hora']),
                                              tipo: medicamento['tipo'],
                                              unidad: medicamento['unidad'],
                                              id_bebe: widget.id_bebe,
                                              id_medicamento: medicamento[
                                                  'id_recordatorio'],
                                            ),
                                          ),
                                        ).then((result) {
                                          if (result == true) {
                                            // Recargar datos o ejecutar las funciones que necesitas
                                            setState(() {
                                              // Aquí puedes llamar las funciones o métodos que recargan la página
                                              obtenerMedicamentos(
                                                  widget.id_bebe);
                                            });
                                          }
                                        });
                                      },
                                      icon: Icon(
                                        Icons.edit,
                                        color: Colors.blue[900],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ));
  }
}
