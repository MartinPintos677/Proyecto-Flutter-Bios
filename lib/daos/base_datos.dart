import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;

  // Constructor privado para que no se pueda instanciar directamente
  DatabaseHelper._privateConstructor();

  // Singleton: Instancia única de la base de datos
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Obtener la base de datos
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Inicializa la base de datos
  _initDatabase() async {
    // Obtiene la ruta del directorio donde se almacenará la base de datos
    String path = join(await getDatabasesPath(), 'bios_lunch.db');

    // Crear la base de datos si no existe
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // Creacion de las tablas en la base de datos
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Cliente (
        cedula INTEGER PRIMARY KEY, 
        nombre TEXT NOT NULL,
        telefonoContacto TEXT NOT NULL,
        direccionEntrega TEXT NOT NULL
      );
    ''');

    await db.execute('''
      CREATE TABLE Pedido (
        idPedido INTEGER PRIMARY KEY AUTOINCREMENT,
        cedula INTEGER,
        cobrado BOOLEAN NOT NULL,
        fechaHoraRealizacion DATETIME NOT NULL,
        observaciones TEXT,
        importeTotal DECIMAL(10, 2) NOT NULL,
        estadoEntrega TEXT NOT NULL,
        FOREIGN KEY (cedula) REFERENCES Cliente(cedula)
      );
    ''');

    await db.execute('''
      CREATE TABLE Plato (
        idPlato INTEGER PRIMARY KEY AUTOINCREMENT,
        diasDisponibles TEXT NOT NULL,
        nombre TEXT NOT NULL,
        foto TEXT,
        precio DECIMAL(10, 2) NOT NULL,
        activo BOOLEAN NOT NULL
      );
    ''');

    await db.execute('''
      CREATE TABLE LineaPedido (
        idPedido INTEGER,
        idPlato INTEGER,
        cantidad INTEGER NOT NULL,
        PRIMARY KEY (idPedido, idPlato),
        FOREIGN KEY (idPedido) REFERENCES Pedido(idPedido),
        FOREIGN KEY (idPlato) REFERENCES Plato(idPlato)
      );
    ''');
  }

  // método para insertar un cliente:

  Future<int> insertCliente(Map<String, dynamic> cliente) async {
    Database db = await instance.database;
    return await db.insert('Cliente', cliente);
  }

  // Método para insertar un pedido
  Future<int> insertPedido(Map<String, dynamic> pedido) async {
    Database db = await instance.database;
    return await db.insert('Pedido', pedido);
  }

  // Método para insertar un plato
  Future<int> insertPlato(Map<String, dynamic> plato) async {
    Database db = await instance.database;
    return await db.insert('Plato', plato);
  }

  // Método para insertar una línea de pedido
  Future<int> insertLineaPedido(Map<String, dynamic> lineaPedido) async {
    Database db = await instance.database;
    return await db.insert('LineaPedido', lineaPedido);
  }
}
