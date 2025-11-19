import 'package:flutter/material.dart';

final styleColorPink = TextStyle(
  fontSize: 17, // Tamaño de la fuente
  fontWeight: FontWeight.bold, // Peso de la fuente (negrita)
  //fontStyle: FontStyle., // Fuente en cursiva
  color: Colors.pink[200], // Color del texto
  letterSpacing: 1.0, // Espaciado entre letras
  fontFamily: 'Roboto', // Familia de la fuente, puedes usar la que prefieras
);
final styleColorPinkTitulo = TextStyle(
  fontSize: 30, // Tamaño de la fuente
  fontWeight: FontWeight.bold, // Peso de la fuente (negrita)
  //fontStyle: FontStyle., // Fuente en cursiva
  color: Colors.pink[200], // Color del texto
  letterSpacing: 1.0, // Espaciado entre letras
  fontFamily: 'Roboto', // Familia de la fuente, puedes usar la que prefieras
);
final styleColorBlackAppBarTitulo = TextStyle(
  fontSize: 20, // Tamaño de la fuente
  fontWeight: FontWeight.bold, // Peso de la fuente (negrita)
  //fontStyle: FontStyle., // Fuente en cursiva
  color: Colors.black, // Color del texto
  letterSpacing: 1.0, // Espaciado entre letras
  fontFamily: 'Roboto', // Familia de la fuente, puedes usar la que prefieras
);
final styleColorBlack = TextStyle(
  fontSize: 15, // Tamaño de la fuente
  fontWeight: FontWeight.bold, // Peso de la fuente (negrita)
  //fontStyle: FontStyle., // Fuente en cursiva
  color: Colors.black, // Color del texto
  letterSpacing: 1.0, // Espaciado entre letras
  fontFamily: 'Roboto', // Familia de la fuente, puedes usar la que prefieras
);
final styleColorBlue = TextStyle(
  fontSize: 15, // Tamaño de la fuente
  fontWeight: FontWeight.bold, // Peso de la fuente (negrita)
  //fontStyle: FontStyle., // Fuente en cursiva
  color: Colors.blue[900], // Color del texto
  letterSpacing: 1.0, // Espaciado entre letras
  fontFamily: 'Roboto', // Familia de la fuente, puedes usar la que prefieras
);
final styleColorWhite = TextStyle(
  fontSize: 15, // Tamaño de la fuente
  fontWeight: FontWeight.bold, // Peso de la fuente (negrita)
  //fontStyle: FontStyle., // Fuente en cursiva
  color: Colors.white, // Color del texto
  letterSpacing: 1.0, // Espaciado entre letras
  fontFamily: 'Roboto', // Familia de la fuente, puedes usar la que prefieras
);
final styleColorRed = TextStyle(
  fontSize: 15, // Tamaño de la fuente
  fontWeight: FontWeight.bold, // Peso de la fuente (negrita)
  //fontStyle: FontStyle., // Fuente en cursiva
  color: Colors.red, // Color del texto
  letterSpacing: 1.0, // Espaciado entre letras
  fontFamily: 'Roboto', // Familia de la fuente, puedes usar la que prefieras
);
final styleColorBlackTitulo = TextStyle(
  fontSize: 40, // Tamaño de la fuente
  fontWeight: FontWeight.bold, // Peso de la fuente (negrita)
  //fontStyle: FontStyle., // Fuente en cursiva
  color: Colors.black, // Color del texto
  letterSpacing: 1.0, // Espaciado entre letras
  fontFamily: 'Roboto', // Familia de la fuente, puedes usar la que prefieras
);

final fondoApp = BoxDecoration(
  image: DecorationImage(
    // image: AssetImage("assets/background.jpg"), fit: BoxFit.fill),
    image: AssetImage("images/image.png"),
    fit: BoxFit.cover,
  ),
);
final boxShadow = BoxShadow(
  color: Colors.black.withOpacity(0.5),
  offset: const Offset(0, 3),
  blurRadius: 6,
);
final styleColorBlackBotones = TextStyle(
  fontSize: 25, // Tamaño de la fuente
  fontWeight: FontWeight.bold, // Peso de la fuente (negrita)
  //fontStyle: FontStyle., // Fuente en cursiva
  color: Colors.black, // Color del texto
  letterSpacing: 1.0, // Espaciado entre letras
  fontFamily: 'Roboto', // Familia de la fuente, puedes usar la que prefieras
);
