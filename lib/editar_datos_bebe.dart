import 'package:app/api/ApiConst.dart';

import 'package:app/function/function.dart';
import 'package:app/function/varGlobales.dart';
import 'package:app/function/widget.dart';

import 'package:flutter/material.dart';
import 'dart:convert'; // Para usar jsonEncode
import 'package:http/http.dart' as http;

class EditarDatosBebe extends StatefulWidget {
  String nombre;
  String fecha_nacimiento;
  String genero;
  int id_bebe;
  final Function() onUpdate;
  EditarDatosBebe({
    super.key,
    required this.nombre,
    required this.fecha_nacimiento,
    required this.genero,
    required this.id_bebe,
    required this.onUpdate,
  });

  @override
  State<EditarDatosBebe> createState() => _EditarDatosBebeState();
}

class _EditarDatosBebeState extends State<EditarDatosBebe> {
  Future<void> actualizarDatosBebe(String nombre, String nombreN,
      String fechaNacimiento, String genero) async {
    setState(() {
      _widget = const CircularProgressIndicator();
    });
    // URL de tu API
    String url =
        '${Api.url}/api/v1/bebe/actualizar'; // Reemplaza con la URL correcta si es necesario

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
        print(widget.id_bebe);
        await actualizarEsquemaVacunacion(widget.id_bebe);
        setState(() {
          _widget = const Text("Editar",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Colors.black));
          Globals.bandera = true;
        });
        /* Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => ListaBebe(),
          ),
          (route) => false,
        );*/
        //   Navigator.pop(context, true);
        widget.onUpdate();
        print('Datos actualizados correctamente: ${jsonResponse['msg']}');
      } else {
        print('Error en la actualización: ${response.body}');
      }
    } catch (error) {
      print('Error al conectar con el servidor: $error');
    }
  }

  Future<void> actualizarEsquemaVacunacion(int id_bebe) async {
    // URL de tu API
    String url =
        '${Api.url}/api/v1/bebe/actualizarEsquema'; // Reemplaza con la URL correcta si es necesario

    // Construir el cuerpo de la solicitud
    final Map<String, dynamic> requestBody = {'id_bebe': id_bebe};

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

        /* Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => ListaBebe(),
          ),
          (route) => false,
        );*/

        print('Datos actualizados correctamente: ${jsonResponse['msg']}');
      } else {
        print('Error en la actualización: ${response.body}');
      }
    } catch (error) {
      print('Error al conectar con el servidor: $error');
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    // Si el campo de texto no está vacío, toma la fecha seleccionada previamente, si no, toma la fecha actual
    DateTime? currentDate = DateTime.now();

    if (_fechaController.text.isNotEmpty) {
      // Si ya hay una fecha en el controlador, convertirla a DateTime
      List<String> dateParts = _fechaController.text.split('/');
      currentDate = DateTime(
        int.parse(dateParts[2]), // Año
        int.parse(dateParts[1]), // Mes
        int.parse(dateParts[0]), // Día
      );
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: currentDate, // Usa la fecha existente o la actual
      firstDate: DateTime(2000), // Fecha mínima
      lastDate: DateTime(2101), // Fecha máxima
    );

    if (picked != null) {
      setState(() {
        _fechaController.text =
            "${picked.day}/${picked.month}/${picked.year}"; // Actualiza el controlador con la nueva fecha
      });
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
    return Container(
      /* decoration: fondoApp,
        height: double.infinity,
        width: double.infinity,*/
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              /*Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  "Editar datos del bebe",
                  style: styleColorBlack,
                ),
              ),*/
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
                    boxShadow: [boxShadow],
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
                                  ? 'Seleccione una fecha' // Si no hay fecha seleccionada
                                  : _fechaController
                                      .text, // Si ya hay una fecha, la muestra
                              style: TextStyle(fontSize: 15.5),
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
                    boxShadow: [boxShadow],
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
                            labelStyle: TextStyle(
                              color: Colors.pink[200],
                            ),
                          ),
                          value: _generoController.text.isNotEmpty
                              ? _generoController.text
                              : null, // Usar el valor del controller
                          items: <String>['Masculino', 'Femenino']
                              .map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(
                                  fontWeight: FontWeight
                                      .normal, // Asegura que no sea negrita
                                ),
                              ),
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
                    boxShadow: [boxShadow],
                  ),
                  child: Center(
                    child: _widget,
                  ),
                ),
                onTap: () async {
                  if (_formKey.currentState!.validate()) {
                    await actualizarDatosBebe(
                        widget.nombre,
                        capitalizarPrimeraLetra(_nombreController.text),
                        invertirFecha(_fechaController.text),
                        capitalizarPrimeraLetra(_generoController.text));
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
