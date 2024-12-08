import 'package:flutter/material.dart';
import 'package:formulario_basico/paginas/paginas.dart'; // Importa todas las páginas desde paginas.dart

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
        primaryColor: Colors.black, // Color global para encabezados
        scaffoldBackgroundColor: Colors.grey[100], // Fondo general
        textTheme: const TextTheme(
          titleLarge:
              TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          bodyMedium: TextStyle(color: Colors.grey, fontSize: 14),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black, // Encabezado negro
          foregroundColor: Colors.white, // Texto blanco
          elevation: 0,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color.fromARGB(255, 44, 164, 50),
          foregroundColor: Colors.white, // Ícono blanco
        ),
      ),
      initialRoute: '/', // Ruta inicial
      routes: {
        '/': (context) => const PantallaInicial(),
        '/gestion_platos': (context) => const PantallaGestionPlatos(),
        '/agregar_plato': (context) => const PantallaAgregarPlato(),
        '/gestion_clientes': (context) => const PantallaGestionClientes(),
        '/agregar_cliente': (context) => const PantallaAgregarCliente(),
      },
    );
  }
}
