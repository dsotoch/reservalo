import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:reservalo/modulos/alojamiento/datos/repositorios/repositorioAlojamiento.dart';
import 'package:reservalo/modulos/alojamiento/presentacion/controladores/controladorAlojamiento.dart';
import 'package:reservalo/modulos/clientes/datos/repositorios/repositorioCliente.dart';
import 'package:reservalo/modulos/clientes/presentacion/controladores/controladorCliente.dart';
import 'package:reservalo/modulos/configuraciones/presentacion/controlador/controladorConfi.dart';
import 'package:reservalo/modulos/inicio/presentacion/paginas/index.dart';
import 'package:reservalo/modulos/inicio/presentacion/paginas/splash.dart';
import 'package:reservalo/modulos/reservas/datos/repositorios/repositorioReserva.dart';
import 'package:reservalo/modulos/reservas/presentacion/controladores/controladorReserva.dart';

import 'core/controladores/controladorNavegacion.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting("es-ES",null);


  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => ControladorInicio(),),
        ChangeNotifierProvider(create: (context) => ControladorCliente(repositorioCliente: RepositorioCliente()),),
        ChangeNotifierProvider(create: (context) => ControladorAlojamiento(repositorioAlojamiento: RepositorioAlojamiento()),),
        ChangeNotifierProvider(create: (context) => ControladorReserva(repositorioReserva: RepositorioReserva(),controladorCliente: ControladorCliente(repositorioCliente: RepositorioCliente())),),
        ChangeNotifierProvider(create: (context) => ControladorConf())

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
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('es', 'ES'), // Español
        ],
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: Splash(),
      ),
    );
  }
}
