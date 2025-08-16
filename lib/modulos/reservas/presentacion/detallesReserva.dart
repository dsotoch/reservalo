import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reservalo/core/widgets/appBar.dart';

class DetallesReserva extends StatelessWidget {
  const DetallesReserva({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        button: IconButton(onPressed: (){}, icon: Icon(Icons.edit)),
        titulo: Text(
          "Detalles de la Reserva",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título de la cabaña
            Text(
              "🏫 Cabaña Los Pinos",
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
                          children: const [
                            Text(
                              "Entrada",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 4),
                            Text("12/08/2025 14:00"),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade200,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            "📅 #15",
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
                          child: const Text(
                            "Pendiente",
                            style: TextStyle(fontWeight: FontWeight.bold),
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
                          children: const [
                            Text(
                              "Salida",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 4),
                            Text("15/08/2025 10:00"),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: const [
                            Text(
                              "Cliente",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 4),
                            Text("Juan Pérez"),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Iconos de ocupación
                    Row(
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.night_shelter_outlined),
                            SizedBox(width: 4),
                            Text("2"),
                          ],
                        ),
                        const SizedBox(width: 16),
                        Row(
                          children: const [
                            Icon(Icons.person),
                            SizedBox(width: 4),
                            Text("4"),
                          ],
                        ),
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
              topLeft: Radius.circular(1.sw)
            )

          ),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("💰 Cobro",style: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.bold),),
              const SizedBox(height: 8,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _celdaFooter("Importe Total", "\$500.00", Colors.blue),
                  _celdaFooter("Señal / Adelanto", "\$150.00", Colors.orange),
                  _celdaFooter("Pendiente", "\$350.00", Colors.red),
                ],
              ),
            ],
          )
        ),
            const SizedBox(height: 16,),
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
                      children: const [
                        Icon(Icons.person_outline),
                        SizedBox(width: 8),
                        Text("Juan Pérez"),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: const [
                        Icon(Icons.phone),
                        SizedBox(width: 8),
                        Text("+51 987654321"),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: const [
                        Icon(Icons.email_outlined),
                        SizedBox(width: 8),
                        Text("juan.perez@email.com"),
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
              "El cliente trae mascotas. Prefiere habitación con vista al jardín. Necesita cuna para bebé.",
              style: TextStyle(fontSize: 12.sp),
            ),
            const SizedBox(height: 8),
            Image.asset("assets/images/cabana.jpg"),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {},
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
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.black,
          ),
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

