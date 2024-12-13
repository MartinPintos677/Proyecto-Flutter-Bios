import 'package:formulario_basico/dominio/pedido.dart';
import 'package:formulario_basico/daos/base_datos.dart';

class DaoPedidos {
  static final DaoPedidos _instancia = DaoPedidos._inicializar();

  DaoPedidos._inicializar();

  factory DaoPedidos() {
    return _instancia;
  }

  // Método para crear un nuevo pedido
  Future<int> crearPedido(Pedido pedido) async {
    final db = await BaseDatos().obtenerBaseDatos();

    // Insertar el pedido en la tabla "Pedido"
    final idPedido = await db.insert('Pedido', pedido.toMap());

    // Insertar las líneas de pedido
    for (var linea in pedido.lineasPedidos) {
      final lineaMap = linea.toMap();
      lineaMap['idPedido'] =
          idPedido; // Asociamos la linea con el id del pedido insertado
      await db.insert('LineaPedido', lineaMap);
    }

    return idPedido;
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
  Future<int> actualizarEstadoPedido(int idPedido, String nuevoEstado) async {
    final db = await BaseDatos().obtenerBaseDatos();

    // Actualizamos el estado del pedido en la base de datos
    return await db.update(
      'Pedido',
      {'estadoEntrega': nuevoEstado},
      where: 'idPedido = ?',
      whereArgs: [idPedido],
    );
  }
}
