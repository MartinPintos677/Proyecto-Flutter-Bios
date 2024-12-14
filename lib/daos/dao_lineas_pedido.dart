import 'package:formulario_basico/daos/base_datos.dart';
import 'package:formulario_basico/daos/dao_platos.dart';
import 'package:formulario_basico/dominio/linea_pedido.dart';
import 'package:sqflite/sqflite.dart';

class DAOLineasPedido {
  static final DAOLineasPedido _instancia = DAOLineasPedido._inicializar();

  DAOLineasPedido._inicializar();

  factory DAOLineasPedido() {
    return _instancia;
  }

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

  Future<List<LineaPedido>> obtenerLineasPorIdPedido(int? idPedido) async {
    Database db = await BaseDatos().obtenerBaseDatos();

    List<Map<String, Object?>> mapasLineas = (await db.query(
      'LineasPedido',
      where: 'idPedido = ?',
      whereArgs: [idPedido],
    ))
        .map(
          (ml) => {...ml},
        )
        .toList();

    for (Map<String, Object?> ml in mapasLineas) {
      ml['plato'] = (await DaoPlato().obtenerPlatoPorId(ml['idPlato'] as int))?.toMap();
    }

    return mapasLineas.map((ml) => LineaPedido.fromMap(ml)).toList();
  }
}
