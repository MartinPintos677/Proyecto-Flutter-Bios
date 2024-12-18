import 'package:flutter/material.dart';
import 'package:formulario_basico/daos/dao_pedidos.dart';
import 'package:formulario_basico/daos/dao_clientes.dart';
import 'package:formulario_basico/dominio/pedido.dart';

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
  String _estadoSeleccionado = "Pendiente";

  @override
  void initState() {
    super.initState();
    _cargarPedidos();
  }

  Future<void> _cargarPedidos() async {
    final pedidos = await _daoPedidos.obtenerPedidos();

    final pedidosFiltrados = pedidos
        .where((pedido) => pedido.estadoEntrega == _estadoSeleccionado)
        .toList();

    for (var pedido in pedidosFiltrados) {
      final cliente =
          await _daoClientes.getClienteByCedula(pedido.clienteCedula);
      pedido.clienteNombre = cliente?.nombre ?? "Desconocido";
    }

    setState(() {
      _pedidos = pedidosFiltrados;
      _pedidosFiltrados = List.from(pedidosFiltrados);
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

  void _cambiarEstado(String nuevoEstado) {
    setState(() {
      _estadoSeleccionado = nuevoEstado;
      _cargarPedidos();
    });
  }

  Future<bool> _mostrarDialogoConfirmacion(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Confirmar eliminación'),
              content: const Text(
                  '¿Estás seguro de que deseas eliminar este pedido?'),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancelar'),
                  onPressed: () {
                    Navigator.of(context)
                        .pop(false); // Retorna false cuando se cancela
                  },
                ),
                TextButton(
                  child: const Text('Eliminar'),
                  onPressed: () {
                    Navigator.of(context).pop(
                        true); // Retorna true cuando se confirma la eliminación
                  },
                ),
              ],
            );
          },
        ) ??
        false; // Asegura que el valor por defecto sea false si el diálogo se cierra sin elección
  }

  void _agregarPedido(BuildContext context) async {
    final resultado = await Navigator.of(context).pushNamed('/agregar_pedidos');

    if (resultado != null && resultado == true) {
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
                  'Listado de Pedidos',
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
              title: const Text('Página Inicial'),
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
              DropdownButton<String>(
                value: _estadoSeleccionado,
                onChanged: (String? nuevoValor) {
                  if (nuevoValor != null) {
                    _cambiarEstado(nuevoValor);
                  }
                },
                items: [
                  {"value": "Pendiente", "label": "Pedidos Pendientes"},
                  {"value": "Entregado", "label": "Pedidos Entregados"},
                ].map((estado) {
                  return DropdownMenuItem<String>(
                    value: estado["value"],
                    child: Text(estado["label"]!),
                  );
                }).toList(),
              ),
              const SizedBox(height: 8),
              TextField(
                cursorColor: Colors.green,
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
              const SizedBox(height: 10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 80.0),
                  child: _pedidosFiltrados.isEmpty
                      ? const Center(
                          child: Text('No hay pedidos disponibles'),
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
                                            Navigator.pushNamed(
                                              context,
                                              '/ficha_pedido',
                                              arguments: pedido,
                                            );
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.edit,
                                              color: Colors.black),
                                          onPressed: () {
                                            Navigator.pushNamed(
                                              context,
                                              '/agregar_pedidos',
                                              arguments: pedido,
                                            );
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete,
                                              color: Colors.black),
                                          onPressed: () async {
                                            // Confirmación de eliminación
                                            bool confirmDelete =
                                                await _mostrarDialogoConfirmacion(
                                                    context);
                                            if (confirmDelete) {
                                              try {
                                                await _daoPedidos
                                                    .eliminarPedido(
                                                        pedido.idPedido!);
                                                // Recargar los pedidos después de la eliminación
                                                _cargarPedidos();
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                      content: Text(
                                                          'Pedido eliminado exitosamente')),
                                                );
                                              } catch (e) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                      content: Text(
                                                          'Error al eliminar el pedido')),
                                                );
                                              }
                                            }
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
        tooltip: 'Nuevo Pedido',
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
