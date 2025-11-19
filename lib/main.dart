import 'package:app/Aportes/pruebas.dart';
import 'package:app/callbackDispatcher.dart';
import 'package:app/function/function.dart';

import 'package:app/login.dart';

import 'package:app/notifications_service.dart';
import 'package:app/registro_bebe.dart';

import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';
//import 'package:timezone/data/latest.dart' as tz;

// Define un GlobalKey para el Navigator
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa las notificaciones PRIMERO
  await initNotifications();

  // Inicializa Workmanager con UN SOLO callback dispatcher
  // Este callback manejará TODAS las tareas
  await Workmanager().initialize(
    callbackDispatcherUnificado, // Un solo dispatcher unificado
    isInDebugMode: true, // true para ver logs durante desarrollo
  );

  // Registrar todas las tareas periódicas
  await Workmanager().registerPeriodicTask(
    "vacunas_mismo_dia",
    "mismo_dia",
    frequency: const Duration(hours: 24), // Mínimo 15 min en Android
    initialDelay: const Duration(minutes:60),
    existingWorkPolicy: ExistingWorkPolicy.replace,
    constraints: Constraints(
      networkType: NetworkType.connected,
    ),
  );

  await Workmanager().registerPeriodicTask(
    "vacunas_semana_antes",
    "Una_semana_antes",
    frequency: const Duration(hours: 24),
    initialDelay: const Duration(minutes: 60),
    existingWorkPolicy: ExistingWorkPolicy.replace,
    constraints: Constraints(
      networkType: NetworkType.connected,
    ),
  );

  await Workmanager().registerPeriodicTask(
    "vacunas_pasadas",
    "Pasado_por_dias",
    frequency: const Duration(minutes: 15),
    initialDelay: const Duration(minutes: 60),
    existingWorkPolicy: ExistingWorkPolicy.replace,
    constraints: Constraints(
      networkType: NetworkType.connected,
    ),
  );

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
      // home: Pruebas(),
      home: const Login(),
      //   home: ChatScreen(),
    );
  }
}
