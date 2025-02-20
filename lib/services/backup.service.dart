import 'dart:io';
import 'package:accesorios_industriales_sosa/services/localdatabase.service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class BackupService {
  final LocalDataBaseService _localDataBaseService = LocalDataBaseService.db;

  // Crear una copia de seguridad de la base de datos
  Future<bool> crearBackup() async {
    try {
      // Obtener la ruta interna donde se encuentra la base de datos
      final dbPath = await _localDataBaseService.getDatabasePath();
      print("Ruta de la base de datos: $dbPath");

      // Verificar que la base de datos exista
      final sourceFile = File(dbPath);
      if (!await sourceFile.exists()) {
        print("La base de datos no existe en la ruta: $dbPath");
        return false;
      }

      // Verificar permisos para el almacenamiento externo
      bool hasPermission = await Permission.manageExternalStorage.request().isGranted;
      if (!hasPermission) {
        print("No tiene permisos para acceder al almacenamiento externo.");
        return false;
      }

      // Obtener la ruta de almacenamiento externo
      final externalDir = await getExternalStorageDirectory();
      if (externalDir == null) {
        print("No se pudo acceder al almacenamiento externo.");
        return false;
      }

      // Crear la carpeta de backups
      final backupDir = Directory('${externalDir.path}/backups');
      if (!await backupDir.exists()) {
        await backupDir.create();
      }

      // Ruta del archivo de backup
      final backupPath = '${backupDir.path}/backup.db';
      print("Ruta del backup: $backupPath");

      // Copiar la base de datos al almacenamiento externo
      await _localDataBaseService.copyDatabase(dbPath, backupPath);
      print("Backup creado con éxito.");

      return true;
    } catch (e) {
      print("Error al crear el backup: $e");
      return false;
    }
  }

  // Restaurar la base de datos desde un backup
  Future<bool> restaurarBackup(String backupPath) async {
    try {
      // Obtener la ruta de la base de datos actual
      final dbPath = await _localDataBaseService.getDatabasePath();
      print("Ruta de la base de datos actual: $dbPath");

      // Verificar si el archivo de backup existe
      final backupFile = File(backupPath);
      if (!await backupFile.exists()) {
        print("El archivo de backup no existe en la ruta: $backupPath");
        return false;
      }

      // Copiar el archivo de backup a la ruta de la base de datos
      await _localDataBaseService.copyDatabase(backupPath, dbPath);
      print("Backup restaurado con éxito.");

      return true;
    } catch (e) {
      print("Error al restaurar el backup: $e");
      return false;
    }
  }
}
