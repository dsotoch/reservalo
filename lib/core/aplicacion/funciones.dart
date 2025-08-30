import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class Funciones {
  static String? validacionText(String nombrecampo, String? value) {
    if (value == null || value.isEmpty) {
      return "El $nombrecampo es obligatorio";
    }
    return null;
  }

  static DateTime combinarFechaHora(DateTime fecha, TimeOfDay hora) {
    return DateTime(fecha.year, fecha.month, fecha.day, hora.hour, hora.minute);
  }

  static void ocultarTeclado(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  static const String _baseUrl = "http://192.168.0.106/ayar_backeend/index.php";

  // Método GET reutilizable
  static Future<dynamic> get(String accion) async {
    try {
      final url = Uri.parse("$_baseUrl?accion=$accion");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          "error": true,
          "status": response.statusCode,
          "message": "Error en la solicitud GET",
        };
      }
    } catch (e) {
      return {"error": true, "message": e.toString()};
    }
  }

  static String formatDateDMY(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day-$month-$year';
  }

  static String stringToAmPm(String time) {
    if (time.isEmpty) return '12:00 AM';

    final parts = time.split(':');
    int hour = int.parse(parts[0]);
    final minute = parts[1];
    final period = hour >= 12 ? 'PM' : 'AM';

    if (hour > 12) hour -= 12;
    if (hour == 0) hour = 12;

    return '$hour:$minute $period';
  }

  static String timeToString(TimeOfDay? time) {
    if (time == null) return '00:00:00';
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:00';
  }

  static TimeOfDay stringToTime(String timeString) {
    // formato esperado: HH:mm:ss
    final parts = timeString.split(':');
    if (parts.length < 2) {
      throw FormatException("Formato inválido: $timeString");
    }

    final hour = int.tryParse(parts[0]) ?? 0;
    final minute = int.tryParse(parts[1]) ?? 0;

    return TimeOfDay(hour: hour, minute: minute);
  }

  static Future<void> capturarImagen(
    ScreenshotController controller,
    String reserva,
  ) async {
    if (await pedirPermisos()) {
      await controller.capture().then((captura) async {
        await ImageGallerySaverPlus.saveImage(
          captura!,
          quality: 100,
          name: "Reserva $reserva",
        );
      });
    }
  }

  static Future<Uint8List?> ImagenEnBytes(
    ScreenshotController controller,
  ) async {
    if (await pedirPermisos()) {
      return await controller.capture();
    }
    return null;
  }

  static Future<void> compartirImagen(
    BuildContext context,
    List<int> bytes,
    String nombreArchivo,
  ) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/$nombreArchivo.png');
      await file.writeAsBytes(bytes);

      await Share.shareXFiles([
        XFile(file.path),
      ], text: 'Te Comparto tu Reserva');
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('No se pudo compartir la imagen: $e'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  static Future<bool> pedirPermisos() async {
    var status = await Permission.photos.request(); // iOS
    var storage = await Permission.storage.request(); // Android

    return status.isGranted || storage.isGranted;
  }

  static Future<dynamic> post(String accion, Map<String, dynamic> body) async {
    try {
      final url = Uri.parse("$_baseUrl?accion=$accion");
      final response = await http.post(
        url,
        body: jsonEncode(body),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          "error": true,
          "status": response.statusCode,
          "message": "Error en la solicitud POST",
        };
      }
    } catch (e) {
      return {"error": true, "message": e.toString()};
    }
  }
}
