import 'package:app/api/ApiConst.dart';
import 'package:app/function/function.dart';
import 'package:app/function/varGlobales.dart';
import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class RegistroBebe extends StatefulWidget {
  const RegistroBebe({super.key});

  @override
  State<RegistroBebe> createState() => _RegistroBebeState();
}

class _RegistroBebeState extends State<RegistroBebe> {
  Future<void> registrarBebe(String nombre, String fecha_nacimiento,
      String genero, String ci_usuario) async {
    final url = Uri.parse(
        '${Api.api}:${Api.port.toString()}/api/v1/bebe/registrar'); // Cambia la URL a la de tu API
    final headers = {'Content-Type': 'application/json'};

    final body = json.encode({
      'nombre': nombre,
      'fecha_nacimiento': fecha_nacimiento,
      'genero': genero,
      'ci_usuario': ci_usuario,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['ok']) {
          // Manejar respuesta exitosa
          print('Registro exitoso');
          // print('Token: ${data['msg']['token']}');
          setState(() {
            _widget = const Text("Registrar",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: Colors.black));
            _nombreController.text = "";
            _fechaController.text = "";
            _generoController.text = "";
            // _selectedGenero = "";
          });
          // Navegar a la siguiente pantalla o realizar acciones necesarias
        } else {
          // Manejar error en el registro
          print('Error en el registro: ${data['msg']}');
        }
      } else {
        setState(() {
          _widget = const Text("Registrar",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Colors.black));
        });
        print('Error en la solicitud: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Fecha inicial
      firstDate: DateTime(2000), // Fecha mínima
      lastDate: DateTime(2101), // Fecha máxima
    );
    if (picked != null) {
      setState(() {
        _fechaController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  Widget _widget = const Text("Registrar",
      style: TextStyle(
          fontWeight: FontWeight.bold, fontSize: 25, color: Colors.black));

  final _formKey = GlobalKey<FormState>();
  String? _selectedGenero; // Para almacenar la opción seleccionada
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _fechaController = TextEditingController();
  final TextEditingController _generoController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  "Registrar bebe",
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
                        child: InkWell(
                          onTap: () =>
                              _selectDate(context), // Abre el DatePicker
                          child: InputDecorator(
                            decoration: InputDecoration(
                              labelText: "Fecha de nacimiento",
                              labelStyle: TextStyle(color: Colors.pink[200]),
                              border: InputBorder.none,
                            ),
                            child: Text(
                              _fechaController.text.isEmpty
                                  ? 'Seleccione una fecha'
                                  : _fechaController.text,
                            ),
                          ),
                        ),
                      ),
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
                          blurRadius: 5,
                          spreadRadius: 0.5,
                          color: Colors.black),
                    ],
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: "Género",
                            labelStyle: TextStyle(color: Colors.pink[200]),
                          ),
                          value: _generoController.text.isNotEmpty
                              ? _generoController.text
                              : null, // Usar el valor del controller
                          items: <String>['Masculino', 'Femenino']
                              .map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _generoController.text =
                                  newValue!; // Actualizar el valor del controller
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Seleccione el género del bebé';
                            }
                            return null;
                          },
                        ),
                      ),
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
                      _widget = const CircularProgressIndicator();
                    });
                    await registrarBebe(
                        capitalizarPrimeraLetra(_nombreController.text),
                        invertirFecha(_fechaController.text),
                        capitalizarPrimeraLetra(_generoController.text),
                        Globals.ci);
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
