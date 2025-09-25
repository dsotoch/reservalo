import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:reservalo/core/widgets/appBar.dart';
import 'package:reservalo/modulos/alojamiento/presentacion/controladores/controladorAlojamiento.dart';
import 'package:reservalo/modulos/alojamiento/presentacion/paginas/indexAlojamiento.dart';
import 'package:reservalo/modulos/clientes/presentacion/paginas/indexClientes.dart';
import 'package:reservalo/modulos/configuraciones/presentacion/controlador/controladorConfi.dart';
import 'package:reservalo/modulos/configuraciones/presentacion/indexConfiguracion.dart';
import 'package:reservalo/modulos/inicio/presentacion/paginas/principal.dart';
import 'package:reservalo/modulos/inicio/presentacion/paginas/reportes.dart';
import 'package:reservalo/modulos/inicio/presentacion/paginas/reportesWidget.dart';
import 'package:reservalo/modulos/reservas/presentacion/controladores/controladorReserva.dart';
import 'package:reservalo/modulos/reservas/presentacion/indexPresentacion.dart';

import '../../../../core/controladores/controladorNavegacion.dart';

class Index extends StatelessWidget {
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
    final controladorConf = Provider.of<ControladorConf>(
      context,
      listen: false,
    );
    return Scaffold(
      appBar: AppBarWidget(
        titulo: Consumer<ControladorInicio>(
          builder: (context, value, child) {
            switch (value.paginaActiva) {
              case "alojamientos":
                return Text(
                  "Lista de Alojamientos",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                );
              case "reservas":
                return Text(
                  "Mis Reservas",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                );
              case "clientes":
                return Text(
                  "Mis Clientes",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                );
              default:
                return Text(
                  "Bienvenido de Nuevo",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                );
            }
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Consumer<ControladorInicio>(
          builder: (context, value, child) {
            switch (value.paginaActiva) {
              case "alojamientos":
                return IndexAlojamiento();
              case "clientes":
                return IndexClientes();
              case "reservas":
                return CalendarioReservas();
              case "configuraciones":
                return Configuracion();
              case "reportes":
                return ReporteWidget(
                  reportes: Reportes(
                    listaReservas: controladorReserva.listaReservas,
                  ),
                );
              default:
                return FutureBuilder(
                  future: inicialisardatos(
                    controladorAlojamiento,
                    controladorReserva,
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container(
                        color: Colors.black.withOpacity(0.5),
                        height: MediaQuery.of(context).size.height,
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Animación circular
                              SizedBox(
                                width: 80,
                                height: 80,
                                child: CircularProgressIndicator(
                                  strokeWidth: 6,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.blueAccent,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              // Mensaje
                              Text(
                                "Cargando, por favor espera...",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return CalendarioReservas();
                    }
                  },
                );
            }
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Menú de Opciones',
                    style: TextStyle(color: Colors.white, fontSize: 20.sp),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: Image.asset(
                      "assets/images/logos.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),

            ListTile(
              selected: controladorInicio.paginaActiva == "reservas",
              selectedTileColor: Colors.blue.shade200,
              selectedColor: Colors.white,
              leading: Icon(Icons.calendar_month),
              title: Text('Reservas'),
              onTap: () async {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) =>
                      const Center(child: CircularProgressIndicator()),
                );

                try {
                  controladorInicio.paginaActiva = "reservas";

                  await controladorAlojamiento.listarAlojamientos();

                  controladorReserva.listaModeloAlojamiento =
                      controladorAlojamiento.modeloAlojamiento;
                  await controladorReserva.obtenerReservasTodas();
                  controladorReserva.todosAlojamientos = true;
                  final modeloreserva = controladorReserva.listaReservas.toList();

                  if (modeloreserva.length > 1) {
                    controladorReserva.variasReservas = true;
                    controladorReserva.listaReservasDiaSeleccionado = modeloreserva;
                  } else {
                    controladorReserva.variasReservas = false;
                  }
                } finally {
                  Navigator.of(context).pop();
                }
              },
            ),
            ListTile(
              selected: controladorInicio.paginaActiva == "alojamientos",
              selectedTileColor: Colors.blue.shade200,
              selectedColor: Colors.white,
              leading: Icon(Icons.hotel),
              title: Text('Unid. Alojamiento'),
              onTap: () {
                controladorInicio.paginaActiva = "alojamientos";
                Navigator.pop(context);
              },
            ),
            ListTile(
              selected: controladorInicio.paginaActiva == "clientes",
              selectedTileColor: Colors.blue.shade200,
              selectedColor: Colors.white,
              leading: Icon(Icons.supervised_user_circle_sharp),
              title: Text('Clientes'),
              onTap: () {
                controladorInicio.paginaActiva = "clientes";
                Navigator.pop(context);
              },
            ),
            ListTile(
              selected: controladorInicio.paginaActiva == "reportes",
              selectedTileColor: Colors.blue.shade200,
              selectedColor: Colors.white,
              leading: Icon(Icons.balance),
              title: Text('Reportes'),
              onTap: () async {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) =>
                      const Center(child: CircularProgressIndicator()),
                );
                try {
                  await controladorReserva.obtenerReservasTodas();
                  controladorInicio.paginaActiva = "reportes";
                } finally {
                  Navigator.of(context).pop();
                }
              },
            ),
            ListTile(
              selected: controladorInicio.paginaActiva == "configuraciones",
              selectedTileColor: Colors.blue.shade200,
              selectedColor: Colors.white,
              leading: Icon(Icons.settings),
              title: Text('Configuración'),
              onTap: () async {
                controladorInicio.paginaActiva = "configuraciones";
                await controladorConf.Reglas();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> inicialisardatos(
    ControladorAlojamiento controladorAlojamiento,
    ControladorReserva controladorReserva,
  ) async {
    await controladorAlojamiento.listarAlojamientos();
    controladorReserva.listaModeloAlojamiento =
        controladorAlojamiento.modeloAlojamiento;
    await controladorReserva.obtenerReservasTodas();
    controladorReserva.todosAlojamientos = true;

    final modeloreserva = controladorReserva.listaReservas.toList();

    if (modeloreserva.length > 1) {
      controladorReserva.variasReservas = true;
      controladorReserva.listaReservasDiaSeleccionado = modeloreserva;
    } else {
      controladorReserva.variasReservas = false;
    }
  }
}
