import 'package:flutter/material.dart';
import 'google_gemini_service.dart';

class ChatScreenGemini extends StatefulWidget {
  @override
  _ChatScreenGeminiState createState() => _ChatScreenGeminiState();
}

class _ChatScreenGeminiState extends State<ChatScreenGemini> {
  final GoogleGeminiService _geminiService = GoogleGeminiService();
  final TextEditingController _messageController = TextEditingController();
  String _response = '';

  void _enviarMensaje() async {
    final mensaje = _messageController.text.trim();
    if (mensaje.isEmpty) return;

    setState(() {
      _response = 'Consultando...';
    });

    final respuesta = await _geminiService.consultarGemini(mensaje);

    setState(() {
      _response = respuesta;
    });

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat con Gemini'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  _response,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      labelText: 'Escribe tu mensaje',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _enviarMensaje,
                  child: Text('Enviar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void main() => runApp(MaterialApp(home: ChatScreenGemini()));
