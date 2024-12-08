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
                // Menú en la izquierda
                Builder(
                  builder: (BuildContext context) {
                    return IconButton(
                      icon: const Icon(Icons.menu, color: Colors.white),
                      onPressed: () {
                        Scaffold.of(context).openDrawer(); // Abre el Drawer
                      },
                    );
                  },
                ),
                // Título centrado
                const Text(
                  'Pedidos Pendientes',
                  style: TextStyle(
                    color: Colors.white, // Texto blanco
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                // Logo en la derecha
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Image.asset(
                    'assets/img/logo.jpg', // Ruta de la imagen del logo
                    width: 50,
                    height: 45,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.black,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 80,
                    height: 70,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Image.asset(
                      'assets/img/logo.jpg', // Ruta de la imagen del logo
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Menú Principal',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Inicio'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/');
              },
            ),
            ListTile(
              leading: const Icon(Icons.fastfood),
              title: const Text('Gestión de Platos'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/gestion_platos');
              },
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Gestión de Clientes'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/gestion_clientes');
              },
            ),
          ],
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
                      color: Colors.grey[600],
                    ),
                    floatingLabelStyle: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: primaryColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.grey[600],
                    ),
                  ),
                  style: const TextStyle(
                    backgroundColor: Colors.transparent,
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
                  itemCount: 10, // Número de pedidos
                  itemBuilder: (context, index) {
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: greenColor,
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
