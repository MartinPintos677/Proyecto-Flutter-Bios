import 'package:formulario_basico/daos/dao_lineas_pedido.dart';
import 'package:formulario_basico/dominio/linea_pedido.dart';
import 'package:formulario_basico/dominio/pedido.dart';
import 'package:formulario_basico/daos/base_datos.dart';
import 'package:sqflite/sqflite.dart';

class DaoPedidos {
  static final DaoPedidos _instancia = DaoPedidos._inicializar();

  DaoPedidos._inicializar();

  factory DaoPedidos() {
    return _instancia;
  }

  // Método para crear un nuevo pedido
  Future<int> crearPedido(Pedido pedido) async {
    final db = await BaseDatos().obtenerBaseDatos();
    int idPedido = 0;

    try{
      // Insertar el pedido en la tabla "Pedido"
      final idPedido = await db.insert('Pedido', pedido.toMap());

      // Insertar las líneas de pedido
      for (var linea in pedido.lineasPedidos!) {
        final lineaMap = linea.toMap();
        lineaMap['idPedido'] = idPedido; // Asociamos la linea con el id del pedido insertado
        await db.insert('LineaPedido', lineaMap);
      }
    } on DatabaseException{
      throw Exception('No se pudo agregar el Pedido.');
    }

    return idPedido;

  }

  // Método para modificar un pedido
Future<int> modificarPedido(Pedido pedido) async {
  final db = await BaseDatos().obtenerBaseDatos();

  int idPedido = pedido.idPedido!;
  final resultadoPedido = await db.update(
    'Pedido', 
    pedido.toMap(), 
    where: 'idPedido = ?', 
    whereArgs: [idPedido]
  );

  // Eliminamos las lineas para despues insertar las nuevas
  await db.delete(
    'LineaPedido', 
    where: 'idPedido = ?', 
    whereArgs: [idPedido]
  );

  for (var linea in pedido.lineasPedidos!) {
    final lineaMap = linea.toMap();
    lineaMap['idPedido'] = idPedido;
    await db.insert('LineaPedido', lineaMap);
  }

  return resultadoPedido; //Devolvemos las lineas afectadas, por las dudas
}

  // Método para obtener todos los pedidos
  Future<List<Pedido>> obtenerPedidos() async {
    final db = await BaseDatos().obtenerBaseDatos();

    // Obtenemos todos los pedidos de la base de datos
    final List<Map<String, dynamic>> maps = await db.query('Pedido');

    // Convertimos los resultados en una lista de objetos Pedido
    return List.generate(maps.length, (i) {
      return Pedido.fromMap(maps[i]);
    });
  }

  // Método para obtener un pedido por ID
  Future<Pedido?> obtenerPedidoPorId(int idPedido) async {
    final db = await BaseDatos().obtenerBaseDatos();

    // Obtenemos el pedido por su ID
    final List<Map<String, dynamic>> maps = await db.query(
      'Pedido',
      where: 'idPedido = ?',
      whereArgs: [idPedido],
    );

    if (maps.isNotEmpty) {
      return Pedido.fromMap(maps.first);
    } else {
      return null;
    }
  }

  // Método para actualizar el estado de un pedido
  Future<int> actualizarEstadoEntregaPedido(int idPedido, String nuevoEstado) async {
    final db = await BaseDatos().obtenerBaseDatos();

    // Actualizamos el estado del pedido en la base de datos
    return await db.update(
      'Pedido',
      {'estadoEntrega': nuevoEstado},
      where: 'idPedido = ?',
      whereArgs: [idPedido],
    );
  }

  Future<void> actualizarEstadoCobradoPedido(List<Pedido> pedidos) async {
    final db = await BaseDatos().obtenerBaseDatos();

    for (var pedido in pedidos) { 
      await db.update( 
        'Pedido', 
        {'cobrado': 1}, 
        where: 'idPedido = ?', 
        whereArgs: [pedido.idPedido], 
      ); }
  }


  //Metodo para obtener la lista de Pedidos por la cedula del Cliente
  Future<List<Pedido>> obtenerPedidosNoCobradosPorCedula(String cedula) async {
    final db = await BaseDatos().obtenerBaseDatos();

    // Obtenemos el pedido por su ID
    final List<Map<String, dynamic>> maps = await db.query(
      'Pedido',
      where: 'cedula = ? AND cobrado = ?',
      whereArgs: [cedula, 0],
    );

    return List.generate(maps.length, (i) {
      return Pedido.fromMap(maps[i]);
    });
  }

  Future<Pedido> obtenerPedidoConLineas(int idPedido) async { final db = await BaseDatos().obtenerBaseDatos(); // Obtener el pedido por su ID 
  final List<Map<String, dynamic>> maps = await db.query( 
    'Pedido', 
    where: 'idPedido = ?', 
    whereArgs: [idPedido], 
  ); 
    if (maps.isEmpty) { 
      throw Exception('Pedido no encontrado'); 

    } 
    final Map<String, dynamic> pedidoMap = maps.first; // Obtener las lineas del pedido 
    final List<LineaPedido> lineasPedidos = await DAOLineasPedido().obtenerLineasPorIdPedido(idPedido); // Crear el objeto Pedido 
    Pedido pedido = Pedido.fromMap(pedidoMap); // Asignar las lineasPedidos al objeto pedido 
    pedido = Pedido( 
      idPedido: pedido.idPedido, 
      fechaHoraRealizacion: pedido.fechaHoraRealizacion, 
      observaciones: pedido.observaciones, 
      importeTotal: pedido.importeTotal, 
      estadoEntrega: pedido.estadoEntrega, 
      cobrado: pedido.cobrado, 
      clienteCedula: pedido.clienteCedula, 
      lineasPedidos: lineasPedidos, 
    ); 
    return pedido; 
  }
}
