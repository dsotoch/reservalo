import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:reservalo/core/aplicacion/funciones.dart';
import 'package:reservalo/core/widgets/appBar.dart';
import 'package:reservalo/core/widgets/confirmacion.dart';
import 'package:reservalo/core/widgets/mensaje.dart';
import 'package:reservalo/modulos/alojamiento/datos/modelos/modeloAlojamiento.dart';
import 'package:reservalo/modulos/alojamiento/presentacion/controladores/controladorAlojamiento.dart';
import 'package:reservalo/modulos/configuraciones/presentacion/controlador/controladorConfi.dart';
import 'package:reservalo/modulos/reservas/datos/modelos/modeloReserva.dart';
import 'package:reservalo/modulos/reservas/presentacion/controladores/controladorReserva.dart';
import 'package:reservalo/modulos/reservas/presentacion/nuevaReserva.dart';
import 'package:screenshot/screenshot.dart';

class DetallesReserva extends StatelessWidget {
  final ModeloReserva modeloReserva;
  final bool reservaNueva;
  DetallesReserva({
    super.key,
    required this.modeloReserva,
    this.reservaNueva = true,
  });
  ScreenshotController screenshotController = ScreenshotController();
  @override
  Widget build(BuildContext context) {
    final controladorAlojamiento = Provider.of<ControladorAlojamiento>(
      context,
      listen: false,
    );
    final controladorConf = Provider.of<ControladorConf>(
      context,
      listen: true,
    );
    final controladorReserva = Provider.of<ControladorReserva>(
      context,
      listen: false,
    );
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await controladorConf.Reglas();
    });
    return Scaffold(
      appBar: AppBarWidget(
        titulo: Text(
          "Detalles de la Reserva",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        button: !reservaNueva
            ? IconButton(
                onPressed: () async {
                  await controladorAlojamiento.listarAlojamientos();
                  controladorReserva.listaModeloAlojamiento =
                      controladorAlojamiento.modeloAlojamiento;
                  await controladorReserva.obtenerReservas(
                    modeloReserva.entidadAlojamiento.id,
                  );
                  if (context.mounted) {
                    final modeloAlojamiento = ModeloAlojamiento(
                      nombre: modeloReserva.entidadAlojamiento.nombre,
                      direccion: modeloReserva.entidadAlojamiento.direccion,
                      id: modeloReserva.entidadAlojamiento.id,
                    );
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NuevaReservaPage(
                          nombreAlojamiento: modeloAlojamiento,
                          editar: true,
                          modeloReservaParametro: modeloReserva,
                        ),
                      ),
                    );
                  }
                },
                icon: Icon(Icons.edit),
              )
            : SizedBox.shrink(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Screenshot(
              controller: screenshotController,
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título de la cabaña
                    Text(
                      "🏫 ${modeloReserva.entidadAlojamiento.nombre}",
                      softWrap: true,
                      style: TextStyle(
                        fontSize: 20.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Primer Card: Detalles de entrada y salida
                    Card(
                      color: Colors.greenAccent.shade100,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            // Primera fila: Número y entrada
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Entrada",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      "${Funciones.formatDateDMY(modeloReserva.fechaLLegada)} ${Funciones.stringToAmPm(modeloReserva.horaLlegada)}",
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade200,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    "📅 #${modeloReserva.fechaLLegada.day}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            // Estado de la reserva
                            Row(
                              children: [
                                const Text(
                                  "Estado: ",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.shade200,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    modeloReserva.estadoReserva,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            // Salida y nombre del cliente
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Salida",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "${Funciones.formatDateDMY(modeloReserva.fechaSalida)} ${Funciones.stringToAmPm(modeloReserva.horaSalida)}",
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        "Cliente",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        textAlign: TextAlign.end,
                                        modeloReserva.entidadCliente.nombre,
                                        softWrap: true,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            // Iconos de ocupación
                            Row(
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.dark_mode),
                                    SizedBox(width: 4),
                                    Text(
                                      modeloReserva.fechaSalida
                                          .difference(
                                            modeloReserva.fechaLLegada,
                                          )
                                          .inDays
                                          .toString(),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 16),
                                Row(
                                  children: [
                                    Icon(Icons.person),
                                    SizedBox(width: 4),
                                    Text(
                                      (int.parse(
                                                modeloReserva.cantidadAdultos,
                                              ) +
                                              int.parse(
                                                modeloReserva.cantidadNinos,
                                              ))
                                          .toString(),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 16),

                                if (modeloReserva.traeMascotas)
                                  Icon(Icons.pets),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(1.sw),
                          topLeft: Radius.circular(1.sw),
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 12.h,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "💰 Cobro",
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _celdaFooter(
                                "Importe Total",
                                "\S/${modeloReserva.importeTotal}",
                                Colors.blue,
                              ),
                              _celdaFooter(
                                "Señal / Adelanto",
                                "\S/${modeloReserva.adelanto}",
                                Colors.orange,
                              ),
                              _celdaFooter(
                                "Pendiente",
                                "\S/${modeloReserva.pendiente}",
                                Colors.red,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Segundo Card: Datos de contacto
                    Card(
                      color: Colors.white,

                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Datos de Contacto",
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Icon(Icons.person_outline),
                                SizedBox(width: 8),
                                Text(modeloReserva.entidadCliente.nombre),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.phone),
                                SizedBox(width: 8),
                                Text(modeloReserva.entidadCliente.telefono),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.email_outlined),
                                SizedBox(width: 8),
                                Text(modeloReserva.entidadCliente.email),
                              ],
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    Text(
                      "Observaciones a Tener en Cuenta",
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),
                    const SizedBox(height: 8),

                    Text(
                      controladorConf.regla,
                      style: TextStyle(fontSize: 12.sp),
                    ),
                    const SizedBox(height: 8),
                    Image.asset(
                      "assets/images/logo.jpg",
                      width: double.infinity,
                      height: 170.h,
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
            if (!reservaNueva) ...[
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12),
                margin: EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50, // color de fondo suave
                  border: Border.all(color: Colors.blue.shade200), // borde
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "⚠️ ${modeloReserva.observaciones}",
                      style: TextStyle(fontSize: 12.sp, color: Colors.blue.shade900),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "⚠️ ${modeloReserva.notaCliente}",
                      style: TextStyle(fontSize: 12.sp, color: Colors.blue.shade900),
                    ),
                  ],
                ),
              ),
            ],

            GestureDetector(
              onTap: () async {
                final respuesta = await Confirmacion.showConfirmDialog(
                  context,
                  title: "Confirmación",
                  message: "¿Deseas Generar la Imagen?",
                );
                if (respuesta != null && respuesta == true) {
                  await Funciones.capturarImagen(
                    screenshotController,
                    modeloReserva.entidadCliente.nombre,
                  );
                  if (context.mounted) {
                    Mensaje.showConfirmDialog(
                      context,
                      title: "Confirmación 💫",
                      message:
                          "Imagen Generada Correctamente, ubicala en tu Galeria.",
                    );
                  }
                }
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 16.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
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
                      const Icon(Icons.image, color: Colors.white),
                      SizedBox(width: 8.w),
                      Text(
                        "Generar Imagen",
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
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () async {
                final respuesta = await Confirmacion.showConfirmDialog(
                  context,
                  title: "Confirmación",
                  message: "¿Deseas Compartir la Imagen?",
                );
                if (respuesta != null && respuesta == true) {
                  final bytes = await Funciones.ImagenEnBytes(
                    screenshotController,
                  );
                  await Funciones.compartirImagen(
                    context,
                    bytes!,
                    modeloReserva.entidadCliente.nombre,
                  );
                }
              },
              child: Container(
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
                        FontAwesomeIcons.whatsapp,
                        color: Colors.white,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        "Compartir Imagen",
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
        ),
      ),
    );
  }

  Widget _celdaFooter(String label, String valor, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14.sp, color: Colors.black),
        ),
        SizedBox(height: 4.h),
        Text(
          valor,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
