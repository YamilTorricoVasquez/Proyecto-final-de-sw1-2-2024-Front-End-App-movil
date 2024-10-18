import 'package:app/api/ApiConst.dart';
import 'package:app/login.dart';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Registrar extends StatefulWidget {
  const Registrar({super.key});

  @override
  State<Registrar> createState() => _RegistrarState();
}

class _RegistrarState extends State<Registrar> {
  Future<void> registerUser(
      String ci, String nombre, String email, String password) async {
    final url = Uri.parse(
        '${Api.api}:${Api.port.toString()}/api/v1/users/register'); // Cambia la URL a la de tu API
    final headers = {'Content-Type': 'application/json'};

    final body = json.encode({
      'ci': ci,
      'nombre': nombre,
      'email': email,
      'password': password,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['ok']) {
          // Manejar respuesta exitosa
          print('Registro exitoso');
          print('Token: ${data['msg']['token']}');
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

  bool _bool = true;
  Icon _icon = const Icon(Icons.visibility_off_outlined);
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _ciController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 80),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(width: 20),
                  InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Login(),
                        ),
                        (route) => false,
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 5,
                            spreadRadius: 0.8,
                          ),
                        ],
                        color: Colors.white,
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        size: 45,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 80),
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
                            labelText: "Nombre completo",
                            labelStyle: TextStyle(
                              color: Colors.pink[200],
                            ),
                          ),
                          controller: _nombreController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Ingrese su nombre completo.';
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
                            labelText: "Cedula de identidad",
                            labelStyle: TextStyle(
                              color: Colors.pink[200],
                            ),
                          ),
                          controller: _ciController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Ingrese su cedula de identidad.';
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
                            labelText: "Correo electronico",
                            labelStyle: TextStyle(
                              color: Colors.pink[200],
                            ),
                          ),
                          controller: _emailController,
                          validator: (value) {
                            // Verificar si el campo está vacío
                            if (value == null || value.isEmpty) {
                              return 'Por favor, ingresa un correo electrónico';
                            }
                            // Verificar si el formato del email es correcto usando una expresión regular
                            final RegExp emailRegex = RegExp(
                                r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$');
                            if (!emailRegex.hasMatch(value)) {
                              return 'Por favor, ingresa un correo válido';
                            }
                            return null; // Si el valor es válido
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
                            labelText: "Contraseña",
                            labelStyle: TextStyle(
                              color: Colors.pink[200],
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _bool = !_bool;
                                  if (_bool) {
                                    _icon = const Icon(
                                        Icons.visibility_off_outlined);
                                  } else {
                                    _icon =
                                        const Icon(Icons.visibility_outlined);
                                  }
                                });
                              },
                              icon: _icon,
                            ),
                          ),
                          obscureText: _bool,
                          controller: _passwordController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Ingrese su contraseña.';
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
                borderRadius: BorderRadius.circular(20),
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
                  child: const Center(
                    child: Text(
                      "Registrar",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                onTap: () async {
                  if (_formKey.currentState!.validate()) {
                    await registerUser(
                        _ciController.text,
                        _nombreController.text,
                        _emailController.text,
                        _passwordController.text);
                  }

                  //  setState(() {});
                },
              ),
              const SizedBox(height: 20)
            ],
          ),
        ),
      ),
    );
  }
}
