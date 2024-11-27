import 'dart:convert';
import 'package:http/http.dart' as http;

class OpenAIService {
  final String _apiKey = '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'; // Sustituye con tu clave de API
  final String _baseUrl = 'https://api.openai.com/v1/chat/completions';

  Future<String> consultarGPT3Turbo(String mensaje) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          "model": "gpt-3.5-turbo", // Modelo a usar
          "messages": [
            {"role": "user", "content": mensaje} // Mensaje enviado al modelo
          ]
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData['choices'][0]['message']['content'];
      } else {
        print('Error en la respuesta: ${response.statusCode}');
        print(response.body);
        return 'Ocurrió un error al procesar tu solicitud.';
      }
    } catch (e) {
      print('Error al consultar la API: $e');
      return 'Ocurrió un error al consultar la API.';
    }
  }
}
