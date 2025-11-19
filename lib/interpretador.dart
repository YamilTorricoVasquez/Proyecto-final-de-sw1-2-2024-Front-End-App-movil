import 'package:app/api/ApiConst.dart';
import 'package:app/function/varGlobales.dart';
import 'package:app/function/widget.dart';
import 'package:app/notifications_service.dart';
import 'package:app/recomendaciones.dart';
import 'package:flutter/material.dart';
import 'package:tflite_audio/tflite_audio.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Interpretador extends StatefulWidget {
  const Interpretador({
    super.key,
  });

  @override
  State<Interpretador> createState() => _InterpretadorState();
}

class _InterpretadorState extends State<Interpretador> {
  String _sound = "Presiona para iniciar";
  bool _recording = false;
  Stream<Map<dynamic, dynamic>>? result;

  @override
  void initState() {
    TfliteAudio.loadModel(
        model: "assets/soundclassifier_with_metadata.tflite",
        label: "assets/labels.txt",
        // for Google's Teachable Machine models
        inputType: 'rawAudio',
        //  for decodedWav models use
        //  inputType: 'decodedWav'
        numThreads: 1,
        isAsset: true);
    super.initState();
  }

  void _recorder() {
    String recognition = "";
    if (!_recording) {
      setState(() {
        _recording = true;
      });
      result = TfliteAudio.startAudioRecognition(
        sampleRate: 44100,
        bufferSize: 22016,
        numOfInferences: 5,
        detectionThreshold: 0.3,
      );
      result?.listen((event) {
        recognition = event["recognitionResult"];
      }).onDone(() {
        setState(() {
          _recording = false;
          _sound = recognition.split(" ")[1];
          if (_sound == 'Dolor') {
            Globals.nombre_interpretador = 'Dolor de Vientre';
            _sound = 'Dolor de Vientre';
          } else {
            Globals.nombre_interpretador = _sound;
          }

          DateTime fechaUtc = DateTime.now();
          String soloFecha = fechaUtc.toIso8601String().split('T')[0];
          print(_sound); // Ejemplo de salida: 2024-11-22
          if (Globals.nombre_interpretador == 'Dolor de Vientre' ||
              Globals.nombre_interpretador == 'Eructar' ||
              Globals.nombre_interpretador == 'Fatigado' ||
              Globals.nombre_interpretador == 'Hambriento' ||
              Globals.nombre_interpretador == 'Malestar') {
            registrarDato(
                Globals.nombre_interpretador, soloFecha, Globals.idBebe);
          }

          /*  if (_sound != 'Ruido')
           mostrarNotificacion(
                'Recomendaciones', 'Su bebe tiene ${_sound}', 100000);
          //   Recomendaciones(nombre: Globals.nombre_interpretador);*/
        });
      });
    }
  }

  void _stop() {
    TfliteAudio.stopAudioRecognition();
    setState(() => _recording = false);
  }

  Future<void> registrarDato(
      String nombre_interpretador, String fecha, int id_bebe) async {
    final url = Uri.parse(
        '${Api.url}/api/v1/informacion/registrar'); // Cambia la URL a la de tu API
    final headers = {'Content-Type': 'application/json'};

    final body = json.encode({
      'nombre_interpretador': nombre_interpretador,
      'fecha': fecha,
      'contador': 1,
      'id_bebe': id_bebe,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        

        if (data['ok']) {
          // Manejar respuesta exitosa
          print('Registro exitoso');
          // print('Token: ${data['msg']['token']}');
          setState(() {});
          // Navegar a la siguiente pantalla o realizar acciones necesarias
        } else {
          // Manejar error en el registro
          print('Error en el registro: ${data['msg']}');
        }
      } else {
        print('Error en la solicitud: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

/*DateTime fechaUtc = DateTime.now().toUtc();
String soloFecha = fechaUtc.toIso8601String().split('T')[0];
print(soloFecha); // Ejemplo de salida: 2024-11-22
*/
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        // decoration: fondoApp,
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    "Que tiene mi bebe?",
                    textAlign: TextAlign.center,
                    style: styleColorBlackTitulo,
                  ),
                ],
              ),
            ),
            //  SizedBox(height: 80),
            MaterialButton(
              onPressed: _recorder,
              color: _recording ? Colors.green[200] : Colors.blue[900],
              textColor: Colors.white,
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(25),
              child: const Icon(Icons.mic, size: 60),
            ),
            //       SizedBox(height: 20),
            Text(
              _sound,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
