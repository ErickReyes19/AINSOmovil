import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:ainso/services/localdatabase.service.dart';

class BackupService {
  final LocalDataBaseService _localDataBaseService = LocalDataBaseService.db;

  // Crear un backup de la base de datos
  Future<bool> crearBackup() async {
    try {
      // Obtener la ruta de la base de datos
      final dbPath = await _localDataBaseService.getDatabasePath();
      final sourceFile = File(dbPath);

      if (!await sourceFile.exists()) {
        return false;
      }

      // Verificar y solicitar permisos de almacenamiento
      if (!await _solicitarPermisos()) {
        return false;
      }

      // Seleccionar ubicación para guardar el backup
      String? selectedPath = await FilePicker.platform.getDirectoryPath();
      if (selectedPath == null) {
        return false;
      }

      // Ruta del archivo de backup
      final backupPath = '$selectedPath/backup.db';
      await sourceFile.copy(backupPath);

      return true;
    } catch (e) {
      return false;
    }
  }

  // Restaurar la base de datos desde un backup
// Restaurar la base de datos desde un backup
Future<bool> restaurarBackup() async {
  try {
    // Seleccionar archivo de backup
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any, // Cambiado de FileType.custom a FileType.any
    );

    if (result == null || result.files.single.path == null) {
      return false;
    }

    String backupPath = result.files.single.path!;
    final backupFile = File(backupPath);

    if (!await backupFile.exists()) {
      return false;
    }

    // Obtener la ruta de la base de datos actual
    final dbPath = await _localDataBaseService.getDatabasePath();

    // Sobreescribir la base de datos con el backup
    await backupFile.copy(dbPath);
    return true;
  } catch (e) {
    return false;
  }
}


  // Compartir el archivo de backup
  Future<void> compartirBackup(BuildContext context) async {
    try {
      // Obtener la ruta del archivo de base de datos
      final dbPath = await _localDataBaseService.getDatabasePath();
      final file = File(dbPath);

      if (await file.exists()) {
        await Share.shareXFiles([XFile(file.path)], text: 'Backup de la base de datos');
      } else {
      }
    // ignore: empty_catches
    } catch (e) {
    }
  }

  // Solicitar permisos de almacenamiento
  Future<bool> _solicitarPermisos() async {
    PermissionStatus status = await Permission.storage.request();
    if (status.isGranted) return true;

    PermissionStatus manageStatus = await Permission.manageExternalStorage.request();
    return manageStatus.isGranted;
  }
}
