import 'package:formulario_basico/daos/base_datos.dart';
import 'package:formulario_basico/daos/dao_clientes.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:formulario_basico/dominio/platos.dart';

class DaoPlato {
  static final DaoPlato _instancia = DaoPlato._inicializar();

  DaoPlato._inicializar();

  factory DaoPlato() {
    return _instancia;
  }

  // Crear un plato
  Future<int> agregarPlato(Map<String, dynamic> plato) async {
    Database db = await BaseDatos().obtenerBaseDatos();
    return await db.insert('Plato', plato);
  }

  // // Obtener solo los platos activos
  Future<List<Plato>> obtenerPlatos() async {
    final db = await BaseDatos().obtenerBaseDatos();
    // Filtrar los platos activos
    final List<Map<String, dynamic>> maps = await db.query(
      'Plato',
      where: 'activo = 1',
    );

    // Convertir los resultados a objetos Plato
    return List.generate(maps.length, (i) {
      return Plato.fromMap(maps[i]);
    });
  }

  // Modificar un plato
  Future<int> actualizarPlato(Plato plato) async {
    Database db = await BaseDatos().obtenerBaseDatos();
    return await db.update(
      'Plato',
      plato.toMap(),
      where: 'idPlato = ?',
      whereArgs: [plato.idPlato],
    );
  }

  // Eliminar un plato por su ID
  Future<int> darBajaPlato(int idPlato) async {
    Database db = await BaseDatos().obtenerBaseDatos();
    // Actualizamos el campo 'activo' a 0 (inactivo)
    return await db.update(
      'Plato',
      {'activo': 0}, // Establecemos 'activo' a 0 para marcarlo como inactivo
      where: 'idPlato = ?',
      whereArgs: [idPlato],
    );
  }

  Future<Plato?> obtenerPlatoPorId(int idPlato) async {
    Database bd = await BaseDatos().obtenerBaseDatos();

    List<Map<String, Object?>> mapasPlato = await bd.query(
      'Plato',
      where: 'idPlato = ?',
      whereArgs: [idPlato],
    );

    Plato? plato;

    if (mapasPlato.isNotEmpty) {
      Map<String, Object?> mp = {...mapasPlato.first};
      mp['cliente'] =
          (await DaoClientes().getClienteByCedula(mp['cedula'] as String))
              ?.toMap();

      plato = Plato.fromMap(mp);
    }

    return plato;
  }

  String obtenerDiaHoyEnEspaniol() {
    final DateTime now = DateTime.now();
    String diaIngles = DateFormat('EEEE', 'en_US').format(now).toLowerCase();

    final Map<String, String> diasInglesAEspanol = {
      'monday': 'lunes',
      'tuesday': 'martes',
      'wednesday': 'miércoles',
      'thursday': 'jueves',
      'friday': 'viernes',
      'saturday': 'sábado',
      'sunday': 'domingo',
    };

    return diasInglesAEspanol[diaIngles] ?? '';
  }

  Future<List<Plato>> obtenerPlatosDisponiblesHoy() async {
    // Obtén los platos desde la base de datos (usando el Dao)
    final platos = await DaoPlato().obtenerPlatos();

    final diaHoy = obtenerDiaHoyEnEspaniol().toLowerCase();

    // Filtramos los platos que están disponibles hoy
    final platosDisponiblesHoy = platos.where((plato) {
      List<String> diasDisponibles = plato.diasDisponibles
          .split(',')
          .map((e) => e.trim().toLowerCase())
          .toList();

      return diasDisponibles.contains(diaHoy);
    }).toList();

    return platosDisponiblesHoy;
  }
}
