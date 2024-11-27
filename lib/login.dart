import 'package:app/Inicio.dart';
import 'package:app/api/ApiConst.dart';
import 'package:app/function/widget.dart';

import 'package:app/registrar.dart';
import 'package:app/function/varGlobales.dart';
import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String _valido = "";

  Future<void> login(String email, String password) async {
    final url = Uri.parse('${Api.url}/api/v1/users/login'); // Cambia por tu URL

    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        // Si el inicio de sesión es exitoso
        final data = jsonDecode(response.body);
        String token = data['msg']['token']; // Token JWT

        int roleId = data['msg']['role_id']; // Role ID
        // obtenerNombreUsuario(email);
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Inicio(),
            ));
        print("probando variable global: " + Globals.email);
        print('Inicio de sesión exitoso. Token: $token, Role ID: $roleId');
      } else {
        // Manejar errores en la solicitud
        final errorData = jsonDecode(response.body);
        if (errorData['error'] == "Contraseña incorrecta") {
          setState(() {
            _valido = errorData['error'];
          });
        } else {
          if (errorData['error'] == "Email no existe") {
            setState(() {
              _valido = errorData['error'];
            });
          }
        }
        print('Error: ${errorData['error']}');
      }
    } catch (error) {
      print('Error en la solicitud: $error');
    }
  }

  bool _bool = true;
  Icon _icon = const Icon(Icons.visibility_off_outlined);
  Widget _text = const Text(
    "Iniciar sesion",
    style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 25,
      color: Colors.black,
    ),
  );
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: fondoApp,
        height: double.infinity,
        width: double.infinity,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 80),
                //Image.network('https://st2.depositphotos.com/4207741/9966/v/450/depositphotos_99667454-stock-illustration-baby-boy-and-girl.jpg',height: 180,),
                Container(
                  height: 180,
                  width: 180,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 5,
                          spreadRadius: 0.8,
                        )
                      ],
                      color: Colors.white),
                  child: Image.asset(
                    'images/logoBaby.png',
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [boxShadow],
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
                      boxShadow: [boxShadow],
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
                                          _icon = const Icon(
                                              Icons.visibility_outlined);
                                        }
                                      });
                                    },
                                    icon: _icon)),
                            controller: _passwordController,
                            obscureText: _bool,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Ingrese su contraseña.';
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
                  borderRadius: BorderRadius.circular(20),
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
                      child: _text,
                    ),
                  ),
                  onTap: () async {
                    Globals.email = _emailController.text;
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        _text = const CircularProgressIndicator();
                      });
                    /* Workmanager().registerOneOffTask(
                        "2", // ID único
                        "mostrar_notificacion_desde_api",
                      );*/ // Nombre de la tarea
                      await login(
                          _emailController.text, _passwordController.text);
                      setState(() {
                        _text = Text("Iniciar sesion",
                            style: styleColorBlackBotones);
                      });
                    }
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.end,
                    //  crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const SizedBox(width: 220),
                      InkWell(
                        borderRadius: BorderRadius.circular(20),
                        child: const Text(
                          "Registrarse",
                          style: TextStyle(color: Colors.pink, fontSize: 18),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Registrar(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Text(_valido)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
