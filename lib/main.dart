import 'package:flutter/material.dart';
import 'package:formulario_basico/paginas/pagina_inicial.dart';
import 'package:formulario_basico/paginas/gestion_platos.dart'; // Nueva página

void main() {
  runApp(const Aplicacion());
}

class Aplicacion extends StatelessWidget {
  const Aplicacion({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gestión de Pedidos',
      theme: ThemeData(
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.grey[100],
        textTheme: const TextTheme(
          titleLarge:
              TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          bodyMedium: TextStyle(color: Colors.grey, fontSize: 14),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color.fromARGB(255, 44, 164, 50),
          foregroundColor: Colors.white,
        ),
      ),
      initialRoute: '/', // Ruta inicial
      routes: {
        '/': (context) => const PantallaInicial(),
        '/gestion_platos': (context) => const PantallaGestionPlatos(),
      },
    );
  }
}
