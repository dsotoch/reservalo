import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reservalo/core/aplicacion/funciones.dart';
import 'package:reservalo/modulos/configuraciones/presentacion/controlador/controladorConfi.dart';

class Configuracion extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _reglasController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final controladorConf = Provider.of<ControladorConf>(context, listen: true);
    _reglasController.text=controladorConf.regla.toString();
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Ingrese las reglas:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _reglasController,
                maxLines: 10,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.rule, color: Colors.blueAccent),
                  hintText: 'Escribe las reglas aquí...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.blue.shade50,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese las reglas';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text('Guardar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    Funciones.ocultarTeclado(context);
                    final resp = await Funciones.post("reglas-guardar", {
                      "reglas": _reglasController.text,
                    });
                   await controladorConf.Reglas();
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(resp["message"])));

                  }
                },
              ),
              const SizedBox(height: 10),
              if (_reglasController.text.isNotEmpty)
                Text(
                  'Reglas actuales:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
              if (_reglasController.text.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    _reglasController.text,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
