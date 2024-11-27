import 'package:app/Aportes/openai_service.dart';
import 'package:flutter/material.dart';


class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final OpenAIService _openAIService = OpenAIService();
  final TextEditingController _messageController = TextEditingController();
  String _response = '';

  void _enviarMensaje() async {
    final mensaje = _messageController.text.trim();
    if (mensaje.isEmpty) return;

    setState(() {
      _response = 'Consultando...';
    });

    final respuesta = await _openAIService.consultarGPT3Turbo(mensaje);

    setState(() {
      _response = respuesta;
    });

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ChatGPT con Flutter'),
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
