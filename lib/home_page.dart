import 'package:flutter/material.dart';
import 'package:tflite_audio/tflite_audio.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _sound = "Presiona para iniciar";
  bool _recording = false;
  Stream<Map<dynamic, dynamic>>? result;

  @override
  void initState() {
    TfliteAudio.loadModel(
        model: "assets/soundclassifier_with_metadata.tflite",
        label: "assets/labels22.txt",
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
        });
      });
    }
  }

  void _stop() {
    TfliteAudio.stopAudioRecognition();
    setState(() => _recording = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
               // image: AssetImage("assets/background.jpg"), fit: BoxFit.fill),
               image: AssetImage("images/image.png"), fit: BoxFit.fill),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text(
                "Que tiene mi bebe?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 60,
                  fontWeight: FontWeight.w200,
                ),
              ),
              MaterialButton(
                onPressed: _recorder,
                color: _recording ? Colors.green[200] : Colors.pink[200],
                textColor: Colors.white,
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(25),
                child: const Icon(Icons.mic, size: 60),
              ),
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
      ),
    );
  }
}
