import 'package:formulario_basico/daos/base_datos.dart';
import 'package:sqflite/sqflite.dart';
import 'package:formulario_basico/dominio/clientes.dart';

class DaoClientes {
  static final DaoClientes _instancia = DaoClientes._inicializar();

  DaoClientes._inicializar();

  factory DaoClientes(){
    return _instancia;
  }


  final BaseDatos _dbHelper = BaseDatos.instance;

  // Crear un cliente
  Future<int> insertCliente(Cliente cliente) async {
    Database db = await BaseDatos().obtenerBaseDatos();
    return await db.insert('Cliente', cliente.toMap());
  }

  // Obtener todos los clientes
  Future<List<Cliente>> getClientes() async {
    Database db = await BaseDatos().obtenerBaseDatos();
    List<Map<String, dynamic>> clientMaps = await db.query('Cliente');

    return List.generate(clientMaps.length, (i) {
      return Cliente.fromMap(clientMaps[i]);
    });
  }

  // Obtener un cliente por su cédula
  Future<Cliente?> getClienteByCedula(String cedula) async {
    Database db = await BaseDatos().obtenerBaseDatos();
    List<Map<String, dynamic>> clientMaps = await db.query(
      'Cliente',
      where: 'cedula = ?',
      whereArgs: [cedula],
    );

    if (clientMaps.isNotEmpty) {
      return Cliente.fromMap(clientMaps.first);
    }
    return null;
  }

  // Modificar un cliente
  Future<int> updateCliente(Cliente cliente) async {
    Database db = await BaseDatos().obtenerBaseDatos();
    return await db.update(
      'Cliente',
      cliente.toMap(),
      where: 'cedula = ?',
      whereArgs: [cliente.cedula],
    );
  }

  // Eliminar un cliente
  Future<int> deleteCliente(String cedula) async {
    Database db = await BaseDatos().obtenerBaseDatos();
    return await db.delete(
      'Cliente',
      where: 'cedula = ?',
      whereArgs: [cedula],
    );
  }
}
