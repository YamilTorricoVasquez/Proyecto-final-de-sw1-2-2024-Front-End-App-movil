import 'dart:convert';
import 'package:http/http.dart' as http;

class GoogleGeminiService {
  final String _apiKey = 'AIzaSyDyg2ITsUlttcmtwPRT2_9Ud87FTVrJ1YM'; // Coloca aquí tu clave de API
  final String _baseUrl = 'https://gemini.googleapis.com/v1/chat/completions';

  // Método para consultar la API de Gemini
  Future<String> consultarGemini(String mensaje) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          "model": "gemini-pro", // Modelo de Gemini
          "messages": [
            {"role": "user", "content": mensaje}
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
      return 'Error al conectar con la API.';
    }
  }
}
