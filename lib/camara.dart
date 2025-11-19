import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ⚠️ CONFIGURA LA IP DE TU SERVIDOR AQUÍ ⚠️
  final String serverIp = '192.168.0.18';
  final int videoPort = 9999;
  final int alertPort = 8888;

  Socket? videoSocket;
  Socket? alertSocket;

  bool isConnected = false;
  bool isWatchingVideo = false;
  bool motionDetected = false;
  int motionAreas = 0;
  int objectsDetected = 0;
  List<String> detectedObjects = [];
  String lastAlertTime = '';

  Uint8List? currentFrame;
  String videoBuffer = '';
  String alertBuffer = '';

  late FlutterLocalNotificationsPlugin notificationsPlugin;

  @override
  void initState() {
    super.initState();
    initNotifications();
    connectToAlertServer();
  }

  Future<void> initNotifications() async {
    notificationsPlugin = FlutterLocalNotificationsPlugin();

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await notificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        print('Notificación presionada: ${response.payload}');
      },
    );

    // Solicitar permisos Android 13+
    final androidImpl =
        notificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidImpl != null) {
      await androidImpl.requestNotificationsPermission();

      // Crear canal de notificaciones
      const androidChannel = AndroidNotificationChannel(
        'motion_alerts',
        'Alertas de Movimiento',
        description: 'Notificaciones cuando se detecta movimiento',
        importance: Importance.high,
        playSound: true,
        enableVibration: true,
      );

      await androidImpl.createNotificationChannel(androidChannel);
    }

    print('✅ Notificaciones configuradas');
  }

  Future<void> showNotification(String title, String body) async {
    const androidDetails = AndroidNotificationDetails(
      'motion_alerts',
      'Alertas de Movimiento',
      channelDescription: 'Notificaciones de movimiento detectado',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      enableVibration: true,
      playSound: true,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    try {
      await notificationsPlugin.show(
        DateTime.now().millisecondsSinceEpoch % 100000,
        title,
        body,
        details,
      );
      print('📲 Notificación enviada: $title');
    } catch (e) {
      print('❌ Error mostrando notificación: $e');
    }
  }

  Future<void> connectToAlertServer() async {
    try {
      alertSocket = await Socket.connect(serverIp, alertPort);
      print('✅ Conectado al servidor de alertas');

      setState(() {
        isConnected = true;
      });

      // SOLUCIÓN: Escuchar bytes directamente, NO usar transform
      alertSocket!.listen(
        (Uint8List data) {
          // Convertir bytes a string
          try {
            String decoded = utf8.decode(data, allowMalformed: true);
            alertBuffer += decoded;

            // Procesar líneas completas
            final lines = alertBuffer.split('\n');

            for (int i = 0; i < lines.length - 1; i++) {
              final line = lines[i].trim();
              if (line.isEmpty) continue;

              try {
                final alert = jsonDecode(line);
                handleAlert(alert);
              } catch (e) {
                print('Error parsing alert: $e');
              }
            }

            // Guardar última línea incompleta
            alertBuffer = lines.last;
          } catch (e) {
            print('Error decodificando: $e');
          }
        },
        onError: (error) {
          print('Error en servidor de alertas: $error');
          setState(() {
            isConnected = false;
          });
        },
        onDone: () {
          print('Desconectado del servidor de alertas');
          setState(() {
            isConnected = false;
          });
        },
      );
    } catch (e) {
      print('❌ Error conectando al servidor de alertas: $e');
      setState(() {
        isConnected = false;
      });
    }
  }

  void handleAlert(Map<String, dynamic> alert) {
    final type = alert['type'];

    if (type == 'motion_alert') {
      setState(() {
        motionDetected = true;
        motionAreas = alert['motion_areas'] ?? 0;
        objectsDetected = alert['objects_detected'] ?? 0;
        detectedObjects = List<String>.from(alert['detected_objects'] ?? []);
        lastAlertTime = alert['timestamp'] ?? '';
      });

      print('🚨 ALERTA RECIBIDA: $motionAreas áreas, $objectsDetected objetos');

      // Mostrar notificación SIEMPRE (incluso si está viendo video)
      final message = alert['message'] ?? 'Movimiento detectado';
      final objects = detectedObjects.isNotEmpty
          ? 'Objetos: ${detectedObjects.join(", ")}'
          : 'Sin objetos identificados';
      showNotification('⚠️ Alerta de Seguridad', '$message\n$objects');

      // Resetear estado después de 5 segundos
      Future.delayed(const Duration(seconds: 5), () {
        if (mounted) {
          setState(() {
            motionDetected = false;
          });
        }
      });
    }
  }

  Future<void> connectToVideoServer() async {
    if (isWatchingVideo) {
      disconnectFromVideoServer();
      return;
    }

    try {
      videoSocket = await Socket.connect(serverIp, videoPort);
      print('✅ Conectado al servidor de video');

      setState(() {
        isWatchingVideo = true;
      });

      int bytesReceived = 0;
      int framesProcessed = 0;

      // SOLUCIÓN: Escuchar bytes directamente, NO usar transform
      videoSocket!.listen(
        (Uint8List data) {
          bytesReceived += data.length;
          print('📦 Recibidos ${data.length} bytes (Total: $bytesReceived)');

          try {
            String decoded = utf8.decode(data, allowMalformed: true);
            videoBuffer += decoded;

            // Debug: Mostrar longitud del buffer
            print('📝 Buffer size: ${videoBuffer.length}');

            processVideoBuffer();
            framesProcessed++;
            print('🎬 Frames procesados: $framesProcessed');
          } catch (e) {
            print('❌ Error decodificando video: $e');
          }
        },
        onError: (error) {
          print('❌ Error en video: $error');
          disconnectFromVideoServer();
        },
        onDone: () {
          print('⚠️ Video desconectado');
          disconnectFromVideoServer();
        },
      );
    } catch (e) {
      print('❌ Error conectando al video: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error conectando al servidor: $e')),
        );
      }
    }
  }

  void processVideoBuffer() {
    final lines = videoBuffer.split('\n');

    for (int i = 0; i < lines.length - 1; i++) {
      final line = lines[i].trim();
      if (line.isEmpty) continue;

      try {
        final data = jsonDecode(line);

        if (data['type'] == 'video_frame') {
          final frameBase64 = data['frame'];
          final frameBytes = base64Decode(frameBase64);

          setState(() {
            currentFrame = frameBytes;
            motionDetected = data['motion_detected'] ?? false;
            motionAreas = data['motion_areas'] ?? 0;
            objectsDetected = (data['detections'] as List?)?.length ?? 0;
          });
        }
      } catch (e) {
        print('Error decodificando frame: $e');
      }
    }

    // Mantener el último fragmento incompleto
    videoBuffer = lines.last;
  }

  void disconnectFromVideoServer() {
    videoSocket?.close();
    setState(() {
      isWatchingVideo = false;
      currentFrame = null;
      videoBuffer = '';
    });
  }

  @override
  void dispose() {
    videoSocket?.close();
    alertSocket?.close();
    super.dispose();
  }

  TextEditingController ipServidorCamera = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          // Video feed
          Expanded(
            child: Container(
              color: Colors.black,
              child: Center(
                child: isWatchingVideo
                    ? currentFrame != null
                        ? Image.memory(
                            currentFrame!,
                            gaplessPlayback: true,
                            fit: BoxFit.contain,
                          )
                        : const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(height: 16),
                              Text('Cargando video...'),
                            ],
                          )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.videocam_off,
                            size: 80,
                            color: Colors.grey[700],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Cámara desactivada',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Presiona "Ver Cámara" para iniciar',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),

          // Panel de control
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'IP del Servidor de Cámara',
                        contentPadding: EdgeInsets.symmetric(horizontal: 8)),
                  ),
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //   children: [
                //     _buildStatCard(
                //       'Movimiento',
                //       motionAreas.toString(),
                //       Icons.motion_photos_on,
                //       Colors.orange,
                //     ),
                //     _buildStatCard(
                //       'Objetos',
                //       objectsDetected.toString(),
                //       Icons.visibility,
                //       Colors.blue,
                //     ),
                //     _buildStatCard(
                //       'Estado',
                //       isConnected ? 'Activo' : 'Inactivo',
                //       Icons.sensors,
                //       isConnected ? Colors.green : Colors.red,
                //     ),
                //   ],
                // ),
                // const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: isConnected ? connectToVideoServer : null,
                        icon: Icon(isWatchingVideo
                            ? Icons.videocam_off
                            : Icons.videocam),
                        label: Text(isWatchingVideo ? 'Detener' : 'Ver Cámara'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              isWatchingVideo ? Colors.red : Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          textStyle: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: isConnected ? null : connectToAlertServer,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reconectar'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 20),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Botón de prueba de notificaciones
                // TextButton.icon(
                //   onPressed: () {
                //     showNotification('Prueba', 'Probando notificaciones');
                //   },
                //   icon: const Icon(Icons.notifications_active, size: 16),
                //   label: const Text('Probar Notificación',
                //       style: TextStyle(fontSize: 12)),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.grey[850],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3), width: 2),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[400],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
