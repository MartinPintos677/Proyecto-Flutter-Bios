import 'package:flutter/material.dart';
import 'package:formulario_basico/dominio/pedido.dart';
import 'package:formulario_basico/daos/dao_lineas_pedido.dart';
import 'package:formulario_basico/dominio/linea_pedido.dart';

class PantallaFichaPedido extends StatefulWidget {
  final Pedido pedido;

  const PantallaFichaPedido({Key? key, required this.pedido}) : super(key: key);

  @override
  State<PantallaFichaPedido> createState() => _PantallaFichaPedidoState();
}

class _PantallaFichaPedidoState extends State<PantallaFichaPedido> {
  final DAOLineasPedido _daoLineasPedido = DAOLineasPedido();
  List<LineaPedido> _lineasPedido = [];

  @override
  void initState() {
    super.initState();
    _cargarLineasPedido();
  }

  Future<void> _cargarLineasPedido() async {
    final lineas =
        await _daoLineasPedido.obtenerLineasPorIdPedido(widget.pedido.idPedido);
    setState(() {
      _lineasPedido = lineas;
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Colors.black;
    const Color greenColor = Color.fromARGB(255, 44, 164, 50);
    const Color cardColor = Colors.white;

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
                  'Ficha del Pedido #${widget.pedido.idPedido}',
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Información del Pedido'),
              Card(
                elevation: 2,
                color: cardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow('Cliente:',
                          widget.pedido.clienteNombre ?? "Desconocido"),
                      _buildInfoRow('Cédula:', widget.pedido.clienteCedula),
                      _buildInfoRow(
                          'Fecha del Pedido:',
                          widget.pedido.fechaHoraRealizacion
                              .toString()
                              .split('.')[0]),
                      _buildInfoRow('Importe Total:',
                          '\$${widget.pedido.importeTotal.toStringAsFixed(2)}'),
                      _buildInfoRow('Observaciones:',
                          widget.pedido.observaciones ?? "Sin observaciones"),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildSectionTitle('Platos del Pedido'),
              _lineasPedido.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _lineasPedido.length,
                      itemBuilder: (context, index) {
                        final linea = _lineasPedido[index];
                        return _buildPlatoCard(linea, greenColor);
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlatoCard(LineaPedido linea, Color highlightColor) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Icon(Icons.fastfood, color: highlightColor, size: 30),
        title: Text(
          linea.plato.nombre,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Cantidad: ${linea.cantidad}'),
            Text('Precio Unitario: \$${linea.plato.precio.toStringAsFixed(2)}'),
          ],
        ),
        trailing: Text(
          'Total: \$${(linea.cantidad * linea.plato.precio).toStringAsFixed(2)}',
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black),
        ),
      ),
    );
  }
}
