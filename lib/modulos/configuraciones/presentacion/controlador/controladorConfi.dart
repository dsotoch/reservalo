import 'package:flutter/material.dart';
import 'package:reservalo/core/aplicacion/funciones.dart';

class ControladorConf extends ChangeNotifier{
   String _regla="";

   String get regla => _regla;

  set regla(String value) {
    if(value!=_regla){
      _regla = value;
      notifyListeners();
    }

  }
   Future<void> Reglas() async {
     final response = await Funciones.get("reglas"); // llamas al endpoint PHP
     if (response["status"] == "success") {
       regla = response["data"][0]["reglas"];
     } else {
       regla = "";
     }
   }

}