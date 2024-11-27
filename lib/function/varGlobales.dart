import 'package:app/interpretador.dart';
import 'package:flutter/material.dart';

class Globals {
  static String token = '';
  static String nombreUsuario = '';
  static String email = '';
  static String ci = '';
  static String emailAux = '';
  static int idBebe = 0;
  static String nombre_interpretador = '0';
  static bool bandera = false;
  static Widget pantallaActual = Interpretador();
  static Function? actualizarPantalla; // Función para redibujar
}
