import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class BaseDatos {
  static Database? _database;

  // Singleton: Instancia única de la base de datos
  static final BaseDatos instance = BaseDatos._inicializar();

  Database? _baseDeDatos;

  BaseDatos._inicializar();

  factory BaseDatos() {
    //El constructor es sin nombre, por defecto
    return instance;
  }

  Future<Database> obtenerBaseDatos() async {
    if (_baseDeDatos != null) return _baseDeDatos!;

    final String rutasDirectoriosBDs =
        await getDatabasesPath(); //Tenemos la ruta absoluta de el directorio deonde estaría la BD
    final String rutaArchivoBD = join(rutasDirectoriosBDs, "bios_lunch.sqlite");

    _baseDeDatos = await openDatabase(
      rutaArchivoBD,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE Cliente (
            cedula TEXT PRIMARY KEY, 
            nombre TEXT NOT NULL,
            telefonoContacto TEXT NOT NULL,
            direccionEntrega TEXT NOT NULL
          );
        ''');

        await db.execute('''
          CREATE TABLE Pedido (
            idPedido INTEGER PRIMARY KEY AUTOINCREMENT,
            cedula TEXT NOT NULL,
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
      },
      onOpen: (db) {
        //En SQLite, las reestricciones foraneas estan deshabilitadas de manera predeterminada por cuestiones de retrocompatibilidad
        //Para habilitarla en la conexion actual:
        db.execute(
            'PRAGMA foreign_keys = ON;'); //Solo se ejecuta cuando abrimos la bd por primera vez porque esta en el onOpen
      },
    );

    return _baseDeDatos!;
  }

  Future<void> cerrarBaseDatos() async {
    await _baseDeDatos?.close(); //Si no es nulo

    _baseDeDatos = null;
  }
}
