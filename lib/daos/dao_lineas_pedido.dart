import 'package:formulario_basico/daos/base_datos.dart';
import 'package:formulario_basico/dominio/linea_pedido.dart';
import 'package:formulario_basico/dominio/platos.dart';
import 'package:sqflite/sqflite.dart';

class DAOLineasPedido {
  static final DAOLineasPedido _instancia = DAOLineasPedido._inicializar();

  DAOLineasPedido._inicializar();

  factory DAOLineasPedido() {
    return _instancia;
  }

  // Obtener líneas de pedido por ID de pedido
  Future<List<LineaPedido>> obtenerLineasPorIdPedido(int? idPedido) async {
    final db = await BaseDatos().obtenerBaseDatos();

    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT lp.idPlato, lp.cantidad, p.nombre AS platoNombre, p.precio
      FROM LineaPedido lp
      JOIN Plato p ON lp.idPlato = p.idPlato
      WHERE lp.idPedido = ?
    ''', [idPedido]);

    return maps.map((map) {
      final plato = Plato(
        idPlato: map['idPlato'] as int,
        nombre: map['platoNombre'] as String,
        precio: (map['precio'] as num).toDouble(),
        diasDisponibles: '', // No necesario aquí
        activo: true, // Placeholder
      );
      return LineaPedido(plato: plato, cantidad: map['cantidad'] as int);
    }).toList();
  }

  // Agregar líneas de pedido
  Future<void> agregarLineasPedido(
      int idPedido, List<LineaPedido> lineas) async {
    Database bd = await BaseDatos().obtenerBaseDatos();
    try {
      for (var linea in lineas) {
        // Convierte la línea de pedido a un mapa
        Map<String, Object?> mapaLinea = linea.toMap();
        mapaLinea['idPedido'] =
            idPedido; // Asociamos el idPedido generado con cada línea

        // Insertamos la línea de pedido en la base de datos
        await bd.insert('LineaPedido', mapaLinea);
      }
    } on DatabaseException catch (e) {
      throw Exception('No se pudo agregar la línea de pedido: $e');
    }
  }
}
