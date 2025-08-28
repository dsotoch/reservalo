import 'package:reservalo/modulos/clientes/dominio/entidadCliente.dart';

class ModeloCliente extends EntidadCliente {
  ModeloCliente({
    required String id,
    required String nombre,
    required String email,
    required String dni,
    required String telefono,
  }) : super(
    id: id,
    nombre: nombre,
    dni: dni,
    telefono: telefono,
    email: email
  );

  factory ModeloCliente.fromMap(Map<String, dynamic> map) {
    return ModeloCliente(
      id: map["id"].toString() ?? "",
      nombre: map["nombres"].toString()  ?? "",
      email: map["email"].toString()  ?? "",
      dni: map["dni"].toString()  ?? "",
      telefono: map["telefono"].toString()  ?? "",
    );
  }

   Map<String, dynamic> toMap() {
    return {
      "id": id,
      "nombres": nombre,
      "dni": dni,
      "telefono": telefono,
      "email":email
    };
  }

  EntidadCliente toEntity() {
    return EntidadCliente(
      email: email,
      id: id,
      nombre: nombre,
      dni: dni,
      telefono: telefono,
    );
  }
}
