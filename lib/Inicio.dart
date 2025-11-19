import 'package:app/Aportes/chatScreen.dart';
import 'package:app/SharedPreferences.dart';
import 'package:app/api/ApiConst.dart';
import 'package:app/camara.dart';
import 'package:app/chat_screen.dart';
import 'package:app/editar_datos_padre.dart';
import 'package:app/function/widget.dart';
import 'package:app/interpretador.dart';
import 'package:app/lista_bebe.dart';
import 'package:app/login.dart';
import 'package:app/monitoreo.dart';
import 'package:app/perfil_bebe.dart';
import 'package:app/registro_bebe.dart';
import 'package:app/function/varGlobales.dart';
import 'package:app/webview.dart';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class Inicio extends StatefulWidget {
  const Inicio({super.key});

  @override
  State<Inicio> createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  @override
  void initState() {
    super.initState();
    print(Globals.email);
    obtenerNombreUsuario(Globals.email);
  }

  String _texto = '';
  String _nombreUsuario = '';
  String _ciUsuario = '';
  String _email = '';
  String _password = '';
  Future<void> obtenerNombreUsuario(String email) async {
    final url =
        '${Api.url}/api/v1/users/nombre/$email'; // Cambia 'localhost' si es necesario

    try {
      final response = await http.get(Uri.parse(url));
      print('Aqui es el error?');
      print(email);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          // print(_nombreUsuario);
          _nombreUsuario = data['msg']['nombre']; // Actualiza el estado
          _ciUsuario = data['msg']['ci'];
          _email = data['msg']['email'];
          //  _password = data['msg']['password'];
          Globals.ci = data['msg']['ci'];
          Globals.nombreUsuario = _nombreUsuario;
          addParentCI(data['msg']['ci']);
          /*_widget = ListaBebe(
            ci: _ciUsuario,
          );*/
          // _colors2 = Colors.pink.shade200;
          //  print("contraseña: ${Globals.ci}");
          print("contraseña: ${_password}");
        });
      } else if (response.statusCode == 404) {
        print('Usuario no encontrado');
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error al realizar la solicitud: $error');
    }
  }

  Widget _widget = Text("Bienvenido ");

  late Color _colors = Colors.black;
  late Color _colors1 = Colors.white;
  late Color _colors2 = Colors.white;
  late Color _colors3 = Colors.white;
  late Color _color4 = Colors.white;
  final Uri _url =
      Uri.parse('https://sw1-monitoreo.onrender.com/receptor.html');
  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            // image: AssetImage("assets/background.jpg"), fit: BoxFit.fill),
            image: AssetImage("images/image.png"),
            fit: BoxFit.cover,
          ),
          gradient: LinearGradient(
            colors: [Colors.pinkAccent, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Container(
              clipBehavior: Clip.none,
              decoration: BoxDecoration(
                //   borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                boxShadow: [boxShadow],
              ),
              height: 140,
              width: 390,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  children: [
                    /*Positioned(
                      left: 10,
                      top: 55,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Bienvenido,",
                                style: styleColorRed,
                              ),
                              Text(
                                _nombreUsuario,
                                style: styleColorBlack,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),*/
                    Center(
                      child: Text(
                        'Bienvenido, ${_nombreUsuario}',
                        style: styleColorBlack,
                      ),
                    ),
                    Positioned(
                      top: 80,
                      left: -2,
                      child: IconButton(
                        onPressed: () {
                          _colors = Colors.blue.shade900;
                          _colors1 = Colors.white;
                          _colors2 = Colors.white;
                          _colors3 = Colors.white;
                          _color4 = Colors.white;
                          setState(() {
                            _texto = 'Editar datos personales';
                            _widget = EditarDatosPadre(
                              ci: _ciUsuario,
                              email: _email,
                              nombre: _nombreUsuario,
                              onUpdate: () {
                                obtenerNombreUsuario(Globals
                                    .emailAux); // Actualizar los datos en la pantalla principal
                              },
                            );
                          });
                        },
                        icon: Column(
                          children: [
                            Icon(
                              Icons.edit,
                              color: _colors,
                            ),
                            // TituloBotones(
                            //     nombre: 'Editar', colors: Colors.black)
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 80,
                      left: 330,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Login(),
                              ));
                        },
                        child: Container(
                          child: Column(
                            children: [
                              Center(
                                  child: Icon(Icons.logout_outlined, size: 40)),
                              // TituloBotones(
                              //     nombre: 'Cerrar Sesion', colors: Colors.black)
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Text(
              _texto,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: Colors.black,
              ),
            ),
            Expanded(
              flex: 5,
              child: _widget,
            ),
            Container(
              decoration: BoxDecoration(
                  //  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  boxShadow: [boxShadow]),
              height: 80,
              // color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            _colors = Colors.black;
                            _colors1 = Colors.black54;
                            _colors2 = Colors.white;
                            _colors3 = Colors.white;
                            _color4 = Colors.white;
                            _texto = 'Registro bebe';
                            setState(() {
                              _widget = const RegistroBebe();
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: _colors1,
                                boxShadow: [boxShadow]),
                            child: ImagenIcon(url: 'images/registrobebe.png'),
                          ),
                        ),
                        TituloBotones(
                            nombre: 'Registrar', colors: Colors.black),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            _colors = Colors.black;
                            _colors1 = Colors.white;
                            _colors2 = Colors.black54;
                            _colors3 = Colors.white;
                            _color4 = Colors.white;
                            _texto = 'Lista de bebes';
                            setState(() {
                              _widget = ListaBebe(
                                ci: _ciUsuario,
                              );
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: _colors2,
                                boxShadow: [boxShadow]),
                            child: ImagenIcon(url: 'images/listaBebes.png'),
                          ),
                        ),
                        TituloBotones(nombre: 'Listar', colors: Colors.black),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            _colors = Colors.black;
                            _colors1 = Colors.white;
                            _colors2 = Colors.white;
                            _colors3 = Colors.black54;
                            _color4 = Colors.white;
                            _texto = 'Chat comunitario';
                            setState(() {
                              _widget = ChatComunitario();
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: _colors3,
                                boxShadow: [boxShadow]),
                            child: ImagenIcon(url: 'images/chat.png'),
                          ),
                        ),
                        TituloBotones(nombre: 'Chat', colors: Colors.black),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            _colors = Colors.black;
                            _colors1 = Colors.white;
                            _colors2 = Colors.white;
                            _colors3 = Colors.white;
                            _color4 = Colors.black54;
                            setState(() {
                              _widget = HomePage();
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: _color4,
                                boxShadow: [boxShadow]),
                            child: ImagenIcon(url: 'images/monitorBebe.png'),
                          ),
                        ),
                        TituloBotones(
                            nombre: 'Monitoreo', colors: Colors.black),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
/*  appBar: AppBar(
        backgroundColor: Colors.pink[200],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.pink[200],
              ),
              // child: Text("FOTO"),

              child: InkWell(
                child: Stack(
                  children: [
                    Positioned(
                      left: -13,
                      child: Image.asset(
                        'images/logoBaby.png',
                        width: 140,
                      ),
                    ),
                    Positioned(
                      left: 100,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _nombreUsuario,
                            style: styleColorBlack,
                          ),
                          Text(
                            _ciUsuario,
                            style: styleColorBlack,
                          ),
                          Text(
                            _email,
                            style: styleColorBlack,
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: -4,
                      left: 220,
                      child: IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditarDatosPadre(
                                ci: _ciUsuario,
                                email: _email,
                                nombre: _nombreUsuario,
                              ),
                            ),
                          ).then((result) {
                            if (result == true) {
                              // Recargar datos o ejecutar las funciones que necesitas
                              setState(() {
                                // Aquí puedes llamar las funciones o métodos que recargan la página
                                obtenerNombreUsuario(Globals.emailAux);
                              });
                            }
                          });
                        },
                        icon: Icon(Icons.mode_edit_outlined),
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  setState(() {
                    _widget = Text("Bienvenido ${Globals.nombreUsuario}");
                    //_widget = widget.prueba;
                  });
                },
              ),
            ),
            ListTile(
              title: Text(
                "REGISTRAR BEBE",
                style: TextStyle(
                  fontSize: 15, // Tamaño de la fuente
                  fontWeight: FontWeight.bold, // Peso de la fuente (negrita)
                  //fontStyle: FontStyle., // Fuente en cursiva
                  color: _colors1, // Color del texto
                  letterSpacing: 4.0, // Espaciado entre letras
                  fontFamily:
                      'Roboto', // Familia de la fuente, puedes usar la que prefieras
                ),
              ),
              onTap: () {
                setState(
                  () {
                    _colors = Colors.black;
                    _colors1 = Colors.pink.shade200;
                    _colors2 = Colors.black;
                    _colors3 = Colors.black;
                    _widget = const RegistroBebe();
                    //_widget = Text(Globals.ci);
                  },
                );
              },
            ),
            ListTile(
              title: Text(
                "LISTA BEBE",
                style: TextStyle(
                  fontSize: 15, // Tamaño de la fuente
                  fontWeight: FontWeight.bold, // Peso de la fuente (negrita)
                  //fontStyle: FontStyle., // Fuente en cursiva
                  color: _colors2, // Color del texto
                  letterSpacing: 4.0, // Espaciado entre letras
                  fontFamily:
                      'Roboto', // Familia de la fuente, puedes usar la que prefieras
                ),
              ),
              // textColor: ,
              onTap: () {
                setState(
                  () {
                    _colors2 = Colors.pink.shade200;
                    _colors = Colors.black;
                    _colors1 = Colors.black;
                    _colors3 = Colors.black;
                    _widget = ListaBebe(
                      ci: _ciUsuario,
                    );
                  },
                );
              },
            ),
            ListTile(
              title: Text(
                "CHAT COMUNITARIO",
                style: TextStyle(
                  fontSize: 15, // Tamaño de la fuente
                  fontWeight: FontWeight.bold, // Peso de la fuente (negrita)
                  //fontStyle: FontStyle., // Fuente en cursiva
                  color: _colors3, // Color del texto
                  letterSpacing: 4.0, // Espaciado entre letras
                  fontFamily:
                      'Roboto', // Familia de la fuente, puedes usar la que prefieras
                ),
              ),
              // textColor: ,
              onTap: () {
                setState(
                  () {
                    _colors2 = Colors.black;
                    _colors = Colors.black;
                    _colors1 = Colors.black;
                    _colors3 = Colors.pink.shade200;
                    _widget = ChatComunitario();
                  },
                );
              },
            ),
            ListTile(
              title: Text(
                "Monitoreo",
                style: TextStyle(
                  fontSize: 15, // Tamaño de la fuente
                  fontWeight: FontWeight.bold, // Peso de la fuente (negrita)
                  //fontStyle: FontStyle., // Fuente en cursiva
                  color: _colors3, // Color del texto
                  letterSpacing: 4.0, // Espaciado entre letras
                  fontFamily:
                      'Roboto', // Familia de la fuente, puedes usar la que prefieras
                ),
              ),
              // textColor: ,
              onTap: () {
                setState(
                  () {
                   
                    _widget = Webview();
                  },
                );
              },
            ),
            ListTile(
              title: Text(
                "CERRAR SESION",
                style: TextStyle(
                  fontSize: 15, // Tamaño de la fuente
                  fontWeight: FontWeight.bold, // Peso de la fuente (negrita)
                  //fontStyle: FontStyle., // Fuente en cursiva
                  color: Colors.black, // Color del texto
                  letterSpacing: 4.0, // Espaciado entre letras
                  fontFamily:
                      'Roboto', // Familia de la fuente, puedes usar la que prefieras
                ),
              ),
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Login(),
                  ),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
      body: _widget,*/