import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../../core/controladores/controladorNavegacion.dart';
import '../../../alojamiento/presentacion/controladores/controladorAlojamiento.dart';
import '../../../reservas/presentacion/controladores/controladorReserva.dart';

class Principal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controladorInicio = Provider.of<ControladorInicio>(context);
    final controladorAlojamiento = Provider.of<ControladorAlojamiento>(
      context,
      listen: false,
    );
    final controladorReserva = Provider.of<ControladorReserva>(
      context,
      listen: false,
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            Container(
              width: 1.sw / 2,
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.sh),
                  topRight: Radius.circular(15.h),
                ),
              ),
              child: Text(
                "📆                 AYAR ",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      offset: Offset(2, 2),
                      blurRadius: 4,
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: 1.sw / 2,
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(15.sh),
                ),
              ),
              child: Text(
                "   RESÉRVAS ⏱️",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      offset: Offset(2, 2),
                      blurRadius: 4,
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        Container(
          width: double.infinity,
          height: 1.sh / 2,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/cabana.jpg"),
              fit: BoxFit.cover,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.yellow,
                offset: Offset(0, 10),
                blurRadius: 20,
                spreadRadius: 0,
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        GestureDetector(
          onTap: () async {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) =>
                  const Center(child: CircularProgressIndicator()),
            );

            try {
              await controladorAlojamiento.listarAlojamientos();
              controladorReserva.listaModeloAlojamiento =
                  controladorAlojamiento.modeloAlojamiento;
              await controladorReserva.obtenerReservas(
                controladorReserva.listaModeloAlojamiento[0].id,
              );
              controladorInicio.paginaActiva = "reservas";
            } finally {
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            }
          },

          child: Container(
            margin: EdgeInsets.all(10),
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 16.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              gradient: const LinearGradient(
                colors: [Colors.blue, Colors.black],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.4),
                  offset: const Offset(0, 4),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    FontAwesomeIcons.calendarCheck,
                    color: Colors.white,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    "Reservar Ahora!",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
