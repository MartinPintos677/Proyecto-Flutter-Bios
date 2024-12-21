import 'package:flutter/material.dart';
import 'package:formulario_basico/daos/dao_lineas_pedido.dart';
import 'package:formulario_basico/dominio/platos.dart';
import 'package:formulario_basico/dominio/pedido.dart';
import 'package:formulario_basico/dominio/linea_pedido.dart';
import 'package:formulario_basico/dominio/clientes.dart';
import 'package:formulario_basico/daos/dao_pedidos.dart';
import 'package:formulario_basico/daos/dao_clientes.dart';
import 'package:formulario_basico/daos/dao_platos.dart';
import 'package:formulario_basico/paginas/paginas.dart';
import 'package:intl/intl.dart';

class PantallaAgregarPedido extends StatefulWidget {
  const PantallaAgregarPedido({super.key});

  @override
  State<PantallaAgregarPedido> createState() => _PantallaAgregarPedidoState();
}

class _PantallaAgregarPedidoState extends State<PantallaAgregarPedido> {
  final GlobalKey<FormState> _claveFormulario = GlobalKey<FormState>();

  Pedido? _pedido;
  late int? _idPedido;
  DateTime _fechaHoraRealizacion = DateTime.now();
  String? _cedulaCliente;
  late String? _observaciones;
  late double _importeTotal;
  late String _estadoEntrega;
  late bool? _cobrado;
  bool mostrarCobrado =  false;

  final List<int> _platosSeleccionados = [];
  List<Cliente> _clientes = [];
  List<Plato> _platos = [];
  List<LineaPedido> _lineasPedido = [];

  List<String> valoresEstado = ["Pendiente", "Cancelado", "Entregado"];

  @override
  void initState() {
    super.initState();
    _cargarPlatos();
  }

  // Cargar clientes de la bd
  Future<void> _cargarClientes() async {
    DaoClientes().getClientes().then(
      (value) {
        setState(() {
          _clientes = value;
        });
      },
    );
  }

  // Cargar platos disponibles hoy
  Future<void> _cargarPlatos() async {
    // Llama al DaoPlato para obtener los platos disponibles hoy
    DaoPlato().obtenerPlatosDisponiblesHoy().then(
      (value) {
        setState(() {
          _platos =
              value; // Actualizamos la lista de platos con los disponibles hoy
        });
      },
    );
  }

  Future<void> _cargarPlatosDePedido() async {
    DAOLineasPedido().obtenerLineasPorIdPedido(_pedido?.idPedido).then(
      (value) {
        setState(() {
          _lineasPedido = value;
        });
      },
    );
  }

  // Calcular el total del pedido
  void _calcularTotal() {
    double total = 0;
    for (LineaPedido linea in _lineasPedido) {
      var plato =
          _platos.firstWhere((plato) => plato.idPlato == linea.plato.idPlato);
      total += plato.precio * (linea.cantidad); // Multiplicamos por la cantidad
    }
    setState(() {
      _importeTotal = total;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _cargarClientes(); // Cargamos la lista de clientes siempre

    _pedido = ModalRoute.of(context)?.settings.arguments as Pedido?;

    if (_pedido != null && _pedido!.idPedido != null) {
      // Si el idPedido no es null, cargamos el pedido actualizado
      _cargarPedidoActualizado(_pedido!.idPedido!);
    } else {
      // Si estamos agregando, inicializamos los valores por defecto
      setState(() {
        _idPedido = null;
        _cedulaCliente = null;
        _fechaHoraRealizacion = DateTime.now();
        _observaciones = '';
        _cobrado = null; // Valor predeterminado
        _estadoEntrega = "Pendiente"; // Valor predeterminado
      });

      // Cargamos los platos disponibles para el nuevo pedido
      _cargarPlatos();
    }
  }

  Future<void> _cargarPedidoActualizado(int idPedido) async {
    final pedidoActualizado = await DaoPedidos().obtenerPedidoPorId(idPedido);

    if (pedidoActualizado != null) {
      setState(() {
        _idPedido = pedidoActualizado.idPedido ?? 0; // Asignar 0 si es null
        _cedulaCliente = pedidoActualizado.clienteCedula;
        _fechaHoraRealizacion = pedidoActualizado.fechaHoraRealizacion;
        _observaciones = pedidoActualizado.observaciones ?? "";
        _importeTotal = pedidoActualizado.importeTotal;
        _cobrado = pedidoActualizado.cobrado;
        _estadoEntrega = pedidoActualizado.estadoEntrega;
      });

      // Cargar platos y líneas del pedido
      _cargarPlatosDePedido();
      _cargarPlatos();
    }
  }

  // Crear el pedido
  Future<void> _crearPedido() async {
    final db = DaoPedidos();

    // Obtener la cédula del cliente seleccionado
    final clienteCedula = _cedulaCliente;

    // Crear el objeto Pedido
    Pedido pedido = Pedido(
      idPedido: null,
      fechaHoraRealizacion: _fechaHoraRealizacion,
      observaciones: _observaciones,
      importeTotal: _importeTotal,
      estadoEntrega: "Pendiente",
      cobrado: _cobrado,
      clienteCedula: clienteCedula!,
      lineasPedidos: _lineasPedido,
    );
    // Llamamos al método crearPedido del Dao
    await db.crearPedido(pedido);
  }

  // Modificar el pedido
  Future<void> _modificarPedido() async {
    final db = DaoPedidos();

    // Obtener la cédula del cliente seleccionado
    final clienteCedula = _cedulaCliente;

    // Crear el objeto Pedido
    Pedido pedido = Pedido(
      idPedido: _idPedido,
      fechaHoraRealizacion: _fechaHoraRealizacion,
      observaciones: _observaciones,
      importeTotal: _importeTotal,
      estadoEntrega: _estadoEntrega,
      cobrado: _cobrado,
      clienteCedula: clienteCedula!,
      lineasPedidos: _lineasPedido,
    );
    // Llamamos al método crearPedido del Dao
    await db.modificarPedido(pedido);

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const PantallaInicial()),
      (Route<dynamic> route) => false, // Elimina todas las rutas anteriores
    );
  }

  void mostrarSnackBar(mensaje){
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
      content: Text(mensaje,
          textAlign: TextAlign.center),
      behavior: SnackBarBehavior.floating,
      backgroundColor:
          const Color.fromARGB(128, 64, 64, 64),
      shape: const StadiumBorder(),
      duration: const Duration(seconds: 2),
    ));
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
                    Navigator.pop(context);
                  },
                ),
                Text(
                  '${_pedido == null ? 'Agregar' : 'Modificar'} Pedido',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
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
        padding: const EdgeInsets.all(16.0),
        child: Scrollbar(
          child: SingleChildScrollView(
            // Hacemos la pantalla desplazable
            child: Form(
              key: _claveFormulario,
              child: Column(
                children: [
                  if (_pedido != null)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Id: $_idPedido',
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  if (_pedido != null) const SizedBox(height: 15),
                  _pedido != null
                      ? Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Fecha: ${DateFormat('dd/MM/yyyy HH:mm').format(_fechaHoraRealizacion)}',
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                        )
                      : const SizedBox(height: 10),
                  if (_pedido != null) const SizedBox(height: 15),
                  // Seleccionar cliente
                  _pedido != null
                      ? DropdownButtonFormField<String>(
                          decoration:
                              const InputDecoration(labelText: 'Cliente'),
                          onChanged: (String? newValue) {
                            setState(() {
                              _cedulaCliente = newValue;
                            });
                          },
                          items: _clientes
                              .map((c) => DropdownMenuItem(
                                    value: c.cedula,
                                    child: Text(c.nombre),
                                  ))
                              .toList(),
                          value: _cedulaCliente,
                          hint: const Text("Seleccionar"),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, selecciona un cliente';
                            }
                            return null;
                          },
                          onSaved: (newValue) {
                            _cedulaCliente = newValue!;
                          },
                        )
                      : DropdownButtonFormField<String>(
                          decoration:
                              const InputDecoration(labelText: 'Cliente'),
                          onChanged: (String? newValue) {
                            setState(() {
                              _cedulaCliente = newValue;
                              _calcularTotal();
                            });
                          },
                          items: _clientes
                              .map((c) => DropdownMenuItem(
                                    value: c.cedula,
                                    child: Text(c.nombre),
                                  ))
                              .toList(),
                          hint: const Text("Seleccionar"),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, selecciona un cliente';
                            }
                            return null;
                          },
                          onSaved: (newValue) {
                            _cedulaCliente = newValue!;
                          },
                        ),
                  const SizedBox(height: 20),

                  // Seleccionar platos con su respectiva cantidad
                  _pedido == null
                      ? const Text('Platos disponibles:')
                      : const Text("Platos del pedido:"),
                  ..._platos.map((plato) {
                    // Buscamos si el plato está en lineas_pedido
                    LineaPedido? lineaPedido = _lineasPedido.firstWhere(
                      (linea) => linea.plato.idPlato == plato.idPlato,
                      orElse: () => LineaPedido(plato: plato, cantidad: 0),
                    );

                    // Verificamos si el plato está seleccionado o no, lo sabemos por su cantidad
                    bool isSelected = lineaPedido.cantidad > 0;

                    return Row(
                      children: [
                        Checkbox(
                          value: isSelected,
                          activeColor: Colors.green,
                          checkColor: Colors.white,
                          side: const BorderSide(color: Colors.green),
                          onChanged: (bool? value) {
                            setState(() {
                              if (value == true) {
                                // Si se marca, añadimos a _platosSeleccionados y ponemos la cantidad correspondiente
                                _platosSeleccionados.add(plato.idPlato);
                                // Lo agregamos a lineas_pedido si no existe
                                if (_lineasPedido.every((linea) =>
                                    linea.plato.idPlato != plato.idPlato)) {
                                  _lineasPedido.add(
                                      LineaPedido(plato: plato, cantidad: 1));
                                }
                              } else {
                                // Si se desmarca, eliminamos de _platosSeleccionados y ponemos la cantidad a 0 en lineas_pedido
                                _platosSeleccionados.remove(plato.idPlato);
                                _lineasPedido.removeWhere((linea) =>
                                    linea.plato.idPlato == plato.idPlato);
                              }
                              _calcularTotal();
                            });
                          },
                        ),
                        Text(
                          plato.nombre,
                          style: const TextStyle(color: Colors.black),
                        ),

                        // Mostrar la cantidad a la derecha
                        const Spacer(),

                        // Fila con la que mostrarmos la cantidad
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: isSelected
                                  ? () {
                                      setState(() {
                                        // Disminuimos si es mayor que cero
                                        var linea = _lineasPedido.firstWhere(
                                          (linea) =>
                                              linea.plato.idPlato ==
                                              plato.idPlato,
                                          orElse: () => LineaPedido(
                                              plato: plato, cantidad: 0),
                                        );
                                        if (linea.cantidad > 1) {
                                          linea.cantidad -= 1;
                                        }
                                        _calcularTotal();
                                      });
                                    }
                                  : null, // Deshabilitamos si no está seleccionado
                            ),
                            // cantidad del plato
                            Text('${lineaPedido.cantidad}'),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: isSelected
                                  ? () {
                                      setState(() {
                                        // Aumentamos la cantidad en lineas_pedido
                                        var linea = _lineasPedido.firstWhere(
                                          (linea) =>
                                              linea.plato.idPlato ==
                                              plato.idPlato,
                                          orElse: () => LineaPedido(
                                              plato: plato, cantidad: 0),
                                        );
                                        linea.cantidad += 1;
                                        _calcularTotal();
                                      });
                                    }
                                  : null, // Deshabilitamos si no está seleccionado
                            ),
                          ],
                        ),
                      ],
                    );
                  }),
                  const SizedBox(height: 20),

                  // Observaciones
                  TextFormField(
                    cursorColor: Colors.green,
                    decoration: InputDecoration(
                      labelText: 'Observaciones',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    initialValue: _observaciones,
                    onChanged: (value) {
                      setState(() {
                        _observaciones = value;
                      });
                    },
                    onSaved: (newValue) {
                      _observaciones = newValue;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  _pedido != null
                      ? DropdownButtonFormField<String>(
                          decoration:
                              const InputDecoration(labelText: 'Estado'),
                          value: _estadoEntrega,
                          onChanged: (String? newValue) {
                            setState(() {
                              _estadoEntrega = newValue!;
                              newValue == "Entregado" ? mostrarCobrado = true : mostrarCobrado = false;
                            });
                          },
                          items: valoresEstado
                              .map((v) => DropdownMenuItem(
                                    value: v,
                                    child: Text(v),
                                  ))
                              .toList(),
                          hint: const Text("Seleccionar"),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, selecciona un Estado de entrega';
                            }
                            return null;
                          },
                          onSaved: (newValue) {
                            _estadoEntrega = newValue!;
                          },
                          
                        )
                      : Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Estado: ${valoresEstado[0]}",
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                        ),
                  if(mostrarCobrado)CheckboxListTile(
                    title: const Text('Cobrado'),
                    value: _cobrado == null || _cobrado == false ? false : true,
                    onChanged: (value) {
                      setState(() {
                        _cobrado = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 20),

                  // Importe total
                  Text('Importe total: \$${_importeTotal.toStringAsFixed(2)}'),
                  const SizedBox(height: 20),

                  // Botón para crear el pedido
                  Align(
                    alignment:
                        Alignment.bottomCenter, // Alinea el botón al final
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_claveFormulario.currentState?.validate() ??
                            false) {
                          _claveFormulario.currentState?.save();

                          String mensaje;
                          try {
                            if (_pedido == null && _lineasPedido.isNotEmpty) {
                              // Crear un nuevo pedido
                              await _crearPedido();

                              // Mostrar el diálogo modal solo al agregar
                              if (context.mounted) {
                                await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Pedido Guardado'),
                                      content: Text(
                                        'El importe total del pedido es \$${_importeTotal.toStringAsFixed(2)}.',
                                        textAlign: TextAlign.center,
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pushNamed("/");
                                          },
                                          child: const Text('Aceptar'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            } else if (_pedido != null &&
                                _lineasPedido.isNotEmpty) {
                              // Modificar pedido existente
                              await _modificarPedido();
                              mensaje = 'Pedido modificado con éxito.';

                              if (context.mounted) {
                                mostrarSnackBar(mensaje);
                              }
                            } else {
                              mensaje = "Debe seleccionar algún Plato";

                              if (context.mounted) {
                                mostrarSnackBar(mensaje);
                              }
                            }
                          } on Exception catch (e) {
                            mensaje =
                                '¡Error! ${e.toString().startsWith('Exception: ') ? e.toString().substring(11) : e.toString()}';

                            if (context.mounted) {
                              mostrarSnackBar(mensaje);
                            }
                          }
                        }
                      },
                      child: const Text('Guardar Pedido'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
