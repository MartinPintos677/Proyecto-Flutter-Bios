import 'package:formulario_basico/daos/base_datos.dart';
import 'package:formulario_basico/dominio/linea_pedido.dart';
import 'package:sqflite/sqflite.dart';

class DAOLineasPedido {
  static final DAOLineasPedido _instancia = DAOLineasPedido._inicializar();

  DAOLineasPedido._inicializar();

  factory DAOLineasPedido(){
    return _instancia;
  }

  // Future<void> agregarLineasPedido(List<LineaPedido> lineas) async {
  //   Database bd = await BaseDatos().obtenerBaseDatos();
  //   Map<String, Object?> mapaLinea = lineas.map() //(item) => LineaPedido.fromMap(item as Map<String, Object?>)).toList();
  //   mapaLinea['id_categoria'] = tarea.categoria.id;
  //   mapaLinea.remove('categoria');
  //   try {
  //     for (var linea in lineas) { 
  //       await bd.insert( 
  //         'LineaPedido',
  //         lineas,
  //       ); 
  //     }
  //   } on DatabaseException {
  //     throw Exception('No se pudo agregar la tarea.');
  //   }
  // }

  // // Obtener todos los clientes
  // Future<List<Cliente>> getClientes() async {
  //   Database db = await BaseDatos().obtenerBaseDatos();
  //   List<Map<String, dynamic>> clientMaps = await db.query('Cliente');

  //   return List.generate(clientMaps.length, (i) {
  //     return Cliente.fromMap(clientMaps[i]);
  //   });
  // }


}