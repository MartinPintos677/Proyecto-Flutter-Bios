import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
        .where((pedido) => _estadoSeleccionado == "Pendiente"
            ? pedido.estadoEntrega == _estadoSeleccionado
            : true) // Muestra todos los pedidos si no es Pendiente
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
            .where((pedido) =>
                (pedido.clienteCedula.toLowerCase())
                    .contains(query.toLowerCase()) ||
                (pedido.clienteNombre?.toLowerCase() ?? "")
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

// Método para mostrar el cuadro de diálogo de confirmación (para cualquier acción)
  Future<bool> _mostrarDialogoConfirmacion(
      BuildContext context, String titulo, String mensaje) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(titulo),
              content: Text(mensaje),
              actions: <Widget>[
                TextButton(
                  child: const Text('No'),
                  onPressed: () {
                    Navigator.of(context).pop(false); // Acción negativa
                  },
                ),
                TextButton(
                  child: const Text('Sí'),
                  onPressed: () {
                    Navigator.of(context).pop(true); // Acción positiva
                  },
                ),
              ],
            );
          },
        ) ??
        false; // Asegura que el valor por defecto sea false si el diálogo se cierra sin elección
  }

  // Método para manejar el evento de retroceso
  Future<bool> _onWillPop() async {
    // Mostrar el cuadro de diálogo para confirmar salida
    bool confirmExit = await _mostrarDialogoConfirmacion(
        context,
        'Confirmar salida',
        '¿Estás seguro de que deseas salir de la aplicación?');

    // Si el usuario confirma la salida, se cierra la aplicación
    if (confirmExit) {
      SystemNavigator.pop(); // Cierra la aplicación
    }

    return confirmExit;
  }

  void _agregarPedido(BuildContext context) async {
    final resultado = await Navigator.of(context).pushNamed('/agregar_pedidos');

    if (resultado != null && resultado == true) {
      _cargarPedidos(); // Recargar la lista si se agregó un pedido
    }
  }

  void mostrarSnackBar(mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(mensaje, textAlign: TextAlign.center),
      behavior: SnackBarBehavior.floating,
      backgroundColor: const Color.fromARGB(128, 64, 64, 64),
      shape: const StadiumBorder(),
      duration: const Duration(seconds: 2),
    ));
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Colors.black;
    final Color backgroundColor = Colors.grey[100]!;
    const Color greenColor = Color.fromARGB(255, 44, 164, 50);

    return WillPopScope(
      onWillPop: _onWillPop, // evento de retroceso
      child: Scaffold(
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
                    {"value": "Todos", "label": "Todos los Pedidos"},
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
                    labelText: 'Buscar por cédula o nombre de cliente',
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
                                              if (pedido.fechaHoraRealizacion
                                                      .day ==
                                                  DateTime.now().day) {
                                                Navigator.pushNamed(
                                                  context,
                                                  '/agregar_pedidos',
                                                  arguments: pedido,
                                                );
                                              } else {
                                                mostrarSnackBar(
                                                    "Los pedidos viejos no se pueden editar");
                                              }
                                            },
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.delete,
                                                color: Colors.black),
                                            onPressed: () async {
                                              // Mostrar el cuadro de diálogo para confirmar eliminación
                                              bool confirmDelete =
                                                  await _mostrarDialogoConfirmacion(
                                                      context,
                                                      'Eliminar Pedido',
                                                      '¿Estás seguro de que deseas eliminar este pedido?');
                                              if (confirmDelete) {
                                                try {
                                                  await _daoPedidos
                                                      .eliminarPedido(
                                                          pedido.idPedido!);
                                                  // Recargar los pedidos después de la eliminación
                                                  _cargarPedidos();
                                                  mostrarSnackBar(
                                                      'Pedido eliminado exitosamente');
                                                } catch (e) {
                                                  mostrarSnackBar(
                                                      'Error al eliminar el pedido');
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
      ),
    );
  }
}
