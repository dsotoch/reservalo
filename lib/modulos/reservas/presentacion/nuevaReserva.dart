import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:reservalo/core/aplicacion/funciones.dart';
import 'package:reservalo/core/widgets/appBar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reservalo/core/widgets/mensaje.dart';
import 'package:reservalo/modulos/alojamiento/datos/modelos/modeloAlojamiento.dart';
import 'package:reservalo/modulos/clientes/datos/modelos/modeloCliente.dart';
import 'package:reservalo/modulos/reservas/datos/modelos/modeloReserva.dart';
import 'package:reservalo/modulos/reservas/presentacion/controladores/controladorReserva.dart';
import 'package:reservalo/modulos/reservas/presentacion/detallesReserva.dart';

class NuevaReservaPage extends StatelessWidget {
  final ModeloAlojamiento nombreAlojamiento;
  final ModeloReserva? modeloReservaParametro;
  final TextEditingController alojamientoController;
  final bool editar;
  NuevaReservaPage({
    super.key,
    required this.nombreAlojamiento,
    this.editar = false,
    this.modeloReservaParametro,
  }) : alojamientoController = TextEditingController(
         text: nombreAlojamiento.nombre,
       );

  final TextEditingController totalController = TextEditingController();
  final TextEditingController senalController = TextEditingController();
  final TextEditingController pendienteController = TextEditingController();
  final TextEditingController observacionesController = TextEditingController();
  final TextEditingController nombresController = TextEditingController();
  final TextEditingController dniController = TextEditingController();
  final TextEditingController correoController = TextEditingController();
  final TextEditingController telefonoController = TextEditingController();

  final TextEditingController notaController = TextEditingController();

  // Valores iniciales

  final ValueNotifier<DateTime?> fechaLlegada = ValueNotifier(null);
  final ValueNotifier<TimeOfDay?> horaLlegada = ValueNotifier(null);
  final ValueNotifier<DateTime?> fechaSalida = ValueNotifier(null);
  final ValueNotifier<TimeOfDay?> horaSalida = ValueNotifier(null);
  final ValueNotifier<int> adultos = ValueNotifier(1);
  final ValueNotifier<int> ninos = ValueNotifier(0);
  final ValueNotifier<bool> traeMascotas = ValueNotifier(false);
  final ValueNotifier<String> estadoReserva = ValueNotifier("Pendiente");

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final controladorReserva = Provider.of<ControladorReserva>(context);
    if (editar) {
      fechaLlegada.value = modeloReservaParametro?.fechaLLegada;
      fechaSalida.value = modeloReservaParametro?.fechaSalida;
      horaLlegada.value = Funciones.stringToTime(
        modeloReservaParametro!.horaLlegada,
      );
      horaSalida.value = Funciones.stringToTime(
        modeloReservaParametro!.horaSalida,
      );
      adultos.value = int.parse(modeloReservaParametro!.cantidadAdultos);
      ninos.value = int.parse(modeloReservaParametro!.cantidadNinos);
      traeMascotas.value = modeloReservaParametro!.traeMascotas;
      totalController.text = modeloReservaParametro!.importeTotal.toString();
      senalController.text = modeloReservaParametro!.adelanto.toString();
      pendienteController.text = modeloReservaParametro!.pendiente.toString();
      observacionesController.text = modeloReservaParametro!.observaciones;
      dniController.text = dniController.text.isEmpty?modeloReservaParametro!.entidadCliente.dni:dniController.text;
      nombresController.text = nombresController.text.isEmpty?modeloReservaParametro!.entidadCliente.nombre:nombresController.text;
      telefonoController.text = telefonoController.text.isEmpty?modeloReservaParametro!.entidadCliente.telefono:telefonoController.text;
      correoController.text = correoController.text.isEmpty?modeloReservaParametro!.entidadCliente.email:correoController.text;
      notaController.text = modeloReservaParametro!.notaCliente;
      estadoReserva.value = modeloReservaParametro!.estadoReserva;
    }
    return Scaffold(
      appBar: AppBarWidget(
        titulo: Text(
          "${editar ? "Modificar" : "Nueva"} Reserva",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Alojamiento
                  const Text(
                    "🏫 ALOJAMIENTO",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextFormField(
                    controller: alojamientoController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      hintText: "Nombre del alojamiento",
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? "Selecciona un alojamiento"
                        : null,
                  ),
                  const SizedBox(height: 16),

                  // Fecha y hora llegada
                  const Text(
                    "📆 FECHA Y HORA DE LLEGADA",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ValueListenableBuilder<DateTime?>(
                          valueListenable: fechaLlegada,
                          builder: (context, value, _) {
                            return TextButton(
                              onPressed: () async {
                                final fecha = await showDatePicker(
                                  context: context,
                                  initialDate: value ?? DateTime.now(),
                                  firstDate: editar
                                      ? modeloReservaParametro!.fechaLLegada
                                      : DateTime.now(),
                                  lastDate: DateTime(
                                    DateTime.now().year,
                                    12,
                                    31,
                                  ),
                                );
                                if (fecha != null) fechaLlegada.value = fecha;
                              },
                              child: Text(
                                value == null
                                    ? "Seleccionar fecha"
                                    : DateFormat('dd/MM/yyyy').format(value),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ValueListenableBuilder<TimeOfDay?>(
                          valueListenable: horaLlegada,
                          builder: (context, value, _) {
                            return TextButton(
                              onPressed: () async {
                                final hora = await showTimePicker(
                                  context: context,
                                  initialTime: value ?? TimeOfDay.now(),
                                );

                                if (hora != null) {
                                  horaLlegada.value = TimeOfDay(
                                    hour: hora.hour,
                                    minute: hora.minute,
                                  );

                                  final ultimaReserva =
                                      controladorReserva.ultimaReserva;
                                  if (ultimaReserva != null &&
                                      nombreAlojamiento.id ==
                                          controladorReserva
                                              .ultimaReserva
                                              ?.entidadAlojamiento
                                              .id) {
                                    if (ultimaReserva.fechaSalida ==
                                        fechaLlegada.value) {
                                      final partes = ultimaReserva.horaSalida
                                          .split(":");

                                      final ultimaHora = TimeOfDay(
                                        hour: int.parse(partes[0]),
                                        minute: int.parse(partes[1]),
                                      );

                                      final nuevaFechaHora =
                                          Funciones.combinarFechaHora(
                                            fechaLlegada.value!,
                                            horaLlegada.value!,
                                          );
                                      final ultimaFechaHora =
                                          Funciones.combinarFechaHora(
                                            ultimaReserva.fechaSalida,
                                            ultimaHora,
                                          );

                                      if (!nuevaFechaHora.isAfter(
                                        ultimaFechaHora,
                                      )) {
                                        if (kDebugMode) {
                                          print(
                                            "❌ ERROR → Nueva fecha no es mayor a la última.",
                                          );
                                        }
                                        Mensaje.showConfirmDialog(
                                          context,
                                          title: "✖️ Error de Fechas",
                                          message:
                                              "La hora de llegada debe ser mayor a la salida de  la última reserva. $ultimaFechaHora",
                                        );
                                      } else {
                                        if (kDebugMode) {
                                          print(
                                            "✅ Nueva fecha es válida (después de la última).",
                                          );
                                        }
                                      }
                                    } else {
                                      if (kDebugMode) {
                                        print(
                                          "⏭️ No es el mismo día, no se valida hora.",
                                        );
                                      }
                                    }
                                  } else {
                                    if (kDebugMode) {
                                      print(
                                        "⚠️ No existe última reserva, se acepta la hora.",
                                      );
                                    }
                                  }
                                } else {
                                  if (kDebugMode) {
                                    print(
                                      "⚪ Usuario canceló selección de hora.",
                                    );
                                  }
                                }
                              },

                              child: Text(
                                value == null
                                    ? "Seleccionar hora"
                                    : value.format(context),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Fecha y hora salida
                  const Text(
                    "📆 FECHA Y HORA DE SALIDA",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ValueListenableBuilder<DateTime?>(
                          valueListenable: fechaSalida,
                          builder: (context, value, _) {
                            return TextButton(
                              onPressed: () async {
                                final fecha = await showDatePicker(
                                  context: context,
                                  initialDate: value ?? DateTime.now(),
                                  firstDate: editar
                                      ? modeloReservaParametro!.fechaLLegada
                                      : DateTime.now(),
                                  lastDate: DateTime(
                                    DateTime.now().year,
                                    12,
                                    31,
                                  ),
                                );
                                if (fecha != null) fechaSalida.value = fecha;
                              },
                              child: Text(
                                value == null
                                    ? "Seleccionar fecha"
                                    : DateFormat('dd/MM/yyyy').format(value),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ValueListenableBuilder<TimeOfDay?>(
                          valueListenable: horaSalida,
                          builder: (context, value, _) {
                            return TextButton(
                              onPressed: () async {
                                final hora = await showTimePicker(
                                  context: context,
                                  initialTime: value ?? TimeOfDay.now(),
                                );
                                if (hora != null) {
                                  horaSalida.value = TimeOfDay(
                                    hour: hora.hour,
                                    minute: hora.minute,
                                  );
                                }
                              },
                              child: Text(
                                value == null
                                    ? "Seleccionar hora"
                                    : value.format(context),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Ocupación
                  const Text(
                    "🧔‍♂️🧔‍♀️ OCUPACION",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      ValueListenableBuilder<int>(
                        valueListenable: adultos,
                        builder: (context, value, _) {
                          return Expanded(
                            child: Row(
                              children: [
                                const Text("Adultos: "),
                                IconButton(
                                  onPressed: () =>
                                      adultos.value = (adultos.value > 1
                                      ? adultos.value - 1
                                      : 1),
                                  icon: const Icon(Icons.remove),
                                ),
                                Text(value.toString()),
                                IconButton(
                                  onPressed: () => adultos.value += 1,
                                  icon: const Icon(Icons.add),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      ValueListenableBuilder<int>(
                        valueListenable: ninos,
                        builder: (context, value, _) {
                          return Expanded(
                            child: Row(
                              children: [
                                const Text("Niños: "),
                                IconButton(
                                  onPressed: () => ninos.value =
                                      (ninos.value > 0 ? ninos.value - 1 : 0),
                                  icon: const Icon(Icons.remove),
                                ),
                                Text(value.toString()),
                                IconButton(
                                  onPressed: () => ninos.value += 1,
                                  icon: const Icon(Icons.add),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  ValueListenableBuilder<bool>(
                    valueListenable: traeMascotas,
                    builder: (context, value, _) {
                      return CheckboxListTile(
                        value: value,
                        onChanged: (v) => traeMascotas.value = v ?? false,
                        title: const Text("Trae mascotas"),
                      );
                    },
                  ),
                  Builder(
                    builder: (_) => adultos.value < 1
                        ? const Text(
                            "Debe haber al menos 1 adulto",
                            style: TextStyle(color: Colors.red),
                          )
                        : const SizedBox.shrink(),
                  ),
                  const SizedBox(height: 16),

                  // Cobro
                  const Text(
                    "💰 COBRO",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextFormField(
                    controller: totalController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Importe total",
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? "Ingresa el importe"
                        : null,
                  ),
                  TextFormField(
                    controller: senalController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Señal / Adelanto",
                    ),
                    onChanged: (value) {
                      if (totalController.text == "") {
                        Mensaje.showConfirmDialog(
                          context,
                          title: "✖️Ocurrió un error!",
                          message: "Primero Ingresa el Importe total.",
                        );
                        senalController.text = "";
                      } else {
                        if (double.parse(totalController.text) <
                            double.parse(value)) {
                          Mensaje.showConfirmDialog(
                            context,
                            title: "✖️Ocurrió un error!",
                            message:
                                "El Importe total es menor que el Adelanto.",
                          );
                          senalController.text = "";
                          pendienteController.text = "";
                        } else {
                          pendienteController.text =
                              (double.parse(totalController.text) -
                                      double.parse(value))
                                  .toString();
                        }
                      }
                    },
                    validator: (value) => value == null || value.isEmpty
                        ? "Ingresa la señal"
                        : null,
                  ),
                  TextFormField(
                    controller: pendienteController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: "Pendiente"),
                    validator: (value) => value == null || value.isEmpty
                        ? "Ingresa el pendiente"
                        : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: observacionesController,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      labelText: "Observaciones",
                      enabledBorder: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value == null || value.isEmpty ? null : null,
                  ),
                  const SizedBox(height: 16),

                  // Datos de contacto
                  const Text(
                    "📞 DATOS DE CONTACTO",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextFormField(
                    controller: dniController,
                    maxLength: 8,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: "DNI"),
                    onChanged: (value) async {
                      if (value.length == 8) {
                        Funciones.ocultarTeclado(context);
                        if (!editar) {
                          controladorReserva.buscandoCliente = true;
                          final resp = await controladorReserva.buscarCliente(
                            value,
                          );
                          controladorReserva.buscandoCliente = false;

                          if (resp["status"] == "success") {
                            nombresController.text = resp["data"]["nombres"];
                            telefonoController.text = resp["data"]["telefono"];
                            correoController.text = resp["data"]["email"];
                            controladorReserva.modeloCliente = ModeloCliente(
                              id: resp["data"]["id"].toString(),
                              nombre: resp["data"]["nombres"],
                              email: resp["data"]["email"],
                              dni: value,
                              telefono: resp["data"]["telefono"],
                            );
                          } else {
                            if (context.mounted) {
                              Mensaje.showConfirmDialog(
                                context,
                                title: "Cliente Nuevo!",
                                message: resp["message"],
                              );
                            }
                            nombresController.text = "";
                            telefonoController.text = "";
                            correoController.text = "";
                            controladorReserva.modeloCliente = null;
                          }
                        }
                      }
                    },

                    validator: (value) => value == null || value.isEmpty
                        ? "Ingresa el DNI"
                        : null,
                  ),
                  TextFormField(
                    controller: nombresController,
                    decoration: const InputDecoration(
                      labelText: "Nombres y Apellidos",
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? "Ingresa los nombres"
                        : null,
                  ),

                  TextFormField(
                    controller: correoController,
                    decoration: const InputDecoration(
                      labelText: "Correo electrónico",
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? "Ingresa el correo"
                        : null,
                  ),
                  TextFormField(
                    controller: telefonoController,
                    decoration: const InputDecoration(labelText: "Telefono"),
                    validator: (value) => value == null || value.isEmpty
                        ? "Ingresa el Telefono"
                        : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: notaController,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      labelText: "Nota",
                      enabledBorder: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value == null || value.isEmpty ? null : null,
                  ),
                  const SizedBox(height: 16),

                  // Estado de la reserva
                  const Text(
                    "ESTADO DE LA RESERVA",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ValueListenableBuilder<String>(
                    valueListenable: estadoReserva,
                    builder: (context, value, _) {
                      return DropdownButtonFormField<String>(
                        value: value,
                        onChanged: (v) =>
                            estadoReserva.value = v ?? "Pendiente",
                        items: const [
                          DropdownMenuItem(
                            value: "Pendiente",
                            child: Text("Pendiente"),
                          ),
                          DropdownMenuItem(
                            value: "Adelanto cobrado",
                            child: Text("Adelanto cobrado"),
                          ),
                          DropdownMenuItem(
                            value: "Importe total cancelado",
                            child: Text("Importe total cancelado"),
                          ),
                          DropdownMenuItem(
                            value: "Reserva Anulada",
                            child: Text("Reserva Anulada"),
                          ),
                        ],
                        validator: (value) => value == null || value.isEmpty
                            ? "Selecciona un estado"
                            : null,
                      );
                    },
                  ),
                  const SizedBox(height: 20),

                  Center(
                    child: ElevatedButton(
                      style: ButtonStyle(
                        foregroundColor: const MaterialStatePropertyAll(
                          Colors.white,
                        ),
                        backgroundColor: MaterialStateColor.resolveWith(
                          (states) => states.contains(MaterialState.pressed)
                              ? Colors.green.shade400
                              : Colors.green.shade700,
                        ),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          if (fechaLlegada.value == null) {
                            Mensaje.showConfirmDialog(
                              context,
                              title: "✖️Ocurrió un Error",
                              message: "Selecciona la fecha de llegada",
                            );
                            return;
                          }

                          if (horaLlegada.value == null) {
                            Mensaje.showConfirmDialog(
                              context,
                              title: "✖️Ocurrió un Error",
                              message: "Selecciona la hora de llegada",
                            );
                            return;
                          }

                          if (fechaSalida.value == null) {
                            Mensaje.showConfirmDialog(
                              context,
                              title: "✖️Ocurrió un Error",
                              message: "Selecciona la fecha de salida",
                            );
                            return;
                          }

                          if (horaSalida.value == null) {
                            Mensaje.showConfirmDialog(
                              context,
                              title: "✖️Ocurrió un Error",
                              message: "Selecciona la hora de salida",
                            );
                            return;
                          }

                          DateTime fechaHoraLlegada = DateTime(
                            fechaLlegada.value!.year,
                            fechaLlegada.value!.month,
                            fechaLlegada.value!.day,
                            horaLlegada.value!.hour,
                            horaLlegada.value!.minute,
                          );

                          DateTime fechaHoraSalida = DateTime(
                            fechaSalida.value!.year,
                            fechaSalida.value!.month,
                            fechaSalida.value!.day,
                            horaSalida.value!.hour,
                            horaSalida.value!.minute,
                          );

                          if (fechaHoraLlegada.isAtSameMomentAs(
                            fechaHoraSalida,
                          )) {
                            Mensaje.showConfirmDialog(
                              context,
                              title: "✖️Ocurrió un Error",
                              message: "Las Fechas y Horas Son Iguales.",
                            );
                            return;
                          }

                          ModeloCliente entidadCliente = ModeloCliente(
                            id: modeloReservaParametro?.entidadCliente.id ?? "",
                            nombre: nombresController.text,
                            email: correoController.text,
                            dni: dniController.text,
                            telefono: telefonoController.text,
                          );
                          ModeloReserva modeloreserva = ModeloReserva(
                            id: modeloReservaParametro?.id ?? 0,
                            entidadAlojamiento: nombreAlojamiento,
                            fechaLLegada: fechaLlegada.value!,
                            horaLlegada: Funciones.timeToString(
                              horaLlegada.value,
                            ),
                            fechaSalida: fechaSalida.value!,
                            horaSalida: Funciones.timeToString(
                              horaSalida.value,
                            ),
                            cantidadAdultos: adultos.value.toString(),
                            cantidadNinos: ninos.value.toString(),
                            traeMascotas: traeMascotas.value,
                            importeTotal: double.parse(totalController.text),
                            adelanto: double.parse(senalController.text),
                            pendiente: double.parse(pendienteController.text),
                            observaciones: observacionesController.text,
                            entidadCliente:
                                controladorReserva.modeloCliente ??
                                entidadCliente,
                            notaCliente: notaController.text,
                            estadoReserva: estadoReserva.value,
                          );

                          final resultado = await controladorReserva
                              .crearReserva(modeloreserva);
                          if (resultado["status"] == "success") {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(resultado["message"])),
                              );
                              Future.delayed(Duration(seconds: 2));
                              if (editar) {
                                controladorReserva.variasReservas = false;
                                await controladorReserva.obtenerReservas(
                                  controladorReserva
                                      .listaModeloAlojamiento[0]
                                      .id,
                                );
                              }
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetallesReserva(
                                    modeloReserva: modeloreserva,
                                  ),
                                ),
                              );
                            }
                          } else {
                            Mensaje.showConfirmDialog(
                              context,
                              title: "Error!",
                              message: resultado["message"],
                            );
                          }
                        }
                      },
                      child: Text(
                        "Guardar reserva",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (controladorReserva.buscandoCliente)
            Positioned.fill(
              child: Container(
                color: Colors.black.withValues(alpha: 0.7),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white, // Fondo del modal
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(color: Colors.black26, blurRadius: 10),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          "Buscando cliente...",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade700,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Icon(Icons.search, color: Colors.blue),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
