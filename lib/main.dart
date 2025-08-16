import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:reservalo/modulos/clientes/presentacion/controladores/controladorCliente.dart';
import 'package:reservalo/modulos/inicio/presentacion/paginas/index.dart';

import 'core/controladores/controladorNavegacion.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting("es-ES",null);


  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => ControladorInicio(),),
        ChangeNotifierProvider(create: (context) => ControladorCliente(),)

      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: Index(),
      ),
    );
  }
}
