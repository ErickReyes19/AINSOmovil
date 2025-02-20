// ignore_for_file: empty_catches, avoid_print, depend_on_referenced_packages
import 'package:accesorios_industriales_sosa/providers/backup.provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:accesorios_industriales_sosa/cosntans.dart';
import 'package:accesorios_industriales_sosa/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/providers.dart';
import 'services/localdatabase.service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Inicializar Flutter

  final databaseService = LocalDataBaseService.db;

  try {
    final database = await databaseService.initDataBase();
    final tables = await database.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table';",
    );

    // Mostrar el nombre de las tablas en la consola
    for (final table in tables) {
      print('Tabla creada: ${table['name']}');
    }

    runApp(const MyApp());
  } catch (e) {}
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => ClientesProvider()),
        ChangeNotifierProvider(create: (context) => FacturaProvider()),
        ChangeNotifierProvider(create: (context) => BackupProvider()),
      ],
      child: MaterialApp(
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('es', 'ES')],
        locale: const Locale('es', 'ES'),
        debugShowCheckedModeBanner: false,
        scaffoldMessengerKey: snackbarKey,
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            backgroundColor: Color.fromARGB(255, 255, 255, 255),
          ),
          bottomSheetTheme: const BottomSheetThemeData(
            backgroundColor: Color(0xffF2F2F2),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff312E5C),
            ),
          ),
          colorScheme: const ColorScheme(
            brightness: Brightness.light,
            primary: Color(0xFF0A3D91), // Azul Profundo
            onPrimary: Colors.white, // Contraste en azul

            secondary: Color(0xFF0ABAB5), // Naranja vibrante
            onSecondary: Colors.white, // Texto claro en naranja

            error: Color(0xFFD72638), // Rojo vibrante
            onError: Colors.white,

            surface: Color(0xFFFFFFFF), // Fondo blanco limpio
            onSurface: Color(0xFF333333), // Texto oscuro
            onSurfaceVariant: Color(0xFF666666), // Texto secundario gris oscuro
          ),
        ),
        title: 'Material App',
        home: const HomeScreen(),
      ),
    );
  }
}
