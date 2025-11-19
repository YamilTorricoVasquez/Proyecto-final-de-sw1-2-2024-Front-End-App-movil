import 'package:app/api/ApiConst.dart';
import 'package:app/function/varGlobales.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class GraficaTorta extends StatefulWidget {
  @override
  State<GraficaTorta> createState() => _GraficaTortaState();
}

class _GraficaTortaState extends State<GraficaTorta> {
  List<dynamic> interpretadores = [];
  bool cargando = true; // Variable para mostrar el indicador de carga
  String mensajeError = ""; // Variable para mostrar errores

  @override
  void initState() {
    super.initState();
    obtenerDatosGrafica(Globals.idBebe); // Llama a la API al inicializar
  }

  Future<void> obtenerDatosGrafica(int id_bebe) async {
    setState(() {
      cargando = true; // Activa el indicador de carga
      mensajeError = ""; // Limpia mensajes de error previos
    });

    final url =
        '${Api.url}/api/v1/informacion/obtener/$id_bebe'; // Cambia la URL según tu endpoint

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['msg'] != null && data['msg'] is List) {
          setState(() {
            interpretadores = data['msg'];
            cargando = false; // Desactiva el indicador de carga
          });
        } else {
          setState(() {
            mensajeError = "No se encontraron datos para este bebé.";
            interpretadores = [];
            cargando = false;
          });
        }
      } else {
        setState(() {
          mensajeError =
              "Error ${response.statusCode}: No se pudo cargar la información.";
          interpretadores = [];
          cargando = false;
        });
      }
    } catch (error) {
      setState(() {
        mensajeError = "Error al realizar la solicitud: $error";
        interpretadores = [];
        cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (cargando) {
      return Center(child: CircularProgressIndicator()); // Indicador de carga
    }

    if (mensajeError.isNotEmpty) {
      return Center(
        child: Text(
          mensajeError,
          style: TextStyle(color: Colors.red, fontSize: 16),
          textAlign: TextAlign.center,
        ),
      );
    }

    return interpretadores.isEmpty
        ? Center(
            child: Text(
              "No hay datos disponibles.",
              style: TextStyle(fontSize: 16),
            ),
          )
        : Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  child: PieChart(
                    PieChartData(
                      sections: _crearSecciones(),
                      sectionsSpace: 2,
                      centerSpaceRadius: 40,
                      borderData: FlBorderData(show: false),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                _crearLeyenda(),
              ],
            ),
          );
  }

  List<PieChartSectionData> _crearSecciones() {
    final total = interpretadores.fold<int>(
        0, (sum, item) => sum + int.parse(item['total_contador']));

    return List.generate(
      interpretadores.length,
      (index) {
        final nombre = interpretadores[index]['nombre_interpretador'];
        final cantidad = int.parse(interpretadores[index]['total_contador']);
        final porcentaje = ((cantidad / total) * 100).toStringAsFixed(1);

        return PieChartSectionData(
          value: cantidad.toDouble(),
          color: _colores[index % _colores.length],
          title: '$porcentaje%',
          titleStyle: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          radius: 100,
        );
      },
    );
  }

  Widget _crearLeyenda() {
    return Column(
      children: interpretadores.map((item) {
        final nombre = item['nombre_interpretador'];
        final cantidad = int.parse(item['total_contador']);
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(nombre, style: TextStyle(fontSize: 14)),
              Text('Frecuencia: $cantidad',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            ],
          ),
        );
      }).toList(),
    );
  }

  final List<Color> _colores = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.purple,
  ];
}
