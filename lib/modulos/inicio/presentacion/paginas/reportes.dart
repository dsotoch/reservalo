import 'package:reservalo/modulos/clientes/datos/modelos/modeloCliente.dart';
import 'package:reservalo/modulos/clientes/dominio/entidadCliente.dart';
import 'package:reservalo/modulos/reservas/datos/modelos/modeloReserva.dart';

class Reportes {
  final List<ModeloReserva> listaReservas;

  Reportes({required this.listaReservas});

  Map<String, double> obtenerTotalIngresosPorMes() {
    Map<String, double> ingresosPorMes = {};

    for (var reserva in listaReservas) {
      final key = "${reserva.fechaLLegada.year}-${reserva.fechaLLegada.month.toString().padLeft(2, '0')}";

      if (ingresosPorMes.containsKey(key)) {
        ingresosPorMes[key] = ingresosPorMes[key]! + reserva.importeTotal;
      } else {
        ingresosPorMes[key] = reserva.importeTotal;
      }
    }

    return ingresosPorMes;
  }


  Map<EntidadCliente, List<ModeloReserva>> obtenerReservasPorCliente() {
    Map<EntidadCliente, List<ModeloReserva>> reporte = {};

    for (var reserva in listaReservas) {
      final cliente = reserva.entidadCliente;
      if (reporte.containsKey(cliente)) {
        reporte[cliente]!.add(reserva);
      } else {
        reporte[cliente] = [reserva];
      }
    }

    return reporte;
  }

  Map<EntidadCliente, int> obtenerCantidadVisitasPorCliente() {
    final reservasPorCliente = obtenerReservasPorCliente();
    Map<EntidadCliente, int> visitas = {};
    reservasPorCliente.forEach((cliente, reservas) {
      visitas[cliente] = reservas.length;
    });
    return visitas;
  }
}

