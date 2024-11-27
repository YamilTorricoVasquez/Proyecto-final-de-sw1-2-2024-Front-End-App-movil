import 'package:app/callbackDispatcher.dart';

import 'package:app/login.dart';

import 'package:app/notifications_service.dart';

import 'package:flutter/material.dart';
//import 'package:timezone/data/latest.dart' as tz;

import 'package:workmanager/workmanager.dart';

// Define un GlobalKey para el Navigator
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa Workmanager
  Workmanager().initialize(
    callbackDispatcher, // La función definida en tu archivo
    isInDebugMode: false, // Cambiar a true para depuración
  );

  // Programa la tarea periódica
  Workmanager().registerPeriodicTask(
    "uniqueTaskId", // ID único para la tarea
    "mostrar_notificacion_desde_api", // Nombre del trabajo
    frequency: Duration(minutes: 15), // Frecuencia de la tarea
    initialDelay:
        Duration(seconds: 5), // Opcional: Tiempo antes de la primera ejecución
  );
  // Inicializa las notificaciones
  await initNotifications();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      // home: Monitoreo(),
      home: const Login(),
      //   home: ChatScreen(),
    );
  }
}
