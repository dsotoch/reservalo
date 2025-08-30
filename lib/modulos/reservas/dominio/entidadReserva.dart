import 'package:reservalo/modulos/alojamiento/dominio/entidadAlojamiento.dart';
import 'package:reservalo/modulos/clientes/dominio/entidadCliente.dart';

class EntidadReserva{
  final int id;
  final EntidadAlojamiento entidadAlojamiento;
  final DateTime fechaLLegada;
  final String horaLlegada;
  final DateTime fechaSalida;
  final String horaSalida;
  final String cantidadAdultos;
  final String cantidadNinos;
  final bool traeMascotas;
  final double importeTotal;
  final double adelanto;
  final double pendiente;
  final String observaciones;
  final EntidadCliente entidadCliente;
  final String notaCliente;
  final String estadoReserva;

  EntidadReserva(this.id,this.entidadAlojamiento, this.fechaLLegada, this.horaLlegada,
      this.fechaSalida, this.horaSalida, this.cantidadAdultos,
      this.cantidadNinos, this.traeMascotas, this.importeTotal, this.adelanto,
      this.pendiente, this.observaciones, this.entidadCliente, this.notaCliente,
      this.estadoReserva);


}