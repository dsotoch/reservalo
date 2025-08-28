import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:reservalo/core/widgets/mensaje.dart';
import 'package:reservalo/modulos/alojamiento/datos/modelos/modeloAlojamiento.dart';
import 'package:reservalo/modulos/reservas/presentacion/controladores/controladorReserva.dart';
import 'package:reservalo/modulos/reservas/presentacion/nuevaReserva.dart';

import 'detallesReserva.dart';

class CalendarioReservas extends StatelessWidget {
  ModeloAlojamiento? _valorSeleccionado;
  @override
  Widget build(BuildContext context) {
    final controladorReserva = Provider.of<ControladorReserva>(context);
    final nombreMes = DateFormat.MMMM(
      "es_ES",
    ).format(controladorReserva.fechaActual).toUpperCase();
    final year = controladorReserva.fechaActual.year;
    final diasMes = DateUtils.getDaysInMonth(
      controladorReserva.fechaActual.year,
      controladorReserva.fechaActual.month,
    );
    final primerDiaSemana = DateTime(
      controladorReserva.fechaActual.year,
      controladorReserva.fechaActual.month,
      1,
    ).weekday;

    final dias = List.generate(diasMes + (primerDiaSemana - 1), (index) {
      if (index < primerDiaSemana - 1) return null;
      return index - primerDiaSemana + 2;
    });

    final hoy = DateTime.now();

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          // Dropdown + botón agregar
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: DropdownMenu<ModeloAlojamiento>(
                    width: double.infinity,
                    leadingIcon: const Icon(
                      Icons.house,
                      color: Colors.redAccent,
                    ),
                    initialSelection:
                        controladorReserva.listaModeloAlojamiento.isNotEmpty
                        ? controladorReserva.listaModeloAlojamiento[0]
                        : null,

                    onSelected: (ModeloAlojamiento? value) async {
                      if (value != null) {
                        _valorSeleccionado = value;
                        await controladorReserva.obtenerReservas(value.id);
                      }
                    },
                    dropdownMenuEntries: controladorReserva
                        .listaModeloAlojamiento
                        .map((alojamiento) {
                          return DropdownMenuEntry<ModeloAlojamiento>(
                            value: alojamiento,
                            label: alojamiento.nombre.toUpperCase(),
                          );
                        })
                        .toList(),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: () async {
                    await controladorReserva.obtenerReservas(
                      _valorSeleccionado?.id ??
                          controladorReserva.listaModeloAlojamiento[0].id,
                    );
                    final reservasFiltradas = controladorReserva.listaReservas
                        .where((reserva) {
                          final idSeleccionado =
                              _valorSeleccionado?.id ??
                              controladorReserva.listaModeloAlojamiento[0].id;

                          return reserva.entidadAlojamiento.id ==
                              idSeleccionado;
                        })
                        .toList();

                    final ultimaReservamodelo = reservasFiltradas.isNotEmpty
                        ? reservasFiltradas.reduce((a, b) {
                            final fechaHoraA = DateTime(
                              a.fechaLLegada.year,
                              a.fechaLLegada.month,
                              a.fechaLLegada.day,
                              int.parse(a.horaLlegada.split(":")[0]),
                              int.parse(a.horaLlegada.split(":")[1]),
                            );

                            final fechaHoraB = DateTime(
                              b.fechaLLegada.year,
                              b.fechaLLegada.month,
                              b.fechaLLegada.day,
                              int.parse(b.horaLlegada.split(":")[0]),
                              int.parse(b.horaLlegada.split(":")[1]),
                            );

                            return fechaHoraA.isAfter(fechaHoraB) ? a : b;
                          })
                        : null;
                    controladorReserva.ultimaReserva = ultimaReservamodelo;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return NuevaReservaPage(
                            nombreAlojamiento:
                                _valorSeleccionado ??
                                controladorReserva.listaModeloAlojamiento[0],
                          );
                        },
                      ),
                    );
                  },
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: Text(
                    "Agregar",
                    style: TextStyle(fontSize: 14.sp, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: Colors.green.shade700,
                  ),
                ),
              ],
            ),
          ),

          // Navegación del mes
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () => controladorReserva.mesAnterior(
                    _valorSeleccionado != null
                        ? _valorSeleccionado!.id
                        : controladorReserva.listaModeloAlojamiento[0].id,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(12),
                  ),
                  child: const Icon(Icons.arrow_back),
                ),
                Text(
                  "$nombreMes $year",
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton(
                  onPressed: () => controladorReserva.mesSiguiente(
                    _valorSeleccionado != null
                        ? _valorSeleccionado!.id
                        : controladorReserva.listaModeloAlojamiento[0].id,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(12),
                  ),
                  child: const Icon(Icons.arrow_forward),
                ),
              ],
            ),
          ),

          // Días de la semana
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text("L", style: TextStyle(fontWeight: FontWeight.bold)),
              Text("M", style: TextStyle(fontWeight: FontWeight.bold)),
              Text("M", style: TextStyle(fontWeight: FontWeight.bold)),
              Text("J", style: TextStyle(fontWeight: FontWeight.bold)),
              Text("V", style: TextStyle(fontWeight: FontWeight.bold)),
              Text("S", style: TextStyle(fontWeight: FontWeight.bold)),
              Text("D", style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 6),

          // Calendario
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: dias.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              crossAxisSpacing: 6,
              mainAxisSpacing: 6,
            ),
            itemBuilder: (context, index) {
              final dia = dias[index];
              // Comprobar si es hoy
              final isHoy =
                  dia != null &&
                  controladorReserva.fechaActual.year == hoy.year &&
                  controladorReserva.fechaActual.month == hoy.month &&
                  dia == hoy.day;

              final tieneReserva =
                  dia != null &&
                  controladorReserva.listaReservas.any((reserva) {
                    final fechaDia = DateTime(
                      controladorReserva.fechaActual.year,
                      controladorReserva.fechaActual.month,
                      dia,
                    );

                    return fechaDia.isAfter(
                          reserva.fechaLLegada.subtract(
                            const Duration(days: 1),
                          ),
                        ) &&
                        fechaDia.isBefore(
                          reserva.fechaSalida.add(const Duration(days: 1)),
                        );
                  });

              return Material(
                color: Colors.transparent,
                child: InkWell(
                  splashColor: Colors.deepOrangeAccent,
                  highlightColor: Colors.green,
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    final DateTime fechaSeleccionada = DateTime(
                      controladorReserva.fechaActual.year,
                      controladorReserva.fechaActual.month,
                      dia!,
                    );

                    final modeloreserva = controladorReserva.listaReservas
                        .where((reserva) {
                          return fechaSeleccionada.isAfter(
                                reserva.fechaLLegada.subtract(
                                  const Duration(days: 1),
                                ),
                              ) &&
                              fechaSeleccionada.isBefore(
                                reserva.fechaSalida.add(
                                  const Duration(days: 1),
                                ),
                              );
                        })
                        .toList();

                    if (modeloreserva.isEmpty) {
                      Mensaje.showConfirmDialog(
                        context,
                        title: "⚠️Sin Datos!",
                        message: "No existen reservas para el dia seleccionado",
                      );
                      return;
                    }
                    if (modeloreserva.length > 1) {
                      controladorReserva.variasReservas = true;
                      controladorReserva.listaReservasDiaSeleccionado =
                          modeloreserva;
                    } else {
                      controladorReserva.variasReservas = false;
                      controladorReserva.listaReservasDiaSeleccionado = [];

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetallesReserva(
                            modeloReserva: modeloreserva.first,
                            reservaNueva: false,
                          ),
                        ),
                      );
                    }
                  },
                  child: Ink(
                    decoration: BoxDecoration(
                      color: tieneReserva
                          ? Colors.redAccent
                          : dia != null
                          ? Colors.blue[100]
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: dia != null
                            ? (tieneReserva ? Colors.red : Colors.blue)
                            : Colors.transparent,
                      ),
                      boxShadow: dia != null
                          ? [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                blurRadius: 3,
                                offset: const Offset(1, 1),
                              ),
                            ]
                          : [],
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          dia?.toString() ?? "",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: isHoy
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: tieneReserva ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 10),
          if (!controladorReserva.variasReservas) ...[
            const SizedBox(height: 20),
            Image.asset(
              "assets/images/logo.jpg",
              width: double.infinity,
              height: 170.h,
            ),
          ],

          if (controladorReserva.variasReservas)
            SizedBox(
              height: 205.h,
              width: double.infinity,
              child: ListView.builder(
                itemCount:
                    controladorReserva.listaReservasDiaSeleccionado.length,
                itemBuilder: (context, index) {
                  final reserva =
                      controladorReserva.listaReservasDiaSeleccionado[index];

                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetallesReserva(
                            modeloReserva: reserva,
                            reservaNueva: false,
                          ),
                        ),
                      );
                    },
                    child: Card(
                      color: Colors.greenAccent.shade100,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6,
                      ),
                      elevation: 2,
                      child: ListTile(
                        leading: const Icon(Icons.event, color: Colors.blue),
                        title: Text(
                          'Cliente: ${reserva.entidadCliente.nombre}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Entrada: ${reserva.fechaLLegada}'),
                            Text('Salida: ${reserva.fechaSalida}'),
                            Text('Estado: ${reserva.estadoReserva}'),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
