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
  List<Cliente> _clientesOriginales = [];

  @override
  void initState() {
    super.initState();
    _cargarClientes();
  }

  Future<void> _cargarClientes() async {
    final clientes = await _daoClientes.getClientes();
    setState(() {
      _clientes = clientes;
      _clientesOriginales = List.from(clientes);
    });
  }

  void _filtrarClientes(String query) {
    setState(() {
      if (query.isEmpty) {
        _clientes = _clientesOriginales;
      } else {
        _clientes = _clientesOriginales
            .where((cliente) =>
                cliente.nombre.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
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
                    Navigator.pop(context);
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
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
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
                _filtrarClientes(value);
              },
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.only(bottom: 80.0), // Espacio para el FAB
                child: _clientes.isEmpty
                    ? const Center(child: CircularProgressIndicator())
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
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
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
                                    onPressed: () async {
                                      final resultado =
                                          await Navigator.pushNamed(
                                        context,
                                        '/agregar_cliente',
                                        arguments: cliente,
                                      );

                                      if (resultado == true) {
                                        _cargarClientes();
                                      }
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.black),
                                    tooltip: 'Eliminar',
                                    onPressed: () => mostrarConfirmarEliminar(
                                        context, cliente),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final resultado = await Navigator.pushNamed(
            context,
            '/agregar_cliente',
          );

          if (resultado == true) {
            _cargarClientes();
          }
        },
        backgroundColor: const Color.fromARGB(255, 44, 164, 50),
        child: const Icon(Icons.add),
        tooltip: 'Agregar Cliente',
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void mostrarConfirmarEliminar(BuildContext context, Cliente cliente) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Eliminar Cliente"),
        content: Text(
            "Confirma que desea eliminar el Cliente con cédula: ${cliente.cedula}"),
        actions: [
          TextButton(
            onPressed: () async {
              String mensaje;
              try {
                await DaoClientes().deleteCliente(cliente.cedula);

                mensaje = "Cliente eliminado con éxito";

                _cargarClientes();
              } on Exception catch (e) {
                mensaje =
                    'Error ${e.toString().startsWith('Exception: ') ? e.toString().substring(11) : e.toString()}';
              }

              if (context.mounted) {
                Navigator.of(context).pop();

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      mensaje,
                      textAlign: TextAlign.center,
                    ),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: const Color.fromARGB(128, 64, 64, 64),
                    shape: const StadiumBorder(),
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            },
            child: const Text("Si"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("No"),
          ),
        ],
      ),
    );
  }
}
