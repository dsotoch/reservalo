import 'package:flutter/material.dart';

class Confirmacion {
  static Future<bool?> showConfirmDialog(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = "Aceptar",
    String cancelText = "Cancelar",
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // obliga a elegir una opción
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              style: ButtonStyle(
                foregroundColor: WidgetStatePropertyAll(Colors.black),

              ),
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(cancelText),
            ),
            ElevatedButton(
              style: ButtonStyle(
                foregroundColor: WidgetStatePropertyAll(Colors.white),
                backgroundColor: WidgetStateColor.resolveWith((states) {
                  if(states.contains(WidgetState.pressed)){
                    return Colors.green.shade400;
                  }else{
                    return Colors.green.shade400;

                  }
                },)
              ),
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(confirmText),
            ),
          ],
        );
      },
    );
  }
}
