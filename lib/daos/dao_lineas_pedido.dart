import 'package:formulario_basico/daos/base_datos.dart';
import 'package:formulario_basico/daos/dao_platos.dart';
import 'package:formulario_basico/dominio/linea_pedido.dart';
import 'package:sqflite/sqflite.dart';

class DAOLineasPedido {
  static final DAOLineasPedido _instancia = DAOLineasPedido._inicializar();

  DAOLineasPedido._inicializar();

  factory DAOLineasPedido(){
    return _instancia;
  }

  Future<void> agregarLineasPedido(List<LineaPedido> lineas) async {
    Database bd = await BaseDatos().obtenerBaseDatos();   
    try {
      for (var linea in lineas) { 
        Map<String, Object?> mapaLinea = linea.toMap();
        mapaLinea["idPlato"] = linea.plato.idPlato; //Tenemos que volver a ponerle el idPlato
        mapaLinea.remove('plato');//Y sacarle el plato que le habiamos puesto

        await bd.insert( 
          'LineaPedido',
          mapaLinea,
        ); 
      }
    } on DatabaseException {
      throw Exception('No se pudo agregar la linea.');
    }
  }


  Future<List<LineaPedido>> obtenerLineasPorIdPedidoEIdPlato(int idPedido, int idPlato) async {
    Database db = await BaseDatos().obtenerBaseDatos();

   List<Map<String, Object?>> mapasLineas = (await db.query(
      'LineasPedido',
      where: 'idPedido = ? AND idPlato = ?',
      whereArgs: [idPedido, idPlato],
    )).map((ml) => {...ml} ,).toList();

    for (Map<String, Object?> ml in mapasLineas) {
      ml['plato'] = (await DaoPlato().obtenerPlatoPorId(ml['idPlato'] as int))?.toMap();
    }

    return mapasLineas.map((ml) => LineaPedido.fromMap(ml)).toList();
  }


}