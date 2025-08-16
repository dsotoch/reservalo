import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reservalo/core/widgets/appBar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reservalo/modulos/reservas/presentacion/detallesReserva.dart';

class NuevaReservaPage extends StatelessWidget {
  final String nombreAlojamiento;

  final TextEditingController alojamientoController;
  NuevaReservaPage({super.key, required this.nombreAlojamiento})
    : alojamientoController = TextEditingController(text: nombreAlojamiento);

  final TextEditingController totalController = TextEditingController();
  final TextEditingController senalController = TextEditingController();
  final TextEditingController pendienteController = TextEditingController();
  final TextEditingController observacionesController = TextEditingController();
  final TextEditingController nombresController = TextEditingController();
  final TextEditingController apellidosController = TextEditingController();
  final TextEditingController dniController = TextEditingController();
  final TextEditingController correoController = TextEditingController();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        titulo: Text(
          "Nueva Reserva",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Alojamiento
            const Text(
              "🏫 ALOJAMIENTO",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: alojamientoController,
              readOnly: true,
              decoration: const InputDecoration(
                hintText: "Nombre del alojamiento",
              ),
            ),

            const SizedBox(height: 16),
            // Fechas y horas
            const Text(
              "📆 FECHA Y HORA DE LLEGADA",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                ValueListenableBuilder<DateTime?>(
                  valueListenable: fechaLlegada,
                  builder: (context, value, _) {
                    return Expanded(
                      child: TextButton(
                        onPressed: () async {
                          final fecha = await showDatePicker(
                            context: context,
                            initialDate: value ?? DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(DateTime.now().year, 12, 31),
                          );
                          if (fecha != null) fechaLlegada.value = fecha;
                        },
                        child: Text(
                          value == null
                              ? "Seleccionar fecha"
                              : DateFormat('dd/MM/yyyy').format(value),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 8),
                ValueListenableBuilder<TimeOfDay?>(
                  valueListenable: horaLlegada,
                  builder: (context, value, _) {
                    return Expanded(
                      child: TextButton(
                        onPressed: () async {
                          final hora = await showTimePicker(
                            context: context,
                            initialTime: value ?? TimeOfDay.now(),
                          );
                          if (hora != null) {
                            // Redondear a 15 min
                            int minuto = (hora.minute ~/ 15) * 15;
                            horaLlegada.value = TimeOfDay(
                              hour: hora.hour,
                              minute: minuto,
                            );
                          }
                        },
                        child: Text(
                          value == null
                              ? "Seleccionar hora"
                              : value.format(context),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 16),
            const Text(
              "📆 FECHA Y HORA DE SALIDA",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                ValueListenableBuilder<DateTime?>(
                  valueListenable: fechaSalida,
                  builder: (context, value, _) {
                    return Expanded(
                      child: TextButton(
                        onPressed: () async {
                          final fecha = await showDatePicker(
                            context: context,
                            initialDate: value ?? DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(DateTime.now().year, 12, 31),
                          );
                          if (fecha != null) fechaSalida.value = fecha;
                        },
                        child: Text(
                          value == null
                              ? "Seleccionar fecha"
                              : DateFormat('dd/MM/yyyy').format(value),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 8),
                ValueListenableBuilder<TimeOfDay?>(
                  valueListenable: horaSalida,
                  builder: (context, value, _) {
                    return Expanded(
                      child: TextButton(
                        onPressed: () async {
                          final hora = await showTimePicker(
                            context: context,
                            initialTime: value ?? TimeOfDay.now(),
                          );
                          if (hora != null) {
                            int minuto = (hora.minute ~/ 15) * 15;
                            horaSalida.value = TimeOfDay(
                              hour: hora.hour,
                              minute: minuto,
                            );
                          }
                        },
                        child: Text(
                          value == null
                              ? "Seleccionar hora"
                              : value.format(context),
                        ),
                      ),
                    );
                  },
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
                            onPressed: () => adultos.value = (adultos.value > 0
                                ? adultos.value - 1
                                : 0),
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
                            onPressed: () => ninos.value = (ninos.value > 0
                                ? ninos.value - 1
                                : 0),
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

            const SizedBox(height: 16),
            // Cobro
            const Text(
              "💰 COBRO",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: totalController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Importe total"),
            ),
            TextField(
              controller: senalController,
              keyboardType: TextInputType.number,

              decoration: const InputDecoration(labelText: "Señal / Adelanto"),
            ),
            TextField(
              controller: pendienteController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Pendiente"),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: observacionesController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: "Observaciones",
                enabledBorder: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),
            // Datos de contacto
            const Text(
              "📞 DATOS DE CONTACTO",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: dniController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "DNI",
                suffixIcon: IconButton(
                  color: Colors.redAccent,
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    print("Buscar DNI: ${dniController.text}");
                  },
                ),
              ),
            ),

            TextField(
              controller: nombresController,
              decoration: const InputDecoration(labelText: "Nombres"),
            ),
            TextField(
              controller: apellidosController,
              decoration: const InputDecoration(labelText: "Apellidos"),
            ),

            TextField(
              controller: correoController,
              decoration: const InputDecoration(
                labelText: "Correo electrónico",
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: notaController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: "Nota",
                enabledBorder: OutlineInputBorder(),
              ),
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
                return DropdownButton<String>(
                  value: value,
                  onChanged: (v) => estadoReserva.value = v ?? "Pendiente",
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
                );
              },
            ),

            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                style: ButtonStyle(
                  foregroundColor: WidgetStatePropertyAll(Colors.white),
                  backgroundColor: WidgetStateColor.resolveWith(
                    (states) => states.contains(WidgetState.pressed)
                        ? Colors.green.shade400
                        : Colors.green.shade700,
                  ),
                ),
                onPressed: () {
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Reserva registrada")),
                  );
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DetallesReserva(),));
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
    );
  }
}
