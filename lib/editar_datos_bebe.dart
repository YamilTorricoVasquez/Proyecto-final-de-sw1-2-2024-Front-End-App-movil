import 'package:app/Inicio.dart';
import 'package:app/api/ApiConst.dart';

import 'package:app/function/function.dart';

import 'package:flutter/material.dart';
import 'dart:convert'; // Para usar jsonEncode
import 'package:http/http.dart' as http;

class EditarDatosBebe extends StatefulWidget {
  String nombre;
  String fecha_nacimiento;
  String genero;
  EditarDatosBebe(
      {super.key,
      required this.nombre,
      required this.fecha_nacimiento,
      required this.genero});

  @override
  State<EditarDatosBebe> createState() => _EditarDatosBebeState();
}

class _EditarDatosBebeState extends State<EditarDatosBebe> {
  Future<void> actualizarDatosBebe(String nombre, String nombreN,
      String fechaNacimiento, String genero) async {
    // URL de tu API
    String url =
        '${Api.api}:${Api.port.toString()}/api/v1/bebe/actualizar'; // Reemplaza con la URL correcta si es necesario

    // Construir el cuerpo de la solicitud
    final Map<String, dynamic> requestBody = {
      'nombre': nombre,
      'nombreN': nombreN,
      'fecha_nacimiento': fechaNacimiento,
      'genero': genero,
    };

    try {
      // Realizar la solicitud PUT
      final response = await http.put(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody), // Convertir el cuerpo a JSON
      );

      // Comprobar la respuesta
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        setState(() {
          _widget = const Text("Editar",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Colors.black));
        });
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const Inicio(),
          ),
          (route) => false,
        );
        print('Datos actualizados correctamente: ${jsonResponse['msg']}');
      } else {
        print('Error en la actualización: ${response.body}');
      }
    } catch (error) {
      print('Error al conectar con el servidor: $error');
    }
  }

  Widget _widget = const Text("Editar",
      style: TextStyle(
          fontWeight: FontWeight.bold, fontSize: 25, color: Colors.black));
  // String _existe = "";
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nombreController = TextEditingController();
  TextEditingController _fechaController = TextEditingController();
  TextEditingController _generoController = TextEditingController();
  @override
  void initState() {
    super.initState();

    // Inicializar los controladores con los valores que vienen desde el widget
    _nombreController = TextEditingController(text: widget.nombre);
    _fechaController = TextEditingController(text: widget.fecha_nacimiento);
    _generoController = TextEditingController(text: widget.genero);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink[200],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  "Editar datos del bebe",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Colors.pink),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                          blurRadius: 5, spreadRadius: 0.5, color: Colors.black)
                    ],
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: "Nombre del bebe",
                            labelStyle: TextStyle(
                              color: Colors.pink[200],
                            ),
                          ),
                          controller: _nombreController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Ingrese el nombre de su bebe.';
                            }
                            return null;
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                          blurRadius: 5, spreadRadius: 0.5, color: Colors.black)
                    ],
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: "Fecha de nacimiento",
                            labelStyle: TextStyle(
                              color: Colors.pink[200],
                            ),
                          ),
                          controller: _fechaController,
                          keyboardType: TextInputType.datetime,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Ingrese la fecha de su bebe.';
                            }
                            return null;
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                          blurRadius: 5, spreadRadius: 0.5, color: Colors.black)
                    ],
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: "Genero",
                            labelStyle: TextStyle(
                              color: Colors.pink[200],
                            ),
                          ),
                          controller: _generoController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Ingrese el genero de su bebe.';
                            }
                            return null;
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
              InkWell(
                child: Container(
                  width: 318,
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green.shade200),
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.green[200],
                    boxShadow: const [
                      BoxShadow(
                          blurRadius: 5,
                          spreadRadius: 0.5,
                          color: Colors.black),
                    ],
                  ),
                  child: Center(
                    child: _widget,
                  ),
                ),
                onTap: () async {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      actualizarDatosBebe(
                          widget.nombre,
                          capitalizarPrimeraLetra(_nombreController.text),
                          invertirFecha(_fechaController.text),
                          capitalizarPrimeraLetra(_generoController.text));
                      _widget = const CircularProgressIndicator();
                    });
                  }
                },
              ),
              // Text(_existe)
            ],
          ),
        ),
      ),
    );
  }
}
