import 'package:flutter/material.dart';
import 'package:formulario_basico/daos/dao_pedidos.dart';
import 'package:formulario_basico/dominio/clientes.dart';
import 'package:formulario_basico/dominio/pedido.dart';

class PantallaFichaCliente extends StatefulWidget {
  const PantallaFichaCliente({super.key});

  @override
  State<PantallaFichaCliente> createState() => _PantallaFichaClienteState();
}

class _PantallaFichaClienteState extends State<PantallaFichaCliente> {
  final _daoPedidos = DaoPedidos();
  
  Cliente? cliente;
  List<Pedido> pedidos = [];
  double importeTotal = 0;

  @override
  void didChangeDependencies() {
    cliente = ModalRoute.of(context)!.settings.arguments as Cliente?;
    _cargarPedidos();

    super.didChangeDependencies();
  }

  Future<void> _cargarPedidos() async {
    final _pedidos =
        await _daoPedidos.obtenerPedidosNoCobradosPorCedula(cliente!.cedula);

    setState(() {
      pedidos = _pedidos;
      importeTotal = pedidos.fold(0, (sum, p) => sum + p.importeTotal);
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Colors.black;
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
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Flexible(
                  // Permite que el texto administre el ancho
                  child: Text(
                    'Ficha de ${cliente!.nombre}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    softWrap: false,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pedidos Adeudados:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: pedidos.isEmpty
                  ? const Text(
                      "No hay Pedidos Pendientes de pago",
                      textAlign: TextAlign.center,
                    )
                  : ListView.builder(
                      itemCount: pedidos.length,
                      itemBuilder: (context, index) {
                        final pedido = pedidos[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            leading: const CircleAvatar(
                              backgroundColor: Colors.red,
                              child: Icon(
                                Icons.warning,
                                color: Colors.white,
                              ),
                            ),
                            title: Text(
                              'Pedido #${pedido.idPedido}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text('Importe: \$${pedido.importeTotal}'),
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 20),
            if (pedidos.isNotEmpty)
              Text(
                'Total Adeudado: \$$importeTotal',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.red,
                ),
              ),
            const SizedBox(height: 20),
            if (pedidos.isNotEmpty)
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    _daoPedidos.actualizarEstadoCobradoPedido(pedidos);
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Todos los pedidos han sido abonados'),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: greenColor,
                    foregroundColor: Colors.white,
                  ),
                  icon: const Icon(Icons.check), // Ícono de check
                  label: const Text('Marcar como Abonados'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
