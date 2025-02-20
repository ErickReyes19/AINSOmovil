import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class LocalDataBaseService {
  static Database? _database;
  static final LocalDataBaseService db = LocalDataBaseService._();
  LocalDataBaseService._();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDataBase();

    return _database!;
  }

  Future<Database> initDataBase() async {
    // Path donde almacenaremos la base de datos.
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'ais.db');
    // await deleteDatabase(path);

    // Creación de la base de datos.
    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        // Crear tabla Clientes con columna tipo para diferenciar entre cliente y proveedor.
        await db.execute('''CREATE TABLE Clientes(
          idCliente INTEGER PRIMARY KEY AUTOINCREMENT,
          nombreCliente TEXT,
          estado BIT,
          tipo TEXT  -- "cliente" o "proveedor"
        )''');

        // Crear tabla Facturas con relación a Cliente.
        await db.execute('''CREATE TABLE Facturas(
          idFactura INTEGER PRIMARY KEY AUTOINCREMENT,
          idCliente INTEGER,  -- Relacionado con la tabla Clientes
          numeroFactura TEXT,
          fecha DATE,
          precio DOUBLE,
          estado BIT,
          descripcion TEXT,
          FOREIGN KEY(idCliente) REFERENCES Clientes(idCliente) ON DELETE CASCADE
        )''');

        // Crear tabla Usuario.
        await db.execute('''CREATE TABLE Usuario(
          IdUsuario INTEGER PRIMARY KEY AUTOINCREMENT,
          Usuario TEXT,
          Contraseña TEXT
        )''');

        // Insertar un primer usuario.
        await db.rawInsert('''
        INSERT INTO Usuario (usuario, contraseña)
        VALUES (?, ?)
      ''', ['Usuario', '12345']);

        // Insertar algunos clientes con tipo "cliente" o "proveedor".
        await db.rawInsert('''
        INSERT INTO Clientes (nombreCliente, estado, tipo)
        VALUES (?, ?, ?)
      ''', ['Cliente Final', 1, 'Cliente']);
      
        await db.rawInsert('''
        INSERT INTO Clientes (nombreCliente, estado, tipo)
        VALUES (?, ?, ?)
      ''', ['Proveedor Final', 1, 'Proveedor']);
      },
    );
  }

  // Método para obtener la ruta de la base de datos
  Future<String> getDatabasePath() async {
    final db = await database;
    return db.path;
  }

  // Método para copiar la base de datos
  Future<void> copyDatabase(String sourcePath, String destinationPath) async {
    final File sourceFile = File(sourcePath);
    final File destinationFile = File(destinationPath);
    if (await sourceFile.exists()) {
      await sourceFile.copy(destinationFile.path);
    } else {
      throw 'El archivo fuente no existe';
    }
  }
}
