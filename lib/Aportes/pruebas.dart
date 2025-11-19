import 'package:app/callbackDispatcher.dart';
import 'package:flutter/material.dart';

class Pruebas extends StatefulWidget {
  const Pruebas({super.key});

  @override
  State<Pruebas> createState() => _PruebasState();
}

class _PruebasState extends State<Pruebas> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ElevatedButton(
              onPressed: () {
               // print(BabyIdsStorage.getBabyIds);
              },
              child: Center(child: Text("data")))
        ],
      ),
    );
  }
}
