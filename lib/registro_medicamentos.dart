import 'package:app/api/ApiConst.dart';
import 'package:app/function/function.dart';
import 'package:app/function/widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class RegistroMedicamentos extends StatefulWidget {
  int id_bebe;
  RegistroMedicamentos({super.key, required this.id_bebe});

  @override
  State<RegistroMedicamentos> createState() => _RegistroMedicamentosState();
}

class _RegistroMedicamentosState extends State<RegistroMedicamentos> {
  Future<void> registrarMedicamento(
      String nombre,
      String descripcion,
      String hora,
      String fecha_inicio,
      String fecha_fin,
      int cantidad,
      String tipo,
      String unidad,
      int frecuencia,
      int id_bebe) async {
    final url = Uri.parse(
        '${Api.url}/api/v1/medicamento/registrar'); // Cambia la URL a la de tu API
    final headers = {'Content-Type': 'application/json'};

    final body = json.encode({
      'nombre_medicamento': nombre,
      'descripcion_medicamento': descripcion,
      'hora': hora,
      'fecha_inicio': fecha_inicio,
      'fecha_fin': fecha_fin,
      'cantidad': cantidad,
      'tipo': tipo,
      'unidad': unidad,
      'frecuencia': frecuencia,
      'id_bebe': id_bebe
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
            _descripcionController.text = "";
            _fechaInicioController.text = "";
            _fechaFinController.text = "";
            _frecuenciaController.text = "";
            _tipoController.text = "";
            _cantidadController.text = "";
            _horaInicioController.text = "";
            _unidadController.text = "";
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
    // Si el campo de texto no está vacío, toma la fecha seleccionada previamente, si no, toma la fecha actual
    DateTime? currentDate = DateTime.now();

    if (_fechaInicioController.text.isNotEmpty) {
      // Si ya hay una fecha en el controlador, convertirla a DateTime
      List<String> dateParts = _fechaInicioController.text.split('/');

      currentDate = DateTime(
        int.parse(dateParts[2]), // Año
        int.parse(dateParts[1]), // Mes
        int.parse(dateParts[0]), // Día
      );
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: currentDate, // Usa la fecha existente o la actual
      firstDate: DateTime(1999), // Fecha mínima
      lastDate: DateTime(2101), // Fecha máxima
    );

    if (picked != null) {
      setState(() {
        _fechaInicioController.text =
            "${picked.day}/${picked.month}/${picked.year}"; // Actualiza el controlador con la nueva fecha
      });
    }
  }

  Future<void> _selectDateFin(BuildContext context) async {
    // Si el campo de texto no está vacío, toma la fecha seleccionada previamente, si no, toma la fecha actual
    DateTime? currentDate = DateTime.now();

    if (_fechaFinController.text.isNotEmpty) {
      // Si ya hay una fecha en el controlador, convertirla a DateTime
      List<String> dateParts = _fechaFinController.text.split('/');

      currentDate = DateTime(
        int.parse(dateParts[2]), // Año
        int.parse(dateParts[1]), // Mes
        int.parse(dateParts[0]), // Día
      );
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: currentDate, // Usa la fecha existente o la actual
      firstDate: DateTime(1999), // Fecha mínima
      lastDate: DateTime(2101), // Fecha máxima
    );

    if (picked != null) {
      setState(() {
        _fechaFinController.text =
            "${picked.day}/${picked.month}/${picked.year}"; // Actualiza el controlador con la nueva fecha
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        // Formatear la hora en formato de 24 horas o 12 horas
        _horaInicioController.text = pickedTime.format(context);
      });
    }
  }

  final _formKey = GlobalKey<FormState>();
  TextEditingController _nombreController = TextEditingController();
  TextEditingController _descripcionController = TextEditingController();
  TextEditingController _fechaInicioController = TextEditingController();
  TextEditingController _fechaFinController = TextEditingController();
  TextEditingController _tipoController = TextEditingController();
  TextEditingController _horaInicioController = TextEditingController();
  TextEditingController _cantidadController = TextEditingController();
  TextEditingController _unidadController = TextEditingController();
  TextEditingController _frecuenciaController = TextEditingController();

  Widget _widget = const Text("Registrar",
      style: TextStyle(
          fontWeight: FontWeight.bold, fontSize: 25, color: Colors.black));
  @override
  Widget build(BuildContext context) {
    return Container(
     // decoration: fondoApp,
     // height: double.infinity,
      //width: double.infinity,
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(5),
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
                            labelText: "Nombre del medicamento",
                            labelStyle: TextStyle(
                              color: Colors.pink[200],
                            ),
                          ),
                          controller: _nombreController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Ingrese el nombre del medicamento.';
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
                padding: const EdgeInsets.all(5),
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
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: "Para que sirve el medicamento",
                            labelStyle: TextStyle(
                              color: Colors.pink[200],
                            ),
                          ),
                          controller: _descripcionController,
                          /* validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Ingrese el nombre del medicamento.';
                              }
                              return null;
                            },*/
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(color: Colors.black26, blurRadius: 10)
                    ],
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: InkWell(
                          onTap: () =>
                              _selectTime(context), // Abre el TimePicker
                          child: InputDecorator(
                            decoration: InputDecoration(
                              labelText: "Hora de inicio",
                              labelStyle: TextStyle(color: Colors.pink[200]),
                              border: InputBorder.none,
                            ),
                            child: Text(
                              _horaInicioController.text.isEmpty
                                  ? 'Seleccione una hora' // Si no hay hora seleccionada
                                  : _horaInicioController
                                      .text, // Si ya hay una hora, la muestra
                              style: TextStyle(fontSize: 15.5),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 51,
                      width: 150,
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
                                  labelText: "Fecha de inicio",
                                  labelStyle:
                                      TextStyle(color: Colors.pink[200]),
                                  border: InputBorder.none,
                                ),
                                child: Text(
                                  _fechaInicioController.text.isEmpty
                                      ? 'Seleccione una fecha' // Si no hay fecha seleccionada
                                      : _fechaInicioController
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
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 51,
                      width: 150,
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
                                  _selectDateFin(context), // Abre el DatePicker
                              child: InputDecorator(
                                decoration: InputDecoration(
                                  labelText: "Fecha de fin",
                                  labelStyle:
                                      TextStyle(color: Colors.pink[200]),
                                  border: InputBorder.none,
                                ),
                                child: Text(
                                  _fechaFinController.text.isEmpty
                                      ? 'Seleccione una fecha' // Si no hay fecha seleccionada
                                      : _fechaFinController
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
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(5),
                child: Container(
                  decoration: BoxDecoration(
                    // border: Border.all(color: Colors.white),
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
                            labelText: "Tipo de medicamento",
                            labelStyle: TextStyle(
                              color: Colors.pink[200],
                            ),
                          ),

                          value: _tipoController.text.isNotEmpty
                              ? _tipoController.text
                              : null, // Usar el valor del controller
                          items:
                              <String>['Tableta', 'Jarabe'].map((String value) {
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
                              _tipoController.text =
                                  newValue!; // Actualizar el valor del controller
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Seleccione el tipo del medicamento';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5),
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
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: "Cantidad del medicamento",
                            labelStyle: TextStyle(
                              color: Colors.pink[200],
                            ),
                          ),
                          controller: _cantidadController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Ingrese la cantidad de su medicamento.';
                            }
                            return null;
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),

              if (_tipoController.text == 'Jarabe')
                Padding(
                  padding: const EdgeInsets.all(5),
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
                              labelText: "Unidad del medicamento",
                              labelStyle: TextStyle(
                                color: Colors.pink[200],
                              ),
                            ),
                            controller: _unidadController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Ingrese la unidad del medicamento.';
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
                padding: const EdgeInsets.all(5),
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
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: "Frecuencia del medicamento",
                            labelStyle: TextStyle(
                              color: Colors.pink[200],
                            ),
                          ),
                          controller: _frecuenciaController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Ingrese la frecuencia del medicamento.';
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
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    // width: 318,
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
                ),
                onTap: () async {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      _widget = const CircularProgressIndicator();
                    });
                    await registrarMedicamento(
                        _nombreController.text,
                        _descripcionController.text,
                        _horaInicioController.text,
                        invertirFecha(_fechaInicioController.text),
                        invertirFecha(_fechaFinController.text),
                        int.parse(_cantidadController.text),
                        _tipoController.text,
                        _unidadController.text,
                        int.parse(_frecuenciaController.text),
                        widget.id_bebe);
                  }
                },
              ),
              SizedBox(height: 20),
              // Text(_existe)
            ],
          ),
        ),
      ),
    );
  }
}
