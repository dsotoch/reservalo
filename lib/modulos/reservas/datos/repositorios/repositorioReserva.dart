import 'package:reservalo/core/aplicacion/funciones.dart';
import 'package:reservalo/modulos/reservas/datos/modelos/modeloReserva.dart';

class RepositorioReserva {
  Future<dynamic> crearReserva(ModeloReserva modelo) async {
    return await Funciones.post("crear-reserva", modelo.toJson());
  }

  Future<dynamic> obtenerReservas(String id) async {
    return await Funciones.post("buscar-reservas", {"id": id});
  }

  Future<dynamic> obtenerReservasTodas() async {
    return await Funciones.post("listar-reservas", {});
  }
}
