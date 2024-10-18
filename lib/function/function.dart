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

String capitalizarPrimeraLetra(String texto) {
  if (texto.isEmpty) {
    return texto; // Si el texto está vacío, lo devuelve tal cual
  }
  return texto[0].toUpperCase() + texto.substring(1);
}
