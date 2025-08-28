import 'package:reservalo/core/aplicacion/funciones.dart';
import 'package:reservalo/modulos/alojamiento/datos/modelos/modeloAlojamiento.dart';

class RepositorioAlojamiento {
  Future<dynamic> listarAlojamientos() async {
    final data = await Funciones.get("listar-alojamientos");
    return data;
  }
  Future<dynamic> guardarAlojamientos(ModeloAlojamiento modelo) async {
    final data = await Funciones.post("crear-alojamiento",modelo.toJson());
    return data;
  }
  Future<dynamic> eliminarAlojamientos(String id) async {
    final data = await Funciones.post("eliminar-alojamiento", {"id":id});
    return data;
  }
}
