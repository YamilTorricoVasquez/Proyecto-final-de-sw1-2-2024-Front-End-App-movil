import 'dart:convert';

import 'package:app/api/ApiConst.dart';
import 'package:app/function/varGlobales.dart';

import 'package:http/http.dart' as http;

import 'package:workmanager/workmanager.dart';
import 'notifications_service.dart';


void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task == "mostrar_notificacion_desde_api") {
      await initNotifications();

      if (Globals.ci == '' || Globals.ci.isEmpty) {
        print("El CI del usuario no está definido.${Globals.ci}");
        return Future.value(true);
      }

      final List<int> babyIds = await BabyIdsStorage.getBabyIds();
      print("IDs de bebés registrados para el usuario ${Globals.ci}: $babyIds");

      if (babyIds.isNotEmpty) {
        for (int idBebe in babyIds) {
          try {
            final urlVacunas =
                '${Api.url}/api/v1/bebe/obtenerEsquemaVacunacion/$idBebe';
            final urlNombre = '${Api.url}/api/v1/bebe/obtenerBebe/$idBebe';

            final responseVacunas = await http
                .get(Uri.parse(urlVacunas))
                .timeout(Duration(seconds: 10));
            final responseNombre = await http
                .get(Uri.parse(urlNombre))
                .timeout(Duration(seconds: 10));

            if (responseVacunas.statusCode == 200 &&
                responseNombre.statusCode == 200) {
              final dataVacunas = json.decode(responseVacunas.body);
              final dataNombre = json.decode(responseNombre.body);

              final List<dynamic> vacunas = dataVacunas['msg'] ?? [];
              final String nombreBebe =
                  dataNombre['msg']?['nombre'] ?? 'Bebé sin nombre';

              if (vacunas.isNotEmpty) {
                // Ejemplo: Notificación sobre vacunas
                final String vacunaProxima =
                    vacunas.first['vacuna'] ?? 'Vacuna no especificada';

                mostrarNotificacion(
                    "Recordatorio de vacunación",
                    "La próxima vacuna para $nombreBebe es: $vacunaProxima",
                    generateUniqueNotificationId(idBebe));
              }
            } else {
              print(
                  "Error en la API para el bebé con ID $idBebe: ${responseVacunas.statusCode} o ${responseNombre.statusCode}");
            }
          } catch (e) {
            print("Error al procesar el bebé con ID $idBebe: $e");
          }
        }
      } else {
        print("No hay bebés registrados para el usuario ${Globals.ci}.");
      }
    }

    return Future.value(true);
  });
}

class BabyIdsStorage {
  static Future<List<int>> getBabyIds() async {
    final url = '${Api.url}/api/v1/bebe/obtener/${Globals.ci}';
    try {
      final response = await http
          .get(Uri.parse(url))
          .timeout(Duration(seconds: 10)); // Timeout agregado
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<int> ids =
            List<int>.from(data['msg'].map((bebe) => bebe['id']));
        return ids;
      } else {
        print("Error al obtener bebés: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Error en la solicitud de bebés: $e");
      return [];
    }
  }
}

int generateUniqueNotificationId(int idBebe) {
  final DateTime now = DateTime.now();

  // Combina el ID del bebé con la fecha/hora actual para garantizar unicidad
  final int uniqueId = int.parse(
    '${idBebe}${now.millisecondsSinceEpoch % 100000}',
  );

  return uniqueId;
}
