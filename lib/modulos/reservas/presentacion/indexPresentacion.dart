import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:reservalo/modulos/alojamiento/datos/modeloAlojamiento.dart';
import 'package:reservalo/modulos/reservas/presentacion/nuevaReserva.dart';

class CalendarioReservas extends StatefulWidget {
   CalendarioReservas({super.key});




  @override
  State<CalendarioReservas> createState() => _CalendarioReservasState();
}

class _CalendarioReservasState extends State<CalendarioReservas> {
  DateTime fecha = DateTime.now(); // mes actual
  List<ModeloAlojamiento> listaModeloAlojamiento=[
    ModeloAlojamiento(nombre: "Ayar Porteños Cabaña Duplex", id: "1"),
    ModeloAlojamiento(nombre: "Ayar Porteños Cabaña Duplex2", id: "2"),

  ];
  late ModeloAlojamiento? selectedValue = null;
  late String? alojamientoSeleccionado="";

  void _mesAnterior() {
    setState(() {
      final nuevoMes = DateTime(fecha.year, fecha.month - 1);
      // Solo este año
      if (nuevoMes.year == DateTime.now().year) {
        fecha = nuevoMes;
      }
    });
  }

  void _mesSiguiente() {
    setState(() {
      final nuevoMes = DateTime(fecha.year, fecha.month + 1);
      if (nuevoMes.year == DateTime.now().year) {
        fecha = nuevoMes;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final nombreMes = DateFormat.MMMM("es_ES").format(fecha).toUpperCase();
    final year = fecha.year;
    final diasMes = DateUtils.getDaysInMonth(fecha.year, fecha.month);
    final primerDiaSemana = DateTime(fecha.year, fecha.month, 1).weekday;

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
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blueAccent, width: 2),
                    ),
                   child: DropdownMenu<ModeloAlojamiento>(
                     width: double.infinity,
                     leadingIcon: const Icon(
                       Icons.house_outlined,
                       color: Colors.redAccent,
                     ),
                     textAlign: TextAlign.center,
                     initialSelection: selectedValue,
                     onSelected: (ModeloAlojamiento? value) {
                       if (value != null) {
                         setState(() {
                           selectedValue = value;
                           alojamientoSeleccionado = value.nombre;
                         });
                       }
                     },
                     dropdownMenuEntries: listaModeloAlojamiento.map((alojamiento) {
                       return DropdownMenuEntry<ModeloAlojamiento>(
                         value: alojamiento,
                         label: alojamiento.nombre,
                       );
                     }).toList(),
                   )
                    ,
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return NuevaReservaPage(nombreAlojamiento: alojamientoSeleccionado??'',);
                    },));
                  },
                  icon: const Icon(Icons.add,color: Colors.white,),
                  label: Text(
                    "Agregar",
                    style: TextStyle(fontSize: 14.sp,color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
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
                  onPressed: _mesAnterior,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(12)),
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
                  onPressed: _mesSiguiente,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(12)),
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
              physics: NeverScrollableScrollPhysics(),
              itemCount: dias.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                crossAxisSpacing: 6,
                mainAxisSpacing: 6,
              ),
              itemBuilder: (context, index) {
                final dia = dias[index];
                final isHoy = dia != null &&
                    fecha.year == hoy.year &&
                    fecha.month == hoy.month &&
                    dia == hoy.day;

                return Container(
                  decoration: BoxDecoration(
                    color: isHoy
                        ? Colors.amberAccent
                        : dia != null
                        ? Colors.blue[100]
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: dia != null
                          ? (isHoy ? Colors.amberAccent : Colors.blue)
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
                    child: Text(
                      dia?.toString() ?? "",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight:
                        isHoy ? FontWeight.bold : FontWeight.normal,
                        color: isHoy ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              },

          ),
        ],
      ),
    );
  }
}
