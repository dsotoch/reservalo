import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reservalo/modulos/inicio/presentacion/paginas/reportes.dart';

class ReporteWidget extends StatelessWidget {
  final Reportes reportes;

  const ReporteWidget({super.key, required this.reportes});

  @override
  Widget build(BuildContext context) {
    final totalIngresos = reportes.obtenerTotalIngresosPorMes();
    final reservasPorCliente = reportes.obtenerReservasPorCliente();
    final cantidadVisitas = reportes.obtenerCantidadVisitasPorCliente();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 💰 Total ingresos
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
          shadowColor: Colors.greenAccent.withOpacity(0.4),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green.shade300, Colors.green.shade100],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(16),
            child: Card(
              color: Colors.green[600],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.all(12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Total Ingresos por Mes",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...totalIngresos.entries.map((entry) {
                      final key = entry.key; // ejemplo: "2025-09"
                      final ingreso = entry.value;

                      // Extraemos el mes como int
                      final mesInt = int.parse(key.split("-")[1]); // "09" -> 9

                      final nombreMes = [
                        "", // índice 0 vacío
                        "Enero",
                        "Febrero",
                        "Marzo",
                        "Abril",
                        "Mayo",
                        "Junio",
                        "Julio",
                        "Agosto",
                        "Septiembre",
                        "Octubre",
                        "Noviembre",
                        "Diciembre",
                      ][mesInt];

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.attach_money,
                              color: Colors.white,
                              size: 28,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                "$nombreMes ${key.split("-")[0]}: S/ ${ingreso.toStringAsFixed(2)}",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título del reporte
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text(
                "Clientes y Reservas",
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey.shade800,
                ),
              ),
            ),

            // Lista de clientes
            SizedBox(
              height: 500.h,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: ListView.builder(
                  itemCount: reservasPorCliente.keys.length,
                  itemBuilder: (context, index) {
                    final cliente = reservasPorCliente.keys.elementAt(index);
                    final reservas = reservasPorCliente[cliente]!;

                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shadowColor: Colors.grey.withOpacity(0.3),
                      child: ExpansionTile(
                        tilePadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        collapsedBackgroundColor: Colors.blueGrey.shade50,
                        backgroundColor: Colors.blueGrey.shade100.withOpacity(
                          0.3,
                        ),
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue.shade100,
                          child: const Icon(Icons.person, color: Colors.blue),
                        ),
                        title: Text(
                          "${cliente.nombre} - Visitas: ${cantidadVisitas[cliente]}",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.sp,
                            color: Colors.blueGrey.shade900,
                          ),
                        ),
                        children: reservas.map((reserva) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 6,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.15),
                                    blurRadius: 4,
                                    offset: const Offset(1, 1),
                                  ),
                                ],
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 8,
                                ),
                                leading: const Icon(
                                  Icons.bookmark,
                                  color: Colors.green,
                                ),
                                title: Text(
                                  "Reserva: S/ ${reserva.importeTotal.toStringAsFixed(2)}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15.sp,
                                  ),
                                ),
                                subtitle: Text(
                                  "Fecha: ${reserva.fechaLLegada.day}/${reserva.fechaLLegada.month}/${reserva.fechaLLegada.year}",
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontSize: 13.sp,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
