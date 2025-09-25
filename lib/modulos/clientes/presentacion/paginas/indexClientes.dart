import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:reservalo/core/aplicacion/funciones.dart';
import 'package:reservalo/core/widgets/confirmacion.dart';
import 'package:reservalo/modulos/clientes/datos/modelos/modeloCliente.dart';
import 'package:reservalo/modulos/clientes/presentacion/controladores/controladorCliente.dart';

class IndexClientes extends StatelessWidget {
  IndexClientes({super.key});

  final _formkey = GlobalKey<FormState>();
  void _mostrarModalNuevoCliente(
    BuildContext context,
    String idcliente,
    String nombre,
    String dni,
    String telefono,
    String email,
  ) {
    final idController = TextEditingController(text: idcliente);
    final nombreController = TextEditingController(text: nombre);
    final dniController = TextEditingController(text: dni);
    final telefonoController = TextEditingController(text: telefono);
    final emailController = TextEditingController(text: email);
    final controladorCliente = Provider.of<ControladorCliente>(
      context,
      listen: false,
    );
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Container(
            width: double.infinity,
            color: Colors.blueAccent,
            child: const Text(
              "Panel del Cliente",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          content: Form(
            key: _formkey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Nombres y Apellidos",
                    prefixIcon: Icon(Icons.person),
                  ),
                  onSaved: (newValue) => nombreController.text = newValue ?? '',
                  controller: nombreController,
                  validator: (value) =>
                      Funciones.validacionText("Nombres Y Apellidos", value),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "DNI",
                    prefixIcon: Icon(Icons.badge),
                  ),
                  onSaved: (newValue) => dniController.text = newValue ?? '',
                  controller: dniController,
                  validator: (value) => Funciones.validacionText("DNI", value),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Telefono",
                    prefixIcon: Icon(Icons.phone_iphone),
                  ),
                  onSaved: (newValue) =>
                      telefonoController.text = newValue ?? '',
                  controller: telefonoController,
                  validator: (value) =>
                      Funciones.validacionText("Telefono", value),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    prefixIcon: Icon(Icons.email),
                  ),
                  onSaved: (newValue) => emailController.text = newValue ?? '',
                  controller: emailController,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Cancelar",
                style: TextStyle(color: Colors.black),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formkey.currentState!.validate()) {
                  _formkey.currentState?.save();
                  final modelo = ModeloCliente(
                    id: idController.value.text,
                    nombre: nombreController.value.text,
                    email: emailController.value.text,
                    dni: dniController.value.text,
                    telefono: telefonoController.value.text,
                  );
                  bool existe = controladorCliente.listaClientes.any((c) =>
                  (c.dni == modelo.dni || c.email == modelo.email || c.telefono == modelo.telefono) &&
                      c.id != idController.value.text
                  );
                  Funciones.ocultarTeclado(context);

                  if (existe) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "⚠️ Ya Existe un Cliente con alguno de los Datos Ingresados.",
                        ),
                        duration: Duration(seconds: 2),
                      ),
                    );
                    return;
                  }
                  final respuesta = await controladorCliente.crearCliente(
                    modelo,
                  );
                  if (respuesta) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("💫 Cliente registrado Correctamente."),
                          duration: Duration(seconds: 2),
                        ),
                      );
                      Navigator.pop(context);
                    }
                  } else {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("⚠️ Error al registrar."),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  }
                  nombreController.clear();
                  emailController.clear();
                  dniController.clear();
                  telefonoController.clear();
                  idController.clear();
                }
              },
              style: ButtonStyle(
                foregroundColor: WidgetStateProperty.all(Colors.white),
                backgroundColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.pressed)) {
                    return Colors.green.shade400;
                  }
                  return Colors.green;
                }),
              ),
              child: const Text("Guardar"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final controladorCliente = Provider.of<ControladorCliente>(context);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await controladorCliente.listarClientes();
      if (controladorCliente.listaClientes.isEmpty) {
        controladorCliente.filtrarClientes("");
      }
    });

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          // BUSCADOR Y BOTÓN
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Buscar cliente...",
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onChanged: (value) {
                    controladorCliente.filtrarClientes(value);
                  },
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton.icon(
                onPressed: () => _mostrarModalNuevoCliente(
                  context,
                  controladorCliente.idcliente,
                  controladorCliente.nombre,
                  controladorCliente.dni,
                  controladorCliente.telefono,
                  controladorCliente.email,
                ),
                icon: const Icon(Icons.add),
                label: const Text("Nuevo"),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(100.w, 50.h),
                  foregroundColor: Colors.white,
                  backgroundColor: WidgetStateColor.resolveWith((states) {
                    if (states.contains(WidgetState.pressed)) {
                      return Colors.green.shade400;
                    } else {
                      return Colors.green.shade800;
                    }
                  }),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // LISTA DE CLIENTES
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: controladorCliente.filtroListaClientes.length,
            itemBuilder: (context, index) {
              final cliente = controladorCliente.filtroListaClientes[index];
              return Card(
                color: Colors.lightGreen.shade200,
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 5),
                child: ListTile(
                  leading: const Icon(Icons.person, color: Colors.blue),
                  title: Text("${cliente.nombre} (${cliente.dni})"),
                  subtitle: Text(
                    "📲 ${cliente.telefono} *** ${cliente.email} 📧",
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.black),
                        onPressed: () => _mostrarModalNuevoCliente(
                          context,
                          cliente.id,
                          cliente.nombre,
                          cliente.dni,
                          cliente.telefono,
                          cliente.email,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          final validacion=await Confirmacion.showConfirmDialog(context, title: "¿⚠️Estas Seguro de Eliminar el Registro?", message: "Cliente a eliminar ${cliente.nombre}");
                           if(validacion!=null && !validacion){
                             return;
                           }
                          final respuesta = await controladorCliente
                              .eliminarCliente(cliente.id);

                          if (respuesta["status"] == "success") {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("💫 ${respuesta["data"]}"),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }
                            await controladorCliente.listarClientes();
                          } else {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("💫 ${respuesta["message"]}"),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }
                          }
                        },
                      ),
                    ],
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
