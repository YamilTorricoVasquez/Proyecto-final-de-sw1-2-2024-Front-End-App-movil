import 'package:app/SharedPreferences.dart';
import 'package:app/api/ApiConst.dart';

import 'package:app/editar_datos_padre.dart';
import 'package:app/function/varGlobales.dart';
import 'package:app/function/widget.dart';
import 'package:app/lista_usuarios.dart';
import 'package:app/perfil_bebe.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
//import 'package:workmanager/workmanager.dart';

class ScaffoldAdmin extends StatefulWidget {
  String email;
  ScaffoldAdmin({super.key, required this.email});

  @override
  State<ScaffoldAdmin> createState() => _ScaffoldAdminState();
}

class _ScaffoldAdminState extends State<ScaffoldAdmin> {
  String _nombreUsuario = '';
  String _ciUsuario = '';
  String _email = '';
  String _password = '';
  Future<void> obtenerDatosUsuarioLogeado(String email) async {
    final url =
        '${Api.url}/api/v1/users/nombre/$email'; // Cambia 'localhost' si es necesario

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          // print(_nombreUsuario);
          _nombreUsuario = data['msg']['nombre']; // Actualiza el estado
          _ciUsuario = data['msg']['ci'];
          _email = data['msg']['email'];
          _password = data['msg']['password'];
          Globals.ci = data['msg']['ci'];
          /*_widget = ListaBebe(
            ci: _ciUsuario,
          );*/
          // _colors2 = Colors.pink.shade200;
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

  @override
  void initState() {
    super.initState();
    setState(() {
      obtenerDatosUsuarioLogeado(widget.email);
    });
  }

  Widget _pantalla = Text("");
  Color _color1 = Colors.white;
  Color _color2 = Colors.black;
  Color _color3 = Colors.white;
  Color _color4 = Colors.white;
  String _titulo = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            clipBehavior: Clip.none,
            decoration: BoxDecoration(
              /* borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),*/
              color: Colors.amber,
              boxShadow: [boxShadow],
            ),
            width: double.infinity,
            height: 130,
            child: Stack(
              children: [
                Center(
                  child: Text(
                    'Bienvenido, ${_nombreUsuario}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                Positioned(
                  left: 20,
                  top: 75,
                  child: Column(
                    children: [
                      InkWell(
                          onTap: () {
                            setState(() {
                              _titulo = 'Editar datos';
                              _color2 = Colors.grey;
                              _color1 = Colors.white;
                              _pantalla = EditarDatosPadre(
                                  ci: _ciUsuario,
                                  email: _email,
                                  nombre: _nombreUsuario,
                                  onUpdate: () {
                                    obtenerDatosUsuarioLogeado(widget.email);
                                  });
                            });
                          },
                          child: Icon(
                            Icons.edit,
                            color: _color2,
                          )),
                      //  TituloBotones(nombre: "Editar", colors: Colors.black)
                    ],
                  ),
                ),
                Positioned(
                  right: 20, // Distancia al borde derecho
                  top: 50, // Distancia al borde superior
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            _titulo = 'Editar datos';
                            _color2 = Colors.white;
                            _color1 = Colors.white;
                          });
                          Navigator.pop(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white),
                          child: Image.asset(
                            'images/cerrar.png',
                            scale: 11,
                          ),
                        ),
                      ),
                      TituloBotones(nombre: "Cerrar", colors: Colors.black),
                      TituloBotones(nombre: "Sesion", colors: Colors.black)
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Text(
            _titulo,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: _pantalla,
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
                /* borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),*/
                color: Colors.amber,
                boxShadow: [boxShadow]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {
                          setState(() {});
                          _color1 = Colors.grey;
                          _color2 = Colors.black;
                          _pantalla = ListaUsuarios();
                          _titulo = 'Lista de usuarios';
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: _color1,
                            boxShadow: [boxShadow],
                          ),
                          child: ImagenIcon(url: 'images/listaClientes.png'),
                        ),
                      ),
                      TituloBotones(nombre: "Lista", colors: Colors.black),
                      TituloBotones(nombre: "Clientes", colors: Colors.black)
                    ],
                  ),
                ),
                  Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {
                          setState(() {});
                          //Workmanager().cancelAll();
                          //BabyIdsStorage.clearBabyIds();

                          print("Elimino");
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            boxShadow: [boxShadow],
                          ),
                          child: ImagenIcon(url: 'images/listaClientes.png'),
                        ),
                      ),
                      TituloBotones(nombre: "Eliminar", colors: Colors.black),
                      TituloBotones(nombre: "Tareas", colors: Colors.black)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
