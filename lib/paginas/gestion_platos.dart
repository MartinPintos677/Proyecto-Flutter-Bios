import 'package:flutter/material.dart';

class PantallaGestionPlatos extends StatelessWidget {
  const PantallaGestionPlatos({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Colors.black; // Encabezado negro
    final List<Map<String, dynamic>> platos = [
      {'nombre': 'Hamburguesa', 'precio': 150.0, 'disponible': true},
      {'nombre': 'Pizza', 'precio': 200.0, 'disponible': false},
      {'nombre': 'Pasta', 'precio': 180.0, 'disponible': true},
      {'nombre': 'Ensalada', 'precio': 100.0, 'disponible': true},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Gestión de Platos',
          style: TextStyle(
            fontSize: 20, // Tamaño de fuente 20
            fontWeight: FontWeight.bold, // Opcional: Para hacerlo más destacado
          ),
        ),
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            // Barra de búsqueda
            TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                labelText: 'Buscar plato...',
                labelStyle: TextStyle(color: Colors.grey[600]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.black),
                ),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
              ),
              onChanged: (value) {
                // Lógica para filtrar la lista de platos
              },
            ),
            const SizedBox(height: 10),
            // Botón de filtro
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // Lógica para filtrar los platos disponibles hoy
                  },
                  icon: const Icon(Icons.filter_list),
                  label: const Text('Disponibles Hoy'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white, // Fondo verde
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Lista de platos
            Expanded(
              child: ListView.builder(
                itemCount: platos.length,
                itemBuilder: (context, index) {
                  final plato = platos[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor:
                            plato['disponible'] ? Colors.green : Colors.red,
                        child: Icon(
                          plato['disponible']
                              ? Icons.check
                              : Icons.close, // Ícono según disponibilidad
                          color: Colors.white,
                        ),
                      ),
                      title: Text(
                        plato['nombre'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('Precio: \$${plato['precio']}'),
                      trailing: PopupMenuButton(
                        onSelected: (value) {
                          if (value == 'edit') {
                            // Lógica para editar el plato
                          } else if (value == 'delete') {
                            // Lógica para eliminar el plato
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'edit',
                            child: Text('Editar'),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Text('Eliminar'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Acción para agregar un nuevo plato
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
        tooltip: 'Agregar Plato',
      ),
    );
  }
}
