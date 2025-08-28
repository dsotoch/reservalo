import 'package:reservalo/core/aplicacion/funciones.dart';
import 'package:reservalo/modulos/clientes/datos/modelos/modeloCliente.dart';

class RepositorioCliente {
  Future<dynamic> listarClientes() async {
    final data = await Funciones.get("listar-clientes");
    return data;
  }

  Future<dynamic> crearCliente(ModeloCliente modelo) async {
    final data = await Funciones.post("crear-cliente", modelo.toMap());
    return data;
  }

  Future<dynamic> eliminarCliente(String id) async {
    final data = await Funciones.post("eliminar-cliente", {"id": id});
    return data;
  }

  Future<dynamic> buscarCliente(String dni) async {
    final data = await Funciones.post("buscar-cliente", {"dni": dni});
    return data;
  }
}
