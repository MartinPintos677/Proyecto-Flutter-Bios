import 'package:flutter/material.dart';
import 'package:formulario_basico/daos/dao_pedidos.dart';
import 'package:formulario_basico/daos/dao_clientes.dart';
import 'package:formulario_basico/dominio/pedido.dart';
import 'package:formulario_basico/paginas/agregar_pedidos.dart';

class PantallaInicial extends StatefulWidget {
  const PantallaInicial({super.key});

  @override
  State<PantallaInicial> createState() => _PantallaInicialState();
}

class _PantallaInicialState extends State<PantallaInicial> {
  final DaoPedidos _daoPedidos = DaoPedidos();
  final DaoClientes _daoClientes = DaoClientes();
  List<Pedido> _pedidos = [];
  List<Pedido> _pedidosFiltrados = [];

  @override
  void initState() {
    super.initState();
    _cargarPedidos();
  }

  Future<void> _cargarPedidos() async {
    final pedidos = await _daoPedidos.obtenerPedidos();

    // Filtrar solo los pedidos con estado "Pendiente"
    final pedidosPendientes =
        pedidos.where((pedido) => pedido.estadoEntrega == "Pendiente").toList();

    // Asociar nombre del cliente a cada pedido
    for (var pedido in pedidosPendientes) {
      final cliente =
          await _daoClientes.getClienteByCedula(pedido.clienteCedula);
      pedido.clienteNombre = cliente?.nombre ?? "Desconocido"; // Asociar nombre
    }

    setState(() {
      _pedidos = pedidosPendientes;
      _pedidosFiltrados = List.from(pedidosPendientes); // Copia para filtrar
    });
  }

  void _filtrarPedidos(String query) {
    setState(() {
      if (query.isEmpty) {
        _pedidosFiltrados = _pedidos;
      } else {
        _pedidosFiltrados = _pedidos
            .where((pedido) => pedido.clienteCedula
                .toLowerCase()
                .contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _agregarPedido(BuildContext context) async {
    final bool? result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => const PantallaAgregarPedido()),
    );

    if (result != null && result) {
      _cargarPedidos(); // Recargar la lista si se agregó un pedido
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Colors.black;
    final Color backgroundColor = Colors.grey[100]!;
    const Color greenColor = Color.fromARGB(255, 44, 164, 50);

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
                Builder(
                  builder: (BuildContext context) {
                    return IconButton(
                      icon: const Icon(Icons.menu, color: Colors.white),
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                    );
                  },
                ),
                const Text(
                  'Pedidos Pendientes',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Container(
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
              decoration: const BoxDecoration(color: Colors.black),
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
                      'assets/img/logo.jpg',
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
        color: backgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextField(
                  cursorColor: Colors.grey[600],
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelText: 'Buscar por cédula de cliente',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.grey[600],
                    ),
                  ),
                  onChanged: (value) => _filtrarPedidos(value),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 80.0),
                  child: _pedidosFiltrados.isEmpty
                      ? const Center(
                          child: Text('No hay pedidos pendientes disponibles'),
                        )
                      : ListView.builder(
                          itemCount: _pedidosFiltrados.length,
                          itemBuilder: (context, index) {
                            final pedido = _pedidosFiltrados[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0, vertical: 8.0),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: greenColor,
                                      child: Text(
                                        '#${pedido.idPedido}',
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Cédula: ${pedido.clienteCedula}',
                                            style: TextStyle(
                                              color: Colors.grey[800],
                                              fontSize: 14,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '${pedido.clienteNombre}',
                                            style: TextStyle(
                                              color: Colors.grey[800],
                                              fontSize: 14,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Total: \$${pedido.importeTotal.toStringAsFixed(2)}',
                                            style: TextStyle(
                                              color: Colors.grey[800],
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.visibility,
                                              color: Colors.black),
                                          onPressed: () {
                                            print(
                                                'Ver detalles del pedido ${pedido.idPedido}');
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.edit,
                                              color: Colors.black),
                                          onPressed: () {
                                            print(
                                                'Editar pedido ${pedido.idPedido}');
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete,
                                              color: Colors.black),
                                          onPressed: () {
                                            print(
                                                'Eliminar pedido ${pedido.idPedido}');
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _agregarPedido(context),
        backgroundColor: greenColor,
        child: const Icon(Icons.add),
        tooltip: 'Nuevo Pedido',
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
