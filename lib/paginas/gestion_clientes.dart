import 'package:flutter/material.dart';

class PantallaGestionClientes extends StatelessWidget {
  const PantallaGestionClientes({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Colors.black; // Encabezado negro
    final List<Map<String, dynamic>> clientes = [
      {
        'cedula': '12345678',
        'nombre': 'Juan Pérez',
        'direccion': 'Av. Libertador 123',
        'telefono': '123456789'
      },
      {
        'cedula': '87654321',
        'nombre': 'Ana López',
        'direccion': 'Calle Ficticia 456',
        'telefono': '987654321'
      },
      {
        'cedula': '11223344',
        'nombre': 'Carlos García',
        'direccion': 'Calle Real 789',
        'telefono': '112233445'
      },
    ];

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80), // Altura personalizada
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: primaryColor, // Fondo negro
          child: SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Botón de retroceso
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context); // Vuelve a la página anterior
                  },
                ),
                // Título centrado
                const Text(
                  'Gestión de Clientes',
                  style: TextStyle(
                    color: Colors.white, // Texto blanco
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                // Logo en la derecha
                MouseRegion(
                  cursor: SystemMouseCursors.click, // Cursor dedito
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/'); // Redirige a inicio
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
          children: [
            // Barra de búsqueda
            TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                labelText: 'Buscar cliente...',
                labelStyle: TextStyle(color: Colors.grey[600]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.black),
                ),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
              ),
              onChanged: (value) {
                // Lógica para filtrar la lista de clientes
              },
            ),

            const SizedBox(height: 10),
            // Lista de clientes
            Expanded(
              child: ListView.builder(
                itemCount: clientes.length,
                itemBuilder: (context, index) {
                  final cliente = clientes[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      title: Text(
                        cliente['nombre'], // Mostramos el nombre del cliente
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Cédula: ${cliente['cedula']}'),
                          Text('Dirección: ${cliente['direccion']}'),
                          Text('Teléfono: ${cliente['telefono']}'),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min, // Minimiza el tamaño
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.black),
                            onPressed: () {
                              // Lógica para editar el cliente

                              print('Editar cliente: ${cliente['nombre']}');
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.black),
                            onPressed: () {
                              // Lógica para eliminar el cliente

                              print('Eliminar cliente: ${cliente['nombre']}');
                            },
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
          Navigator.pushNamed(
              context, '/agregar_cliente'); // Navegar a agregar cliente
        },
        backgroundColor: const Color.fromARGB(255, 44, 164, 50),
        child: const Icon(Icons.add),
        tooltip: 'Agregar Cliente',
      ),
    );
  }
}
