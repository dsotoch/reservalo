import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

  static const String _baseUrl = "http://10.0.2.2/ayar_backeend/index.php";

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
