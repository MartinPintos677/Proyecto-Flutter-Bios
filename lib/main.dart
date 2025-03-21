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
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 44, 164, 50), 
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          floatingLabelStyle: TextStyle(color: Colors.green),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey, 
              width: 2.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.green,
              width: 2.0,
            ),
          ),
        ),
      ),
      initialRoute: '/', // Ruta inicial
      routes: {
        '/': (context) => const PantallaInicial(),
        '/gestion_platos': (context) => const PantallaGestionPlatos(),
        '/agregar_plato': (context) => const PantallaAgregarPlato(),
        '/gestion_clientes': (context) => const PantallaGestionClientes(),
        '/agregar_cliente': (context) => const PantallaAgregarCliente(),
        '/ficha_cliente': (context) => const PantallaFichaCliente(),
        '/ficha_plato': (context) => const PantallaFichaPlato(),
        '/agregar_pedidos': (context) => const PantallaAgregarPedido(),
        '/ficha_pedido': (context) => const PantallaFichaPedido(),
        }, 
    );
  }
}
