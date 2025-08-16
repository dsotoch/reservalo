import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class IndexAlojamiento extends StatelessWidget {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController direccionController = TextEditingController();

  final List<Map<String, String>> alojamientos = [
    {"nombre": "Cabaña El Paraíso", "ubicacion": "Huancaquito Bajo 125"},
    {"nombre": "Casa de Playa", "ubicacion": "Costa Brava"},
    {"nombre": "Hostal Central", "ubicacion": "Ciudad Capital"},
    {"nombre": "Villa Campestre", "ubicacion": "Montañas Verdes"},
  ];

  @override
  Widget build(BuildContext context) {
    return
    Padding(
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
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Guardado con éxito")),
                        );
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

             GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.all(5),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.85,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: alojamientos.length,
                itemBuilder: (context, index) {
                  final alojamiento = alojamientos[index];
                  return Card(
                    color: Colors.white,

                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: BorderSide(color: Colors.blueAccent,width: 2),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.home, size: 40.w, color: Colors.blueAccent),
                          SizedBox(height: 10),
                          Text(
                            alojamiento["nombre"]!,
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
                              Icon(Icons.location_on, size: 14.w, color: Colors.redAccent),
                              SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  alojamiento["ubicacion"]!,
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
                          ElevatedButton(onPressed: (){},style:
                            ButtonStyle(
                              backgroundColor: WidgetStateColor.resolveWith((states) {
                                if(states.contains(WidgetState.pressed)){
                                  return Colors.red.shade300;
                                }
                                return Colors.redAccent;
                              },
                              )
                            ), child: Text("Eliminar",style: TextStyle(color: Colors.white),),)

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
