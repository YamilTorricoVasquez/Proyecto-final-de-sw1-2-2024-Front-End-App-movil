/*import 'package:app/api/ApiConst.dart';

import 'package:app/function/varGlobales.dart';
import 'package:app/function/widget.dart';


import 'package:app/perfil_bebe.dart';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ListaBebe extends StatefulWidget {
  String ci;
  ListaBebe({super.key, required this.ci});

  @override
  State<ListaBebe> createState() => _ListaBebeState();
}

class _ListaBebeState extends State<ListaBebe> {
  @override
  void initState() {
    super.initState();
    setState(() {
      obtenerBebeUsuario(widget.ci);
    });

    print("VERIFICANDO VG: " + Globals.ci);
  }

  Widget _tipo = CircularProgressIndicator();
  List<dynamic> bebes = [];
  Future<void> obtenerBebeUsuario(String ci) async {
    final url =
        '${Api.url}/api/v1/bebe/obtener/$ci'; // Cambia 'localhost' si es necesario

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        setState(() {
          bebes = data['msg'];

          // Si la lista de bebés está vacía, muestra el mensaje
          if (bebes.isEmpty) {
            _tipo = Text("No registro ningun bebe.");
          }
        });
      } else if (response.statusCode == 404) {
        print('Datos no encontrados');
        setState(() {
          bebes = []; // Vacía la lista si no se encuentran datos
          _tipo = Text("No registro ningun bebe.");
        });
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error al realizar la solicitud: $error');
    }
  }

  Future<void> eliminarBebe(String nombre, String ciUsuario) async {
    final String apiUrl =
        '${Api.url}/api/v1/bebe/eliminar'; // Cambia por la URL real de tu API

    try {
      // Crear el cuerpo de la solicitud
      final Map<String, dynamic> body = {
        'nombre': nombre,
        'ci_usuario': ciUsuario,
      };

      // Realizar la solicitud POST
      final response = await http.put(
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
          await obtenerBebeUsuario(Globals.ci);

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

  List<dynamic> vacunas = [];
  Future<void> obtenerEsquemaVacunacionAplicado(int id_bebe) async {
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: fondoApp,
        height: double.infinity,
        width: double.infinity,
        child: bebes.isEmpty
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
                      /* Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>/* */
                        ),
                      );*/
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PerfilBebe(
                            nombre: bebe['nombre'],
                            fecha: fechaFormateada,
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
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 180,
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            // Datos del bebé
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Nombre:',
                                  style: styleColorPink.copyWith(
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  '${bebe['nombre']}',
                                  style: styleColorBlack,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Fecha de Nacimiento:',
                                  style: styleColorPink.copyWith(
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  '$fechaFormateada',
                                  style: styleColorBlack,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Género:',
                                  style: styleColorPink.copyWith(
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  '${bebe['genero']}',
                                  style: styleColorBlack,
                                ),
                              ],
                            ),

                            // Botón de eliminación en la esquina superior derecha
                            Positioned(
                              right: 0,
                              top: 0,
                              child: IconButton(
                                onPressed: () async {
                                  bool? confirmDelete = await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Confirmar eliminación'),
                                        content: Text(
                                          '¿Estás seguro de que deseas eliminar a ${bebe['nombre']}?',
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pop(false); // No eliminar
                                            },
                                            child: Text('Cancelar'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop(
                                                  true); // Confirmar eliminación
                                            },
                                            child: Text(
                                              'Eliminar',
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );

                                  // Si el usuario confirma la eliminación, procede
                                  if (confirmDelete == true) {
                                    await obtenerEsquemaVacunacionAplicado(
                                        bebe['id']);
                                    if (vacunas.isEmpty) {
                                      await eliminarBebe(
                                          bebe['nombre'], Globals.ci);
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Center(
                                            child: Text(
                                              'Ya no es posible eliminar al bebe',
                                              style: styleColorWhite,
                                            ),
                                          ),
                                        ),
                                      );
                                      print(
                                          "Ya no es posible eliminar al bebe");
                                    }

                                    setState(
                                        () {}); // Actualizar vista después de eliminar
                                  }
                                },
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.redAccent,
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
    );
  }
}*/

/*class ImagenIcon extends StatelessWidget {
  final String url;

  ImagenIcon({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      url,
      width: 35,
      height: 35,
    );
  }
}

class TituloBotones extends StatelessWidget {
  String nombre;
  TituloBotones({super.key, required this.nombre});

  @override
  Widget build(BuildContext context) {
    return Text(
      nombre,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
    );
  }
}*/
/*Future<void> asignarEsquemaDeVacunacion(int id_bebe) async {
    final url = Uri.parse(
        '${Api.api}:${Api.port.toString()}/api/v1/bebe/asignarVacuna'); // Cambia la URL a la de tu API
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
  }*/
/*Positioned(
                                left: 3,
                                top: 140,
                                child: TituloBotones(
                                    nombre: "Esquema\nvacunacion"),
                              ),
                              Positioned(
                                left: -2,
                                top: 160,
                                child: IconButton(
                                  onPressed: () async {
                                    await asignarEsquemaDeVacunacion(
                                        bebe['id']);
                                    print('ID BEBE: ${bebe['id']}');
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              Esquemavacunasbebe(
                                            id_bebe: bebe['id'],
                                            nombre_bebe: bebe[
                                                'nombre'], //Aqui hay que acomodar para asignar el esquema de vacunacion
                                          ),
                                        ));
                                  },
                                  icon: ImagenIcon(
                                      url: 'images/calendarioVacuna.png'),
                                ),
                              ),
                              Positioned(
                                top: 140,
                                left: 65,
                                child: TituloBotones(
                                    nombre: "Historial\nvacunacion"),
                              ),
                              Positioned(
                                left: 60,
                                top: 160,
                                child: IconButton(
                                    onPressed: () async {
                                      // await asignarEsquemaDeVacunacion(bebe['id']);
                                      print('ID BEBE: ${bebe['id']}');
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                HistorialVacunacion(
                                              id_bebe: bebe['id'],
                                              nombre: bebe[
                                                  'nombre'], //Aqui hay que acomodar para asignar el esquema de vacunacion
                                            ),
                                          ));
                                    },
                                    //images/lista.png
                                    icon: ImagenIcon(
                                        url: 'images/historialVacuna.png')),
                              ),
                              Positioned(
                                  top: 140,
                                  left: 130,
                                  child: TituloBotones(
                                      nombre: "Registro\nmedicamentos")),
                              Positioned(
                                left: 130,
                                top: 160,
                                child: IconButton(
                                    onPressed: () async {
                                      // await asignarEsquemaDeVacunacion(bebe['id']);
                                      print('ID BEBE: ${bebe['id']}');
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  RegistroMedicamentos(
                                                    id_bebe: bebe['id'],
                                                  )));
                                    },
                                    icon: ImagenIcon(
                                        url:
                                            'images/recordatorioMedicamento.png')),
                              ),
                              Positioned(
                                  top: 140,
                                  left: 210,
                                  child: TituloBotones(
                                      nombre: "Lista\nmedicamentos")),
                              Positioned(
                                left: 210,
                                top: 160,
                                child: IconButton(
                                    onPressed: () async {
                                      // await asignarEsquemaDeVacunacion(bebe['id']);
                                      print('ID BEBE: ${bebe['id']}');
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ListaMedicamentos(
                                                    id_bebe: bebe['id']),
                                          ));
                                    },
                                    icon: ImagenIcon(
                                        url: 'images/listaMedicamentos.png')),
                              ),*/
/*  Navigator.push(
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
import 'package:app/SharedPreferences.dart';
import 'package:app/api/ApiConst.dart';
import 'package:app/function/varGlobales.dart';
import 'package:app/function/widget.dart';
import 'package:app/notifications_service.dart';
import 'package:app/perfil_bebe.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:workmanager/workmanager.dart';

class ListaBebe extends StatefulWidget {
  String ci;
  ListaBebe({super.key, required this.ci});

  @override
  State<ListaBebe> createState() => _ListaBebeState();
}

class _ListaBebeState extends State<ListaBebe> {
  @override
  void initState() {
    super.initState();
    setState(() {
      obtenerBebeUsuario(widget.ci);
    });
  }

  Widget _tipo = CircularProgressIndicator();
  List<dynamic> bebes = [];
  Map<int, int> imagenVersiones = {}; // Control de actualización de imágenes

  Future<void> obtenerBebeUsuario(String ci) async {
    final url = '${Api.url}/api/v1/bebe/obtener/$ci';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        setState(() {
          bebes = data['msg'];

          if (bebes.isEmpty) {
            _tipo = Text("No registro ningun bebe.");
          }
        });
      } else if (response.statusCode == 404) {
        print('Datos no encontrados');
        setState(() {
          bebes = [];
          _tipo = Text("No registro ningun bebe.");
        });
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error al realizar la solicitud: $error');
    }
  }

  Future<void> eliminarBebe(String nombre, String ciUsuario) async {
    final String apiUrl =
        '${Api.url}/api/v1/bebe/eliminar'; // Cambia por la URL real de tu API

    try {
      // Crear el cuerpo de la solicitud
      final Map<String, dynamic> body = {
        'nombre': nombre,
        'ci_usuario': ciUsuario,
      };

      // Realizar la solicitud POST
      final response = await http.put(
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
          await obtenerBebeUsuario(Globals.ci);

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

  List<dynamic> vacunas = [];
  Future<void> obtenerEsquemaVacunacionAplicado(int id_bebe) async {
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

  Future<void> tomarYGuardarFoto(int idBebe) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      try {
        final File image = File(pickedFile.path);

        // Obtener el directorio de almacenamiento local
        final directory = await getApplicationDocumentsDirectory();
        final path = '${directory.path}/$idBebe.jpg';

        // Copiar o sobrescribir la imagen seleccionada en el almacenamiento local
        await image.copy(path);

        // Forzar la actualización de la imagen
        setState(() {
          imagenVersiones[idBebe] =
              DateTime.now().millisecondsSinceEpoch; // Usamos un timestamp
        });

        print('Imagen guardada en: $path');
      } catch (e) {
        print('Error al guardar la imagen: $e');
      }
    } else {
      print('No se tomó ninguna foto');
    }
  }

  String _pathAll = '';
  Future<File?> _cargarImagen(int idBebe) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/$idBebe.jpg';
    _pathAll = path;
    final file = File(path);

    if (await file.exists()) {
      return file;
    } else {
      return null;
    }
  }

  Widget _imagenBebe(int idBebe) {
    final version = imagenVersiones[idBebe] ?? 0; // Control de actualización

    return FutureBuilder<File?>(
      key: ValueKey(version), // Clave única basada en el timestamp
      future: _cargarImagen(idBebe),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError || snapshot.data == null) {
          return Image.asset(
            'images/logoBaby.png', // Ruta de la imagen predeterminada
            height: 80,
            width: 80,
            fit: BoxFit.cover,
          );
        } else {
          return Image.file(
            snapshot.data!,
            height: 80,
            width: 80,
            fit: BoxFit.cover,
          );
        }
      },
    );
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

  @override
  Widget build(BuildContext context) {
    return Container(
      /*  decoration: fondoApp,
      height: double.infinity,
      width: double.infinity,*/
      child: bebes.isEmpty
          ? Center(
              child: _tipo,
            )
          : ListView.builder(
              itemCount: bebes.length,
              itemBuilder: (context, index) {
                final bebe = bebes[index];
                DateTime fechaNacimiento =
                    DateTime.parse(bebe['fecha_nacimiento']);
                String fechaFormateada =
                    DateFormat('dd/MM/yyyy').format(fechaNacimiento);

                return InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    addBabyId(bebe['id']);
                    Globals.idBebe = bebe['id'];
                    // Registrar tarea en Workmanager
                    /*  Workmanager().registerOneOffTask(
                      "1", // ID único
                      "mostrar_notificacion_desde_api", // Nombre de la tarea
                      inputData: {"id_bebe": bebe['id']}, // ID del bebé como parámetro
                      initialDelay: Duration(seconds: 5), // Retraso opcional
                    );*/
                    print("CI DEL PADRE: ${Globals.ci}");
                    print("ID DEL BEBE ${bebe['id']}");
                    asignarEsquemaDeVacunacion(bebe['id']);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PerfilBebe(
                          nombre: bebe['nombre'],
                          fecha: fechaFormateada,
                          genero: bebe['genero'],
                          id_bebe: bebe['id'],
                        ),
                      ),
                    ).then((result) {
                      if (result == true) {
                        setState(() {
                          obtenerBebeUsuario(Globals.ci);
                        });
                      }
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 180,
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 30,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: _imagenBebe(bebe['id']),
                            ),
                          ),
                          Positioned(
                            left: 100,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Nombre: ',
                                  style: styleColorRed,
                                ),
                                Text('${bebe['nombre']}',
                                    style: styleColorBlack),
                              ],
                            ),
                          ),
                          Positioned(
                            top: 40,
                            left: 100,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Fecha de Nacimiento: ',
                                  style: styleColorRed,
                                ),
                                Text('$fechaFormateada',
                                    style: styleColorBlack),
                              ],
                            ),
                          ),
                          Positioned(
                            top: 80,
                            left: 100,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Genero: ',
                                  style: styleColorRed,
                                ),
                                Text('${bebe['genero']}',
                                    style: styleColorBlack),
                              ],
                            ),
                          ),
                          Positioned(
                            left: 270,
                            child: IconButton(
                              onPressed: () {
                                tomarYGuardarFoto(bebe['id']);
                              },
                              icon: Icon(
                                Icons.camera_alt,
                                color: Colors.black,
                                size: 35,
                              ),
                            ),
                          ),
                          Positioned(
                            left: 270,
                            top: 110,
                            child: IconButton(
                              onPressed: () async {
                                bool? confirmDelete = await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Confirmar eliminación'),
                                      content: Text(
                                        '¿Estás seguro de que deseas eliminar a ${bebe['nombre']}?',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pop(false); // No eliminar
                                          },
                                          child: Text('Cancelar'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop(
                                                true); // Confirmar eliminación
                                          },
                                          child: Text(
                                            'Eliminar',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );

                                // Si el usuario confirma la eliminación, procede
                                if (confirmDelete == true) {
                                  await obtenerEsquemaVacunacionAplicado(
                                      bebe['id']);
                                  if (vacunas.isEmpty) {
                                    await eliminarBebe(
                                        bebe['nombre'], Globals.ci);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Center(
                                          child: Text(
                                            'Ya no es posible eliminar al bebe',
                                            style: styleColorWhite,
                                          ),
                                        ),
                                      ),
                                    );
                                    print("Ya no es posible eliminar al bebe");
                                  }

                                  setState(
                                      () {}); // Actualizar vista después de eliminar
                                }
                              },
                              icon: Icon(
                                Icons.delete,
                                color: Colors.redAccent,
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
    );
  }
}
