import 'package:app/api/ApiConst.dart';
import 'package:app/function/varGlobales.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';

class ChatComunitario extends StatefulWidget {
  @override
  _ChatComunitarioState createState() => _ChatComunitarioState();
}

class _ChatComunitarioState extends State<ChatComunitario> {
  List<dynamic> mensajes = [];
  final TextEditingController _mensajeController = TextEditingController();
  final String ciUsuario = "8240476"; // Reemplaza con el CI del usuario actual

  @override
  void initState() {
    super.initState();
    _cargarMensajes(); // Cargar mensajes al inicializar
  }

  Future<void> _cargarMensajes() async {
    final url = Uri.parse('${Api.url}/api/v1/chat/obtener');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        setState(() {
          mensajes = data['msg']; // Actualiza la lista de mensajes
        });
      } else {
        print('Error al cargar mensajes: ${response.statusCode}');
      }
    } catch (error) {
      print('Error al cargar mensajes: $error');
    }
  }

  Future<void> _enviarMensaje(String descripcion) async {
    final url = Uri.parse('${Api.url}/api/v1/chat/registrar');
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({
      'descripcion': descripcion,
      'fecha': DateTime.now().toIso8601String(),
      'ci_usuario': Globals.ci,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['ok']) {
          _mensajeController.clear(); // Limpia el campo de texto
          _cargarMensajes(); // Recarga los mensajes
        } else {
          print('Error al enviar mensaje: ${data['msg']}');
        }
      } else {
        print('Error al enviar mensaje: ${response.statusCode}');
      }
    } catch (error) {
      print('Error al enviar mensaje: $error');
    }
  }

  String _formatearFecha(String fecha) {
    try {
      final DateTime fechaHora = DateTime.parse(fecha);
      return DateFormat('dd/MM/yyyy').format(fechaHora);
    } catch (e) {
      return fecha; // Si hay error, muestra la fecha original
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: mensajes.isEmpty
              ? Center(
                  child:
                      CircularProgressIndicator(), // Indicador mientras carga
                )
              : ListView.builder(
                  itemCount: mensajes.length,
                  itemBuilder: (context, index) {
                    // Usamos mensajes.reversed para que los más recientes estén al inicio
                    final mensaje = mensajes.reversed.toList()[index];
                    final esMiMensaje = mensaje['ci_usuario'] == ciUsuario;
                    return _buildMensaje(mensaje, esMiMensaje);
                  },
                ),
        ),
        _buildInputBar(),
      ],
    );
  }

  Widget _buildMensaje(Map<String, dynamic> mensaje, bool esMiMensaje) {
    return Align(
      alignment: esMiMensaje ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: esMiMensaje ? Colors.blueAccent : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomLeft: esMiMensaje ? Radius.circular(10) : Radius.circular(0),
            bottomRight: esMiMensaje ? Radius.circular(0) : Radius.circular(10),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment:
              esMiMensaje ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              mensaje['nombre'],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: esMiMensaje ? Colors.white : Colors.black87,
              ),
            ),
            SizedBox(height: 5),
            Text(
              mensaje['descripcion'],
              style: TextStyle(
                color: esMiMensaje ? Colors.white : Colors.black87,
                fontSize: 14,
              ),
            ),
            SizedBox(height: 5),
            Text(
              _formatearFecha(mensaje['fecha']),
              style: TextStyle(
                fontSize: 10,
                color: esMiMensaje ? Colors.white70 : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _mensajeController,
              decoration: InputDecoration(
                hintText: 'Escribe un mensaje...',
                contentPadding: EdgeInsets.symmetric(horizontal: 15),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ),
          SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              if (_mensajeController.text.isNotEmpty) {
                _enviarMensaje(_mensajeController.text);
              }
            },
            child: CircleAvatar(
              backgroundColor: Colors.blueAccent,
              child: Icon(Icons.send, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
