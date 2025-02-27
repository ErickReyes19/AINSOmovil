// ignore_for_file: depend_on_referenced_packages

import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class LocalDataBaseService {
  static Database? _database;
  static final LocalDataBaseService db = LocalDataBaseService._();
  LocalDataBaseService._();

  // Obtener la base de datos
  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDataBase();

    return _database!;
  }

  // Inicialización de la base de datos
  Future<Database> initDataBase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'ais.db');

    return await openDatabase(
      path,
      version: 2, // Mantener la versión 2 para esta ejecución
      onCreate: (Database db, int version) async {
        // Crear las tablas existentes
        await db.execute('''CREATE TABLE Clientes(
          idCliente INTEGER PRIMARY KEY AUTOINCREMENT,
          nombreCliente TEXT,
          estado BIT,
          tipo TEXT
        )''');

        await db.execute('''CREATE TABLE Facturas(
          idFactura INTEGER PRIMARY KEY AUTOINCREMENT,
          idCliente INTEGER,
          numeroFactura TEXT,
          fecha DATE,
          precio DOUBLE,
          estado BIT,
          descripcion TEXT,
          FOREIGN KEY(idCliente) REFERENCES Clientes(idCliente) ON DELETE CASCADE
        )''');

        await db.execute('''CREATE TABLE Usuario(
          IdUsuario INTEGER PRIMARY KEY AUTOINCREMENT,
          Usuario TEXT,
          Contraseña TEXT
        )''');

        // Insertar valores iniciales
        await db.rawInsert(
          '''
        INSERT INTO Usuario (usuario, contraseña)
        VALUES (?, ?)
      ''',
          ['Usuario', '12345'],
        );

        await db.rawInsert(
          '''
        INSERT INTO Clientes (nombreCliente, estado, tipo)
        VALUES (?, ?, ?)
      ''',
          ['Cliente Final', 1, 'Cliente'],
        );

        await db.rawInsert(
          '''
        INSERT INTO Clientes (nombreCliente, estado, tipo)
        VALUES (?, ?, ?)
      ''',
          ['Proveedor Final', 1, 'Proveedor'],
        );
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        if (oldVersion < 2) {
          // Agregar las nuevas columnas a la tabla Clientes sin eliminarla
          await db.execute('''ALTER TABLE Clientes ADD COLUMN rtn TEXT''');
          await db.execute('''ALTER TABLE Clientes ADD COLUMN email TEXT''');
          await db.execute('''ALTER TABLE Clientes ADD COLUMN numero TEXT''');

          await db.execute('''CREATE TABLE Cotizacion(
          idCotizacion INTEGER PRIMARY KEY AUTOINCREMENT,
          idCliente INTEGER,
          fecha DATE,
          total DOUBLE,
          subtotal DOUBLE,
          isv DOUBLE,
          numeroCotizacion TEXT,  
          tipoPago TEXT, 
          tipoCotizacion TEXT,
          FOREIGN KEY(idCliente) REFERENCES Clientes(idCliente) ON DELETE CASCADE
          )''');

          await db.execute('''CREATE TABLE ItemCotizacion(
            idItem INTEGER PRIMARY KEY AUTOINCREMENT,
            idCotizacion INTEGER,
            nombre TEXT,
            precio DOUBLE,
            descripcion TEXT,
            cantidad INTEGER,
            unidad TEXT,
            total DOUBLE,
            FOREIGN KEY(idCotizacion) REFERENCES Cotizacion(idCotizacion) ON DELETE CASCADE
          )''');

          // Crear tabla Empresa
          await db.execute('''CREATE TABLE Empresa(
      idEmpresa INTEGER PRIMARY KEY AUTOINCREMENT,
      nombre TEXT,
      direccion TEXT,
      email TEXT,
      rtn TEXT
    )''');

          // Crear tabla Telefono
          await db.execute('''CREATE TABLE Telefono(
      idTelefono INTEGER PRIMARY KEY AUTOINCREMENT,
      telefono TEXT,
      idEmpresa INTEGER,
      FOREIGN KEY(idEmpresa) REFERENCES Empresa(idEmpresa) ON DELETE CASCADE
    )''');

          // Crear tabla Banco
          await db.execute('''CREATE TABLE Banco(
      idBanco INTEGER PRIMARY KEY AUTOINCREMENT,
      banco TEXT,
      nombre TEXT,
      cuenta TEXT,
      idEmpresa INTEGER,
      FOREIGN KEY(idEmpresa) REFERENCES Empresa(idEmpresa) ON DELETE CASCADE
    )''');
        }
      },
    );
  }

  // Obtener el número de cotización correlativo
  Future<String> getNumeroCotizacion(int year) async {
    final db = await database;

    // Obtener el último número de cotización del año actual
    final result = await db.rawQuery(
      '''
      SELECT numeroCotizacion 
      FROM Cotizacion 
      WHERE numeroCotizacion LIKE ?
      ORDER BY idCotizacion DESC 
      LIMIT 1
    ''',
      ['${year.toString()}-%'],
    );

    int correlativo = 1;
    if (result.isNotEmpty) {
      // Obtener el último correlativo y sumarle 1
      final lastNumero = result.first['numeroCotizacion'] as String;
      final parts = lastNumero.split('-');
      if (parts.length == 2) {
        correlativo = int.parse(parts[1]) + 1;
      }
    }

    // Formatear el número de cotización
    return '${year.toString()}-${correlativo.toString().padLeft(4, '0')}';
  }

  // Insertar una cotización con su número correlativo
  Future<void> insertCotizacion(
    int idCliente,
    double total,
    double subtotal,
    double isv,
    String tipoPago,
    String tipoCotizacion,
  ) async {
    final db = await database;
    final year = DateTime.now().year;

    // Obtener el número de cotización
    String numeroCotizacion = await getNumeroCotizacion(year);

    // Insertar la cotización
    await db.rawInsert(
      '''
      INSERT INTO Cotizacion (idCliente, fecha, total, subtotal, isv, numeroCotizacion, tipoPago, tipoCotizacion)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?)
    ''',
      [
        DateTime.now().toString(),
        total,
        subtotal,
        isv,
        numeroCotizacion,
        tipoPago,
        tipoCotizacion,
      ],
    );
  }

  // Obtener la ruta de la base de datos
  Future<String> getDatabasePath() async {
    final db = await database;
    return db.path;
  }

  // Copiar la base de datos
  Future<void> copyDatabase(String sourcePath, String destinationPath) async {
    final File sourceFile = File(sourcePath);
    final File destinationFile = File(destinationPath);
    if (await sourceFile.exists()) {
      await destinationFile.delete();
      await sourceFile.copy(destinationFile.path);
    } else {
      throw 'El archivo fuente no existe';
    }
  }

  // Cerrar la base de datos
  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
