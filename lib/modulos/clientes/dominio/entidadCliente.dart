class EntidadCliente {
  String id;
  String nombre;
  String dni;
  String telefono;
  String email;

  EntidadCliente({
    required this.id,
    required this.nombre,
    required this.dni,
    required this.telefono,
    required this.email,

  });
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EntidadCliente && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
