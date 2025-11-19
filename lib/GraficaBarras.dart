import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class GraficaBarras extends StatelessWidget {
  final List<double> datos;

  GraficaBarras({required this.datos});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: datos.reduce((a, b) => a > b ? a : b) +
              5, // Ajusta según el dato más alto
          barGroups: _crearBarras(),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 5, // Intervalo entre los títulos
                getTitlesWidget: (double value, TitleMeta meta) {
                  return Text(
                    value.toInt().toString(), // Texto en el eje Y
                    style: TextStyle(fontSize: 12),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (double value, TitleMeta meta) {
                  // Etiquetas para el eje X
                  return Text(
                    'D${value.toInt() + 1}', // Etiquetas personalizadas
                    style: TextStyle(fontSize: 12),
                  );
                },
              ),
            ),
            topTitles: AxisTitles(
              sideTitles:
                  SideTitles(showTitles: false), // Ocultar títulos superiores
            ),
            rightTitles: AxisTitles(
              sideTitles:
                  SideTitles(showTitles: false), // Ocultar títulos derechos
            ),
          ),

          borderData: FlBorderData(show: false),
          barTouchData: BarTouchData(enabled: true),
        ),
      ),
    );
  }

  List<BarChartGroupData> _crearBarras() {
    return List.generate(
      datos.length,
      (index) => BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: datos[index], // Reemplaza `y` con `toY`
            color: Colors.blue, // Cambia `colors` por `color`
            width: 15, // Opcional: Ajusta el ancho de las barras
          ),
        ],
      ),
    );
  }
}
