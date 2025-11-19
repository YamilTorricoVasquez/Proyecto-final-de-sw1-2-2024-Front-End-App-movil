// workmanager_callbacks.dart
import 'dart:convert';
import 'package:app/api/ApiConst.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// ==================== NOTIFICACIONES EN BACKGROUND ====================
// Crear una instancia SEPARADA para el background
final FlutterLocalNotificationsPlugin backgroundNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initBackgroundNotifications() async {
  print("🔔 Inicializando notificaciones en background...");
  
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await backgroundNotificationsPlugin.initialize(initializationSettings);
  print("✅ Notificaciones en background inicializadas");
}

Future<void> mostrarNotificacionBackground(String title, String body, int id) async {
  print("📢 Intentando mostrar notificación: $title");
  
  const AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
    'vacunas_channel_id',
    'Vacunas',
    channelDescription: 'Recordatorio de Vacunas',
    importance: Importance.max,
    priority: Priority.high,
    showWhen: true,
    enableVibration: true,
    playSound: true,
    icon: '@mipmap/ic_launcher', // Asegúrate de tener este ícono
  );

  const NotificationDetails notificationDetails = NotificationDetails(
    android: androidNotificationDetails,
  );

  try {
    await backgroundNotificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
    );
    print("✅ Notificación mostrada con ID: $id");
  } catch (e) {
    print("❌ Error mostrando notificación: $e");
  }
}

// ==================== STORAGE ====================
class BabyIdsStorage {
  static Future<void> saveBabyIds(List<int> babyIds) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
        'baby_ids', babyIds.map((id) => id.toString()).toList());
  }

  static Future<List<int>> getBabyIds() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? ids = prefs.getStringList('baby_ids');
    return ids?.map((id) => int.parse(id)).toList() ?? [];
  }
}

void addBabyId(int idBebe) async {
  final babyIds = await BabyIdsStorage.getBabyIds();
  print("Baby IDs actuales: $babyIds");

  if (!babyIds.contains(idBebe)) {
    babyIds.add(idBebe);
    await BabyIdsStorage.saveBabyIds(babyIds);
    print("ID $idBebe guardado.");
  } else {
    print("ID $idBebe ya existe.");
  }
}

int generateUniqueNotificationId(int idBebe) {
  final DateTime now = DateTime.now();
  // Asegúrate de que el ID no sea demasiado grande
  final int uniqueId = (idBebe * 1000 + now.millisecondsSinceEpoch % 1000).abs();
  return uniqueId;
}

// ==================== CALLBACK DISPATCHER UNIFICADO ====================
@pragma('vm:entry-point')
void callbackDispatcherUnificado() {
  Workmanager().executeTask((task, inputData) async {
    print("🔔 Ejecutando tarea: $task");

    try {
      // CRÍTICO: Inicializar notificaciones EN EL BACKGROUND
      await initBackgroundNotifications();

      // Obtener los IDs de los bebés
      final List<int> babyIds = await BabyIdsStorage.getBabyIds();
      if (babyIds.isEmpty) {
        print("⚠️ No hay bebés registrados.");
        return Future.value(true);
      }

      print("👶 Bebés registrados: $babyIds");

      // Ejecutar la lógica según la tarea
      switch (task) {
        case "mismo_dia":
          await procesarVacunasMismoDia(babyIds);
          break;
        case "Una_semana_antes":
          await procesarVacunasUnaSemana(babyIds);
          break;
        case "Pasado_por_dias":
          await procesarVacunasPasadas(babyIds);
          break;
        default:
          print("⚠️ Tarea desconocida: $task");
      }

      print("✅ Tarea $task completada exitosamente");
      return Future.value(true);
    } catch (e) {
      print("❌ Error en tarea $task: $e");
      return Future.value(false);
    }
  });
}

// ==================== FUNCIONES DE PROCESAMIENTO ====================

Future<void> procesarVacunasMismoDia(List<int> babyIds) async {
  print("📅 Procesando vacunas del mismo día...");

  for (int idBebe in babyIds) {
    try {
      final nombreBebe = await obtenerNombreBebe(idBebe);
      final vacunas = await obtenerVacunasBebe(idBebe);

      if (vacunas.isEmpty) {
        print("ℹ️ No hay vacunas para bebé $idBebe");
        continue;
      }

      final DateTime fechaHoy = DateTime.now();

      for (final vacuna in vacunas) {
        final String nombreVacuna =
            vacuna['nombre_vacuna'] ?? 'Vacuna no especificada';
        final String fechaVacunaStr = vacuna['fecha_programada'] ?? '';
        final bool aplicada = vacuna['aplicada'] == true || 
                             vacuna['aplicada'] == 1 ||
                             vacuna['aplicada'] == 'true';

        if (!aplicada && fechaVacunaStr.isNotEmpty) {
          final DateTime fechaVacuna = DateTime.parse(fechaVacunaStr);
          final Duration diferencia = fechaVacuna.difference(fechaHoy);

          if (diferencia.inDays == 0) {
            print("🩺 Notificación: Vacuna HOY para $nombreBebe - $nombreVacuna");
            await mostrarNotificacionBackground(
              "🩺 Vacunación HOY",
              "Hoy es la fecha de vacunación para $nombreBebe. Vacuna: $nombreVacuna.",
              generateUniqueNotificationId(idBebe),
            );
          }
        }
      }
    } catch (e) {
      print("❌ Error procesando bebé $idBebe (mismo día): $e");
    }
  }
}

Future<void> procesarVacunasUnaSemana(List<int> babyIds) async {
  print("📅 Procesando vacunas una semana antes...");

  for (int idBebe in babyIds) {
    try {
      final nombreBebe = await obtenerNombreBebe(idBebe);
      final vacunas = await obtenerVacunasBebe(idBebe);

      if (vacunas.isEmpty) {
        print("ℹ️ No hay vacunas para bebé $idBebe");
        continue;
      }

      final DateTime fechaHoy = DateTime.now();

      for (final vacuna in vacunas) {
        final String nombreVacuna =
            vacuna['nombre_vacuna'] ?? 'Vacuna no especificada';
        final String fechaVacunaStr = vacuna['fecha_programada'] ?? '';
        final bool aplicada = vacuna['aplicada'] == true || 
                             vacuna['aplicada'] == 1 ||
                             vacuna['aplicada'] == 'true';

        if (!aplicada && fechaVacunaStr.isNotEmpty) {
          final DateTime fechaVacuna = DateTime.parse(fechaVacunaStr);
          final String fechaFormateada =
              DateFormat('dd/MM/yyyy').format(fechaVacuna);
          final Duration diferencia = fechaVacuna.difference(fechaHoy);

          if (diferencia.inDays >= 1 && diferencia.inDays <= 7) {
            final String mensaje = diferencia.inDays == 1
                ? "Mañana es la fecha de vacunación para $nombreBebe. Vacuna: $nombreVacuna."
                : "Faltan ${diferencia.inDays} días para la vacuna de $nombreBebe: $nombreVacuna el $fechaFormateada.";

            print("🩺 Notificación: ${diferencia.inDays} días para $nombreBebe");
            await mostrarNotificacionBackground(
              "🩺 Recordatorio de vacunación",
              mensaje,
              generateUniqueNotificationId(idBebe),
            );
          }
        }
      }
    } catch (e) {
      print("❌ Error procesando bebé $idBebe (una semana): $e");
    }
  }
}

Future<void> procesarVacunasPasadas(List<int> babyIds) async {
  print("📅 Procesando vacunas pasadas...");

  for (int idBebe in babyIds) {
    try {
      final nombreBebe = await obtenerNombreBebe(idBebe);
      final vacunas = await obtenerVacunasBebe(idBebe);

      if (vacunas.isEmpty) {
        print("ℹ️ No hay vacunas para bebé $idBebe");
        continue;
      }

      final DateTime fechaHoy = DateTime.now();

      for (final vacuna in vacunas) {
        final String nombreVacuna =
            vacuna['nombre_vacuna'] ?? 'Vacuna no especificada';
        final String fechaVacunaStr = vacuna['fecha_programada'] ?? '';
        final bool aplicada = vacuna['aplicada'] == true || 
                             vacuna['aplicada'] == 1 ||
                             vacuna['aplicada'] == 'true';

        if (!aplicada && fechaVacunaStr.isNotEmpty) {
          final DateTime fechaVacuna = DateTime.parse(fechaVacunaStr);
          final String fechaFormateada =
              DateFormat('dd/MM/yyyy').format(fechaVacuna);
          final Duration diferencia = fechaVacuna.difference(fechaHoy);

          if (diferencia.isNegative) {
            print("⚠️ Notificación: Vacuna PENDIENTE para $nombreBebe - $nombreVacuna");
            await mostrarNotificacionBackground(
              "⚠️ Vacunas pendientes",
              "$nombreBebe tiene la vacuna $nombreVacuna pendiente desde el $fechaFormateada.",
              generateUniqueNotificationId(idBebe),
            );
          }
        }
      }
    } catch (e) {
      print("❌ Error procesando bebé $idBebe (pasadas): $e");
    }
  }
}

// ==================== FUNCIONES AUXILIARES ====================

Future<String> obtenerNombreBebe(int idBebe) async {
  try {
    final urlBebe = '${Api.url}/api/v1/bebe/obtenerBebe/$idBebe';
    final responseBebe =
        await http.get(Uri.parse(urlBebe)).timeout(Duration(seconds: 10));

    if (responseBebe.statusCode == 200) {
      final dataBebe = json.decode(responseBebe.body);
      return dataBebe['msg']?['nombre'] ?? 'Bebé sin nombre';
    }
  } catch (e) {
    print("❌ Error obteniendo nombre del bebé $idBebe: $e");
  }
  return 'Bebé sin nombre';
}

Future<List<dynamic>> obtenerVacunasBebe(int idBebe) async {
  try {
    final urlVacunas =
        '${Api.url}/api/v1/bebe/obtenerEsquemaVacunacion/$idBebe';
    final responseVacunas =
        await http.get(Uri.parse(urlVacunas)).timeout(Duration(seconds: 10));

    if (responseVacunas.statusCode == 200) {
      final dataVacunas = json.decode(responseVacunas.body);
      return dataVacunas['msg'] ?? [];
    } else {
      print("❌ Error en API vacunas para bebé $idBebe: ${responseVacunas.statusCode}");
    }
  } catch (e) {
    print("❌ Error obteniendo vacunas del bebé $idBebe: $e");
  }
  return [];
}