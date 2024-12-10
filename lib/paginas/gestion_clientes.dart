import 'package:flutter/material.dart';
import 'package:formulario_basico/daos/dao_clientes.dart';
import 'package:formulario_basico/dominio/clientes.dart';

class PantallaGestionClientes extends StatefulWidget {
  const PantallaGestionClientes({super.key});

  @override
  State<PantallaGestionClientes> createState() =>
      _PantallaGestionClientesState();
}

class _PantallaGestionClientesState extends State<PantallaGestionClientes> {
  final DaoClientes _daoClientes = DaoClientes();
  List<Cliente> _clientes = [];

  @override
  void initState() {
    super.initState();
    _cargarClientes();
  }

  // Método para cargar los clientes desde la base de datos
  Future<void> _cargarClientes() async {
    final clientes = await _daoClientes
        .getClientes(); // Asegúrate de que getClientes() esté bien implementado
    setState(() {
      _clientes = clientes;
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Colors.black;

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
                    Navigator.pop(context); // Volver a la página anterior
                  },
                ),
                const Text(
                  'Gestión de Clientes',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
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

            // Mostrar clientes
            Expanded(
              child: _clientes.isEmpty
                  ? const Center(
                      child:
                          CircularProgressIndicator()) // Mostrar cargando mientras se obtienen los datos
                  : ListView.builder(
                      itemCount: _clientes.length,
                      itemBuilder: (context, index) {
                        final cliente = _clientes[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            title: Text(
                              cliente.nombre,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Cédula: ${cliente.cedula}'),
                                Text('Dirección: ${cliente.direccion}'),
                                Text('Teléfono: ${cliente.telefono}'),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.visibility,
                                      color: Colors.black),
                                  tooltip: 'Ver ficha',
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/ficha_cliente',
                                      arguments: cliente,
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: Colors.black),
                                  tooltip: 'Editar',
                                  onPressed: () {
                                    // Lógica para editar el cliente
                                    print('Editar cliente: ${cliente.nombre}');
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.black),
                                  tooltip: 'Eliminar',
                                  onPressed: () {
                                    // Lógica para eliminar el cliente
                                    print(
                                        'Eliminar cliente: ${cliente.nombre}');
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
        onPressed: () async {
          // Navegar a agregar cliente
          final resultado = await Navigator.pushNamed(
            context,
            '/agregar_cliente',
          );

          // Si el resultado es verdadero, recargar los clientes
          if (resultado == true) {
            _cargarClientes();
          }
        },
        backgroundColor: const Color.fromARGB(255, 44, 164, 50),
        child: const Icon(Icons.add),
        tooltip: 'Agregar Cliente',
      ),
    );
  }
}
