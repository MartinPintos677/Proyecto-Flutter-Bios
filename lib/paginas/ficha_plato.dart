import 'dart:io';
import 'package:flutter/material.dart';
import 'package:formulario_basico/dominio/platos.dart';

class PantallaFichaPlato extends StatelessWidget {
  final Plato plato;

  const PantallaFichaPlato({super.key, required this.plato});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Colors.black;

    // Convertir los días disponibles (asumiendo que plato.diasDisponibles es un String con días separados por coma)
    List<String> diasDisponiblesList = plato.diasDisponibles
        .split(','); // Aquí se asume que los días están separados por comas

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: primaryColor,
          child: SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Flexible(
                  // Permite que el texto administre el ancho
                  child: Text(
                    'Ficha de ${plato.nombre}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    softWrap: false,
                  ),
                ),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/');
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Image.asset(
                        'assets/img/logo.jpg',
                        width: 50,
                        height: 45,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment
              .start, // Mantener el alineamiento a la izquierda
          children: [
            // Mostrar la foto del plato
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: plato.foto != null && plato.foto!.isNotEmpty
                    ? Image(
                        image: FileImage(File(plato
                            .foto!)), // Usamos FileImage para cargar desde un archivo local
                        width: 150,
                        height: 150,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.image_not_supported,
                            size: 150,
                            color: Colors.grey,
                          );
                        },
                      )
                    : const Icon(
                        Icons.restaurant_menu,
                        size: 150,
                        color: Colors.grey,
                      ),
              ),
            ),
            const SizedBox(height: 20),

            // Mostrar los datos del plato
            Text(
              'Nombre: ${plato.nombre}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'Precio: \$${plato.precio.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),

            // Mostrar los días disponibles
            Text(
              'Días Disponibles:',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 5),

            // Usar un Column para mostrar los días verticalmente centrados
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment
                    .center, // Centrado horizontal de los días
                children: diasDisponiblesList.map((dia) {
                  return Text(
                    dia.trim(), // Eliminar posibles espacios en blanco
                    style: const TextStyle(fontSize: 16),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 10),
            Text(
              'Estado: ${plato.activo ? "Activo" : "Inactivo"}',
              style: TextStyle(
                fontSize: 16,
                color: plato.activo ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
