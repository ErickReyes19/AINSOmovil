import 'package:accesorios_industriales_sosa/globals/widgets/snackbarglobal.helper.global.dart';
import 'package:accesorios_industriales_sosa/providers/backup.provider.dart';
import 'package:accesorios_industriales_sosa/services/backup.service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BackupController {
  final BackupService _backupService = BackupService();

  // Crear una copia de seguridad de la base de datos
  Future<bool> crearBackup(BuildContext context) async {
    final provider = Provider.of<BackupProvider>(context, listen: false);
    try {
      provider.loading = true;

      // Llamar al servicio de backup
      bool success = await _backupService.crearBackup();
      provider.loading = false;

      if (success) {
        sncackbarGlobal('Backup creado con éxito.', color: Colors.green);
        return true;
      } else {
        sncackbarGlobal('Error al crear el backup.', color: Colors.red);
        return false;
      }
    } catch (e) {
      provider.loading = false;
      print("Error al crear el backup: $e");
      sncackbarGlobal('Error al crear el backup.', color: Colors.red);
      return false;
    }
  }

  // Restaurar la base de datos desde un backup
  Future<bool> restaurarBackup(String backupPath, BuildContext context) async {
    final provider = Provider.of<BackupProvider>(context, listen: false);
    try {
      provider.loading = true;

      // Llamar al servicio de restauración de backup
      bool success = await _backupService.restaurarBackup(backupPath);
      provider.loading = false;

      if (success) {
        sncackbarGlobal('Backup restaurado con éxito.', color: Colors.green);
        return true;
      } else {
        sncackbarGlobal('Error al restaurar el backup.', color: Colors.red);
        return false;
      }
    } catch (e) {
      provider.loading = false;
      print("Error al restaurar el backup: $e");
      sncackbarGlobal('Error al restaurar el backup.', color: Colors.red);
      return false;
    }
  }
}
