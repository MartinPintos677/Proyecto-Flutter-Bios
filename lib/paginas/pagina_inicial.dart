import 'package:flutter/material.dart';

class PantallaInicial extends StatelessWidget {
  const PantallaInicial({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Colors.black; // Header en negro
    final Color backgroundColor = Colors.grey[100]!; // Fondo general
    const Color greenColor = Color.fromARGB(255, 44, 164, 50);

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
                // Logo en la izquierda
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.white,
                        width: 2), // Borde blanco alrededor
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Image.asset(
                    'assets/img/logo.jpg',
                    width: 50,
                    height: 50,
                  ),
                ),
                // Título centrado
                const Flexible(
                  child: Text(
                    'Pedidos Pendientes',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white, // Texto blanco
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                // Menú en la derecha
                IconButton(
                  icon: const Icon(Icons.menu, color: Colors.white),
                  onPressed: () {
                    // Acción del menú
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        color: backgroundColor, // Fondo gris claro
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // Barra de búsqueda
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextField(
                  cursorColor: Colors.grey[600],
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white, // Fondo blanco
                    labelText: 'Buscar pedido por cliente',
                    labelStyle: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600], // Texto gris suave
                    ),
                    floatingLabelStyle: const TextStyle(
                      fontSize: 16,
                      color: Colors.black, // Texto flotante negro
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: primaryColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          color: Colors
                              .grey), // Borde gris cuando no está enfocado
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          color: Colors.black), // Borde negro al enfocar
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.grey[600], // Ícono gris suave
                    ),
                  ),
                  style: const TextStyle(
                    backgroundColor:
                        Colors.transparent, // Prevenir cambio del fondo
                  ),
                  onChanged: (value) {
                    // Lógica de búsqueda
                  },
                ),
              ),
              const SizedBox(height: 10),
              // Listado de pedidos
              Expanded(
                child: ListView.builder(
                  itemCount: 10, // Reemplazar con el tamaño real de la lista
                  itemBuilder: (context, index) {
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: greenColor, // Azul suave
                          child: Text(
                            '#${index + 1}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(
                          'Pedido #$index',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        subtitle: Text(
                          'Cliente: Juan Pérez\nTotal: \$1500',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          // Navegar a detalles del pedido
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Acción para agregar un nuevo pedido
        },
        backgroundColor: greenColor,
        child: const Icon(Icons.add),
        tooltip: 'Nuevo Pedido',
      ),
    );
  }
}
