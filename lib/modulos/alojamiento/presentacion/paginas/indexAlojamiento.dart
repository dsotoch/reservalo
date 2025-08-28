import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:reservalo/core/aplicacion/funciones.dart';
import 'package:reservalo/core/widgets/confirmacion.dart';
import 'package:reservalo/modulos/alojamiento/datos/modelos/modeloAlojamiento.dart';
import 'package:reservalo/modulos/alojamiento/presentacion/controladores/controladorAlojamiento.dart';

class IndexAlojamiento extends StatelessWidget {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController direccionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final controladorAlojamiento = Provider.of<ControladorAlojamiento>(
      context,
      listen: false,
    );
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controladorAlojamiento.listarAlojamientos();
    });
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: nombreController,
                  decoration: InputDecoration(
                    labelText: "Nombre del Alojamiento",
                    prefixIcon: Icon(Icons.home),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? "Ingrese el nombre" : null,
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: direccionController,
                  decoration: InputDecoration(
                    labelText: "Dirección",
                    prefixIcon: Icon(Icons.location_on),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? "Ingrese la dirección" : null,
                ),
                SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      ModeloAlojamiento modelo = ModeloAlojamiento(
                        nombre: nombreController.value.text,
                        direccion: direccionController.value.text,
                        id: '',
                      );
                      Funciones.ocultarTeclado(context);
                      if (await controladorAlojamiento.guardarAlojamientos(
                        modelo,
                      )) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Guardado con éxito")),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Ocurrio un error al guardar."),
                          ),
                        );
                      }

                      nombreController.clear();
                      direccionController.clear();
                    }
                  },
                  icon: Icon(Icons.save),
                  label: Text("Guardar"),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(1.sw / 2, 50),
                    backgroundColor: WidgetStateColor.resolveWith((states) {
                      if (states.contains(WidgetState.pressed)) {
                        return Colors.green.shade400;
                      }
                      return Colors.green;
                    }),
                    iconSize: 20.w,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),

          Consumer<ControladorAlojamiento>(
            builder: (context, value, child) {
              if (value.modeloAlojamiento.isEmpty) {
                return Center(child: Text("Sin Alojamientos Registrados"));
              } else {
                return GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.all(5),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.70,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: value.modeloAlojamiento.length,
                  itemBuilder: (context, index) {
                    final alojamiento = value.modeloAlojamiento[index];
                    return Card(
                      color: Colors.white,

                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: BorderSide(color: Colors.blueAccent, width: 2),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.home,
                              size: 40.w,
                              color: Colors.blueAccent,
                            ),
                            SizedBox(height: 10),
                            Text(
                              alojamiento.nombre,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14.sp,
                              ),
                              softWrap: true,
                              overflow: TextOverflow.visible,
                            ),
                            SizedBox(height: 5),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.location_on,
                                  size: 14.w,
                                  color: Colors.redAccent,
                                ),
                                SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    alojamiento.direccion,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: Colors.black,
                                    ),
                                    softWrap: true,
                                    overflow: TextOverflow.visible,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10.h),
                            ElevatedButton(
                              onPressed: () async {
                                final resp = await Confirmacion.showConfirmDialog(
                                  context,
                                  title: "⚠️Estas Seguro!!",
                                  message:
                                      "¿Deseas Eliminar ${alojamiento.nombre}?",
                                );
                                if (resp != null && resp) {
                                  final respuestahttp =
                                      await controladorAlojamiento
                                          .eliminarAlojamientos(alojamiento.id);
                                  var exito = false;
                                  if (respuestahttp["status"] == "success") {
                                    exito = true;
                                    await controladorAlojamiento
                                        .listarAlojamientos();
                                  }
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          respuestahttp[exito
                                              ? "data"
                                              : "message"],
                                        ),
                                      ),
                                    );
                                  }
                                }
                              },
                              style: ButtonStyle(
                                backgroundColor: WidgetStateColor.resolveWith((
                                  states,
                                ) {
                                  if (states.contains(WidgetState.pressed)) {
                                    return Colors.red.shade300;
                                  }
                                  return Colors.redAccent;
                                }),
                              ),
                              child: Text(
                                "Eliminar",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
