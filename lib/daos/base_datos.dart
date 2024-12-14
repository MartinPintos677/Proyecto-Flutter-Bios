import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class BaseDatos {
  // Singleton: Instancia única de la base de datos
  static final BaseDatos instance = BaseDatos._inicializar();

  Database? _baseDeDatos;

  BaseDatos._inicializar();

  factory BaseDatos() {
    return instance;
  }

  Future<Database> obtenerBaseDatos() async {
    if (_baseDeDatos != null) return _baseDeDatos!;

    final String rutasDirectoriosBDs = await getDatabasesPath();
    final String rutaArchivoBD = join(rutasDirectoriosBDs, "bios_lunch.sqlite");

    // **Elimina la base de datos existente para forzar la recreación**
    await deleteDatabase(rutaArchivoBD);

    _baseDeDatos = await openDatabase(
      rutaArchivoBD,
      version: 1,
      onCreate: (db, version) async {
        print("Creando la base de datos...");
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

        print("Insertando datos de prueba...");
        await db.execute('''
          INSERT INTO Cliente (cedula, nombre, telefonoContacto, direccionEntrega)
          VALUES
            ('12345678', 'Juan Pérez', '123456789', 'Av. Libertador 123'),
            ('87654321', 'Ana López', '987654321', 'Calle Ficticia 456'),
            ('11223344', 'Carlos García', '112233445', 'Calle Real 789'),
            ('34567890', 'María Fernández', '543216789', 'Av. Italia 345'),
            ('98765432', 'José Rodríguez', '987654987', 'Calle Artigas 789'),
            ('45678901', 'Lucía Martínez', '456789123', 'Calle Rivera 123'),
            ('23456789', 'Sofía Gómez', '234567890', 'Av. Ricaldoni 678'),
            ('56789012', 'Ricardo López', '567890123', 'Calle 18 de Julio 456'),
            ('67890123', 'Martina Silva', '678901234', 'Calle Sarandí 987'),
            ('89012345', 'Julieta Méndez', '890123456', 'Calle Piedras 345');
        ''');

        await db.execute('''
  INSERT INTO Plato (diasDisponibles, nombre, foto, precio, activo)
  VALUES
    ('Lunes,Miércoles,Viernes', 'Pasta', NULL, 150.00, 1),
    ('Martes,Jueves,Sábado', 'Ensalada', NULL, 100.00, 1),
    ('Todos', 'Hamburguesa', NULL, 200.00, 1),
    ('Lunes,Martes', 'Pizza', NULL, 180.00, 1),
    ('Viernes,Sábado', 'Chivito', NULL, 250.00, 1),
    ('Domingo', 'Milanesa con papas fritas', NULL, 220.00, 1),
    ('Todos', 'Tarta de verduras', NULL, 120.00, 1),
    ('Lunes,Miércoles', 'Sopa de lentejas', NULL, 130.00, 1),
    ('Martes,Jueves', 'Risotto', NULL, 180.00, 1),
    ('Viernes', 'Pescado a la parrilla', NULL, 270.00, 1);
''');

        await db.execute('''
          INSERT INTO Pedido (cedula, cobrado, fechaHoraRealizacion, observaciones, importeTotal, estadoEntrega)
          VALUES
            ('12345678', 0, '2024-12-01 10:00:00', 'Sin observaciones', 500.00, 'Pendiente'),
            ('12345678', 0, '2024-12-02 11:00:00', 'Entrega urgente', 300.00, 'Pendiente'),
            ('87654321', 1, '2024-12-03 12:00:00', NULL, 200.00, 'Entregado');
        ''');

        await db.execute('''
          INSERT INTO LineaPedido (idPedido, idPlato, cantidad)
          VALUES
            (1, 1, 2),
            (1, 2, 1),
            (2, 1, 1),
            (2, 3, 2),
            (3, 4, 1);
        ''');
        print("Datos de prueba insertados.");
      },
      onOpen: (db) {
        db.execute('PRAGMA foreign_keys = ON;');
        print("Base de datos abierta.");
      },
    );

    return _baseDeDatos!;
  }

  Future<void> cerrarBaseDatos() async {
    await _baseDeDatos?.close();
    _baseDeDatos = null;
  }
}
