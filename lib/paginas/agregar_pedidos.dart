import 'package:flutter/material.dart';
import 'package:formulario_basico/daos/dao_lineas_pedido.dart';
import 'package:formulario_basico/dominio/platos.dart';
import 'package:formulario_basico/dominio/pedido.dart';
import 'package:formulario_basico/dominio/linea_pedido.dart';
import 'package:formulario_basico/dominio/clientes.dart';
import 'package:formulario_basico/daos/dao_pedidos.dart';
import 'package:formulario_basico/daos/dao_clientes.dart';
import 'package:formulario_basico/daos/dao_platos.dart';

class PantallaAgregarPedido extends StatefulWidget {
  const PantallaAgregarPedido({super.key});

  @override
  State<PantallaAgregarPedido> createState() => _PantallaAgregarPedidoState();
}

class _PantallaAgregarPedidoState extends State<PantallaAgregarPedido> {
  final GlobalKey<FormState> _claveFormulario = GlobalKey<FormState>();
  String? _cedulaCliente;
  List<int> _platosSeleccionados = [];
  String _observaciones = '';
  double _importeTotal = 0.0;
  DateTime _fechaHoraRealizacion = DateTime.now();
  String _estadoEntrega = 'Pendiente';
  List<Cliente> _clientes = [];
  List<Plato> _platos = [];
  Map<int, int> _cantidadPlatos = {}; // Mapa para controlar las cantidades

  @override
  void initState() {
    super.initState();
    _cargarClientes();
    _cargarPlatos();
  }

  // Cargar clientes de la bd
  Future<void> _cargarClientes() async {
    DaoClientes daoClientes = DaoClientes();
    final clientes = await daoClientes.getClientes();
    setState(() {
      _clientes = clientes;
    });
  }

  // Cargar platos activos de la bd
  Future<void> _cargarPlatos() async {
    DaoPlato daoPlatos = DaoPlato();
    final platos = await daoPlatos.obtenerPlatos();
    setState(() {
      _platos = platos;
    });
  }

  // Calcular el total del pedido
  void _calcularTotal() {
    double total = 0;
    for (int platoId in _platosSeleccionados) {
      var plato = _platos.firstWhere((plato) => plato.idPlato == platoId);
      total += plato.precio *
          (_cantidadPlatos[platoId] ?? 1); // Multiplicamos por la cantidad
    }
    setState(() {
      _importeTotal = total;
    });
  }

  // Crear el pedido
  Future<void> _crearPedido() async {
    final db = DaoPedidos();

    // Obtener la cédula del cliente seleccionado (no el objeto Cliente)
    final clienteCedula = _cedulaCliente;

    // Crear las líneas de pedido
    List<LineaPedido> lineasPedidos = [];
    for (int platoId in _platosSeleccionados) {
      // Buscar el plato correspondiente por su id
      var plato = _platos.firstWhere((plato) => plato.idPlato == platoId);

      // Obtener la cantidad de este plato
      int cantidad = _cantidadPlatos[platoId] ?? 1;

      // Crear la línea de pedido
      lineasPedidos.add(LineaPedido(plato: plato, cantidad: cantidad));
    }

    // Crear el objeto Pedido
    Pedido pedido = Pedido(
      idPedido: null,
      fechaHoraRealizacion: _fechaHoraRealizacion,
      observaciones: _observaciones,
      importeTotal: _importeTotal,
      estadoEntrega: _estadoEntrega,
      cobrado: false,
      clienteCedula: clienteCedula!,
      lineasPedidos: lineasPedidos,
    );

    // Llamamos al método crearPedido del Dao
    final idPedido = await db.crearPedido(pedido);

    // Después de insertar el Pedido, insertar las líneas de pedido
    await DAOLineasPedido().agregarLineasPedido(idPedido, lineasPedidos);

    // Regresar a la pantalla principal o mostrar mensaje de éxito
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Pedido'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _claveFormulario,
          child: Column(
            children: [
              // Seleccionar cliente
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Cliente'),
                value: _cedulaCliente,
                onChanged: (String? newValue) {
                  setState(() {
                    _cedulaCliente = newValue;
                  });
                },
                items: _clientes.map<DropdownMenuItem<String>>((cliente) {
                  return DropdownMenuItem<String>(
                    value: cliente.cedula,
                    child: Text(cliente.nombre),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, selecciona un cliente';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Seleccionar platos con cantidad
              const Text('Platos disponibles:'),
              ..._platos.map((plato) {
                return Row(
                  children: [
                    // Checkbox para seleccionar el plato
                    Checkbox(
                      value: _platosSeleccionados.contains(plato.idPlato),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            _platosSeleccionados.add(plato.idPlato);
                            _cantidadPlatos[plato.idPlato] =
                                1; // Inicializa la cantidad en 1
                          } else {
                            _platosSeleccionados.remove(plato.idPlato);
                            _cantidadPlatos.remove(plato
                                .idPlato); // Eliminar la cantidad si el plato es deseleccionado
                          }
                          _calcularTotal(); // Recalcular el total
                        });
                      },
                    ),
                    Text(plato.nombre),
                    // Campo de cantidad
                    _platosSeleccionados.contains(plato.idPlato)
                        ? Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.remove),
                                onPressed: () {
                                  setState(() {
                                    if (_cantidadPlatos[plato.idPlato]! > 1) {
                                      _cantidadPlatos[plato.idPlato] =
                                          _cantidadPlatos[plato.idPlato]! - 1;
                                      _calcularTotal(); // Recalcular el total
                                    }
                                  });
                                },
                              ),
                              Text(
                                  '${_cantidadPlatos[plato.idPlato] ?? 1}'), // Muestra la cantidad
                              IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () {
                                  setState(() {
                                    _cantidadPlatos[plato.idPlato] =
                                        (_cantidadPlatos[plato.idPlato] ?? 0) +
                                            1;
                                    _calcularTotal(); // Recalcular el total
                                  });
                                },
                              ),
                            ],
                          )
                        : Container(),
                  ],
                );
              }),
              const SizedBox(height: 20),

              // Observaciones
              TextFormField(
                decoration: const InputDecoration(labelText: 'Observaciones'),
                onChanged: (value) {
                  setState(() {
                    _observaciones = value;
                  });
                },
              ),
              const SizedBox(height: 20),

              // Importe total
              Text('Importe total: \$${_importeTotal.toStringAsFixed(2)}'),
              const SizedBox(height: 20),

              // Botón para crear el pedido
              ElevatedButton(
                onPressed: () {
                  if (_claveFormulario.currentState?.validate() ?? false) {
                    _crearPedido();
                  }
                },
                child: const Text('Crear Pedido'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
