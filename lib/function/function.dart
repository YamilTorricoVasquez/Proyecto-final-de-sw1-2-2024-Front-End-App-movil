String invertirFecha(String fecha) {
  final texto = fecha; // Ejemplo de entrada
  var textoInvertido = "";

// Verificar si el formato ya es 'aaaa/mm/dd'
  if (texto.contains('/') && texto.split('/')[0].length == 4) {
    textoInvertido = texto; // No hacer nada, ya está en el formato correcto
  } else {
    // Dividir la fecha en partes: día, mes y año
    var partes = texto.split('/');

    // Reorganizar las partes en el orden deseado (año/mes/día)
    textoInvertido = '${partes[2]}/${partes[1]}/${partes[0]}';
  }
  return textoInvertido;
}

String invertirFecha2(String fecha) {
  final texto = fecha; // Ejemplo de entrada
  var textoInvertido = "";

  // Verificar si el formato ya es 'aaaa-mm-dd'
  if (texto.contains('-') && texto.split('-')[0].length == 4) {
    textoInvertido = texto; // No hacer nada, ya está en el formato correcto
  } else {
    // Dividir la fecha en partes: día, mes y año
    var partes = texto.split('/');

    // Comprobar que hay exactamente tres partes
    if (partes.length == 3) {
      // Reorganizar las partes en el orden deseado (año-mes-día)
      textoInvertido = '${partes[2]}-${partes[1]}-${partes[0]}';
    } else {
      // Manejar el caso de un formato inesperado
      throw FormatException(
          'Formato de fecha incorrecto. Debe ser "dd/mm/aaaa".');
    }
  }
  return textoInvertido;
}

String capitalizarPrimeraLetra(String texto) {
  if (texto.isEmpty) {
    return texto; // Si el texto está vacío, lo devuelve tal cual
  }
  return texto[0].toUpperCase() + texto.substring(1);
}

String quitarDecimales(String numeroStr) {
  // Convertimos el String a double
  double numero = double.tryParse(numeroStr) ?? 0.0;

  // Si el número es entero, lo convertimos a int para quitar los decimales
  if (numero % 1 == 0) {
    return numero.toInt().toString();
  } else {
    return numero.toString(); // Si tiene decimales, lo dejamos como está
  }
}

String convertirHora(String hora24) {
  // Dividimos el String para obtener horas, minutos y segundos
  List<String> partes = hora24.split(":");
  int hora = int.parse(partes[0]);
  String minutos = partes[1];
  String periodo = hora >= 12 ? "PM" : "AM";

  // Convertimos la hora de 24 horas a 12 horas
  hora = hora % 12;
  if (hora == 0) hora = 12; // Ajuste para mostrar 12 en lugar de 0

  return "$hora:$minutos $periodo";
}
