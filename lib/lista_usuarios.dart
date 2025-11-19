import 'package:app/api/ApiConst.dart';
import 'package:app/function/widget.dart';
import 'package:app/perfil_bebe.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ListaUsuarios extends StatefulWidget {
  const ListaUsuarios({super.key});

  @override
  State<ListaUsuarios> createState() => _ListaUsuariosState();
}

class _ListaUsuariosState extends State<ListaUsuarios> {
  List<dynamic> bebes = [];
  Future<void> obtenerUsuarios() async {
    final url = '${Api.url}/api/v1/users/obtener';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("ENTRO POR AQUI");
        setState(() {
          bebes = data['msg'];

          if (bebes.isEmpty) {}
        });
      } else if (response.statusCode == 404) {
        print('Datos no encontrados');
        setState(() {
          bebes = [];
        });
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error al realizar la solicitud: $error');
    }
  }

  Future<void> habilitarDeshabilitar(int role_id, String ci) async {
    final url = Uri.parse(
        '${Api.url}/api/v1/users/cambiarRol'); 
    final headers = {'Content-Type': 'application/json'};

    final body = json.encode({'role_id': role_id, 'ci': ci});

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data);
        if (data['ok']) {
          // Manejar respuesta exitosa
          print('Registro exitoso');
          obtenerUsuarios();
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
  void initState() {
    super.initState();
    setState(() {
      obtenerUsuarios();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      /*  decoration: fondoApp,
      height: double.infinity,
      width: double.infinity,*/
      child: bebes.isEmpty
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: bebes.length,
              itemBuilder: (context, index) {
                final bebe = bebes[index];

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 150,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [boxShadow],
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          //  left: 100,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Nombre: ',
                                style: styleColorRed,
                              ),
                              Text('${bebe['nombre']}', style: styleColorBlack),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 40,
                          //left: 100,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Cedula de identidad: ',
                                style: styleColorRed,
                              ),
                              Text('${bebe['ci']}', style: styleColorBlack),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 80,
                          // left: 100,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Email: ',
                                style: styleColorRed,
                              ),
                              Text('${bebe['email']}', style: styleColorBlack),
                            ],
                          ),
                        ),
                        if (bebe['role_id'] == 3)
                          Positioned(
                            left: 250,
                            top: 50,
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    habilitarDeshabilitar(5, bebe['ci']);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.red,
                                        boxShadow: [boxShadow]),
                                    child: Icon(
                                      Icons.person_add_disabled_outlined,
                                      size: 40,
                                    ),
                                  ),
                                ),
                                TituloBotones(
                                    nombre: 'Deshabilitar',
                                    colors: Colors.black)
                              ],
                            ),
                          ),
                        if (bebe['role_id'] == 5)
                          Positioned(
                            left: 250,
                            top: 50,
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    habilitarDeshabilitar(3, bebe['ci']);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.amber,
                                      boxShadow: [boxShadow]
                                    ),
                                    child: Icon(
                                      Icons.person_outline,
                                      size: 40,
                                    ),
                                  ),
                                ),
                                TituloBotones(
                                    nombre: 'Habilitar', colors: Colors.black)
                              ],
                            ),
                          ),
                        /*Positioned(
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
                        ),*/
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
