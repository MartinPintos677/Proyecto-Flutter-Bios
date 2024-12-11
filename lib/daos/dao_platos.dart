import 'package:formulario_basico/daos/base_datos.dart';
import 'package:sqflite/sqflite.dart';
import 'package:formulario_basico/dominio/platos.dart';

class DaoPlato {
  static final DaoPlato _instancia = DaoPlato._inicializar();

  DaoPlato._inicializar();

  factory DaoPlato() {
    return _instancia;
  }

  // Crear un plato
  Future<int> insertarPlato(Map<String, dynamic> plato) async {
    Database db = await BaseDatos().obtenerBaseDatos();
    return await db.insert('Plato', plato);
  }

  // Obtener todos los platos
  Future<List<Plato>> obtenerPlatos() async {
    Database db = await BaseDatos().obtenerBaseDatos();
    final List<Map<String, dynamic>> platosMap = await db.query('Plato');
    return List.generate(platosMap.length, (i) {
      return Plato.fromMap(platosMap[i]);
    });
  }

  // Modificar un plato
  Future<int> actualizarPlato(Map<String, dynamic> plato) async {
    Database db = await BaseDatos().obtenerBaseDatos();
    return await db.update(
      'Plato',
      plato,
      where: 'idPlato = ?',
      whereArgs: [plato['idPlato']],
    );
  }

  // Eliminar un plato por su ID
  Future<int> eliminarPlato(int idPlato) async {
    Database db = await BaseDatos().obtenerBaseDatos();
    return await db.delete(
      'Plato',
      where: 'idPlato = ?',
      whereArgs: [idPlato],
    );
  }
}
