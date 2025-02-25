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
      version: 1,
      onCreate: (Database db, int version) async {
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

        await db.rawInsert('''
        INSERT INTO Usuario (usuario, contraseña)
        VALUES (?, ?)
      ''', ['Usuario', '12345']);

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
