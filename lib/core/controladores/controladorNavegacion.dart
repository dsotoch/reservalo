import 'package:flutter/material.dart';

class ControladorInicio extends ChangeNotifier{
  String _paginaActiva="inicio";
   set paginaActiva(String valor){
     _paginaActiva=valor;
     notifyListeners();
   }
   String get paginaActiva=>_paginaActiva;
}