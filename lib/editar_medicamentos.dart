import 'package:app/api/ApiConst.dart';
import 'package:app/function/function.dart';
import 'package:app/function/widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class EditarMedicamentos extends StatefulWidget {
  String nombre;
  String descripcion;
  String hora;
  String fecha_inicio;
  String fecha_fin;
  String cantidad;
  String tipo;
  String unidad;
  int frecuencia;
  int id_bebe;
  int id_medicamento;
  EditarMedicamentos(
      {super.key,
      required this.id_bebe,
      required this.nombre,
      required this.descripcion,
      required this.hora,
      required this.fecha_inicio,
      required this.fecha_fin,
      required this.cantidad,
      required this.tipo,
      required this.frecuencia,
      required this.unidad,
      required this.id_medicamento});

  @override
  State<EditarMedicamentos> createState() => _EditarMedicamentosState();
}

class _EditarMedicamentosState extends State<EditarMedicamentos> {
  List<dynamic> medicamentos = [];
  Future<void> actualizarMedicamento(
      int id_medicamento,
      String nombre,
      String descripcion,
      String hora,
      String fecha_inicio,
      String fecha_fin,
      String cantidad,
      String tipo,
      String unidad,
      int frecuencia,
      int id_bebe) async {
    // URL de tu API
    String url =
        '${Api.url}/api/v1/medicamento/actualizar'; // Reemplaza con la URL correcta si es necesario

    // Construir el cuerpo de la solicitud
    final Map<String, dynamic> requestBody = {
      'id_recordatorio': id_medicamento,
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
        //    print(email);
        setState(() {
          //    Globals.emailAux = email;
        });
        Navigator.pop(context, true);
        print('Datos actualizados correctamente: ${jsonResponse['msg']}');
      } else {
        print(fecha_inicio);
        print('Error en la actualización: ${response.body}');
      }
    } catch (error) {
      print('Error al conectar con el servidor: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      print(widget.id_medicamento);
    });
// Inicializar los controladores con los valores que vienen desde el widget
    _nombreController = TextEditingController(text: widget.nombre);
    _descripcionController = TextEditingController(text: widget.descripcion);
    _fechaInicioController = TextEditingController(text: widget.fecha_inicio);
    _fechaFinController = TextEditingController(text: widget.fecha_fin);
    _tipoController = TextEditingController(text: widget.tipo);
    _horaInicioController = TextEditingController(text: widget.hora);
    _cantidadController = TextEditingController(text: widget.cantidad);
    _unidadController = TextEditingController(text: widget.unidad);
    _frecuenciaController =
        TextEditingController(text: widget.frecuencia.toString());
    // print("VERIFICANDO VG: " + Globals.ci);
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

  Widget _widget = const Text("Editar",
      style: TextStyle(
          fontWeight: FontWeight.bold, fontSize: 25, color: Colors.black));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink[200],
        title: Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            "Editar medicamentos",
            style: styleColorBlackAppBarTitulo,
          ),
        ),
      ),
      body: Container(
        decoration: fondoApp,
        height: double.infinity,
        width: double.infinity,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
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
                  padding: const EdgeInsets.all(20),
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
                                labelText: "Fecha de inicio",
                                labelStyle: TextStyle(color: Colors.pink[200]),
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
                                _selectDateFin(context), // Abre el DatePicker
                            child: InputDecorator(
                              decoration: InputDecoration(
                                labelText: "Fecha de fin",
                                labelStyle: TextStyle(color: Colors.pink[200]),
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
                Padding(
                  padding: const EdgeInsets.all(20),
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

                            // Valor inicial sincronizado con _tipoController
                            value: _tipoController.text.isNotEmpty &&
                                    ['Tableta', 'Jarabe']
                                        .contains(_tipoController.text)
                                ? _tipoController.text
                                : null,

                            // Opciones del Dropdown
                            items: <String>['Tableta', 'Jarabe']
                                .map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(
                                    fontWeight:
                                        FontWeight.normal, // Estilo normal
                                  ),
                                ),
                              );
                            }).toList(),

                            // Acción al seleccionar una opción
                            onChanged: (newValue) {
                              setState(() {
                                _tipoController.text =
                                    newValue!; // Actualiza el controlador
                              });
                            },

                            // Validador para el formulario
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Seleccione el tipo de medicamento';
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
                      });
                      await actualizarMedicamento(
                          widget.id_medicamento,
                          _nombreController.text,
                          _descripcionController.text,
                          _horaInicioController.text,
                          invertirFecha(_fechaInicioController.text),
                          invertirFecha(_fechaFinController.text),
                          _cantidadController.text,
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
      ),
    );
  }
}
