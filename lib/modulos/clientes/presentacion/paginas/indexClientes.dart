import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:reservalo/core/aplicacion/funciones.dart';
import 'package:reservalo/modulos/clientes/datos/modelos/modeloCliente.dart';
import 'package:reservalo/modulos/clientes/presentacion/controladores/controladorCliente.dart';

class IndexClientes extends StatelessWidget {
  final List datos = [
    {
      "id": "1",
      "nombre": "Juan Pérez",
      "telefono": "987654321",
      "dni": "12345678",
    },
    {
      "id": "2",
      "nombre": "María López",
      "telefono": "987123456",
      "dni": "87654321",
    },
    {
      "id": "3",
      "nombre": "Carlos García",
      "telefono": "999888777",
      "dni": "11223344",
    },
    {
      "id": "4",
      "nombre": "Ana Torres",
      "telefono": "911222333",
      "dni": "44332211",
    },
  ];

  IndexClientes({super.key});

  final _formkey = GlobalKey<FormState>();
  void _mostrarModalNuevoCliente(
    BuildContext context,
    String idcliente,
    String nombre,
    String dni,
    String telefono,
  ) {
    final idController = TextEditingController(text: idcliente);
    final nombreController = TextEditingController(text: nombre);
    final dniController = TextEditingController(text: dni);
    final telefonoController = TextEditingController(text: telefono);

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
                    labelText: "Nombre",
                    prefixIcon: Icon(Icons.person),
                  ),
                  onSaved: (newValue) => nombreController.text = newValue ?? '',
                  controller: nombreController,
                  validator: (value) =>
                      Funciones.validacionText("Nombre", value),
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
              onPressed: () {
                if (_formkey.currentState!.validate()) {
                  _formkey.currentState?.save();

                  Navigator.pop(context);
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

    // Inicializar la lista solo una vez
    if (controladorCliente.listaClientes.isEmpty) {
      controladorCliente.listaClientes = datos
          .map((e) => ModeloCliente.fromMap(e))
          .toList();
      controladorCliente.filtrarClientes(""); // mostrar todos
    }

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
                color: Colors.lightBlue.shade50,
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 5),
                child: ListTile(
                  leading: const Icon(Icons.person, color: Colors.blue),
                  title: Text("${cliente.nombre} (${cliente.dni})"),
                  subtitle: Text(cliente.telefono),
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
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          // Eliminar cliente
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
