import 'package:flutter/material.dart';

class Mensaje {
  static Future<void> showConfirmDialog(
      BuildContext context, {
        required String title,
        required String message,
        String confirmText = "Aceptar",
      }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
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
              onPressed: () => Navigator.of(context).pop(),
              child: Text(confirmText),
            ),
          ],
        );
      },
    );
  }
}
