import 'package:app/api/ApiConst.dart';
import 'package:app/function/varGlobales.dart';
import 'package:app/function/widget.dart';
import 'package:flutter/material.dart';
import 'dart:convert'; // Para usar jsonEncode
import 'package:http/http.dart' as http;

class EditarDatosPadre extends StatefulWidget {
  String ci = '';
  String email = '';
  String nombre = '';
  final Function() onUpdate;
  EditarDatosPadre({
    super.key,
    required this.ci,
    required this.email,
    required this.nombre,
    required this.onUpdate,
  });

  @override
  State<EditarDatosPadre> createState() => _EditarDatosPadreState();
}

class _EditarDatosPadreState extends State<EditarDatosPadre> {
  Widget _widget = const Text("Editar",
      style: TextStyle(
          fontWeight: FontWeight.bold, fontSize: 25, color: Colors.black));
  Future<void> actualizarDatosUsuario(String ci, String ciN, String email,
      String password, String nombre) async {
    // URL de tu API
    String url =
        '${Api.url}/api/v1/users/actualizar'; // Reemplaza con la URL correcta si es necesario

    // Construir el cuerpo de la solicitud
    final Map<String, dynamic> requestBody = {
      'ci': ci,
      'ciN': ciN,
      'email': email,
      'password': password,
      'nombre': nombre
    };

    try {
      // Realizar la solicitud PUT
      final response = await http.post(
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

        /* Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => ListaBebe(),
          ),
          (route) => false,
        );*/
        print(email);
        setState(() {
          Globals.emailAux = email;
        });
        widget.onUpdate();
        //  Navigator.pop(context, true);
        print('Datos actualizados correctamente: ${jsonResponse['msg']}');
      } else {
        print('Error en la actualización: ${response.body}');
      }
    } catch (error) {
      print('Error al conectar con el servidor: $error');
    }
  }

  bool _bool = true;
  Icon _icon = const Icon(Icons.visibility_off_outlined);
  final _formKey = GlobalKey<FormState>();
  TextEditingController _ciController = TextEditingController();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _nombreController = TextEditingController();
  @override
  void initState() {
    super.initState();

    // Inicializar los controladores con los valores que vienen desde el widget
    _ciController = TextEditingController(text: widget.ci);
    _emailController = TextEditingController(text: widget.email);
    _nombreController = TextEditingController(text: widget.nombre);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
     /* decoration: fondoApp,
      height: double.infinity,
      width: double.infinity,*/
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
            /*  Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  "Edita tus datos",
                  style: styleColorPinkTitulo,
                ),
              ),*/
              SizedBox(height: 40),
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
                            labelText: "Cedula de Identidad",
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
                            labelText: "Contraseña nueva",
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
                          /* validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Ingrese su nueva contraseña.';
                              }
                              return null;
                            },*/
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
                            labelText: "Nombre",
                            labelStyle: TextStyle(
                              color: Colors.pink[200],
                            ),
                          ),
                          controller: _nombreController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Ingrese su nombre.';
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
                    boxShadow: [boxShadow],
                  ),
                  child: Center(
                    child: _widget,
                  ),
                ),
                onTap: () async {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      _widget = const CircularProgressIndicator();
                      actualizarDatosUsuario(
                          Globals.ci,
                          _ciController.text,
                          _emailController.text,
                          _passwordController.text,
                          _nombreController.text);
                    });
                  }
                },
              ),
              SizedBox(
                height: 20,
              )
              // Text(_existe)
            ],
          ),
        ),
      ),
    );
  }
}
