import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ainso/providers/backup.provider.dart';
import 'package:ainso/services/backup.service.dart';
import 'package:ainso/globals/widgets/snackbarglobal.helper.global.dart';

class BackupController {
  final BackupService _backupService = BackupService();

  // Crear un backup de la base de datos
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
      bool success = await _backupService.restaurarBackup();
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
      sncackbarGlobal('Error al restaurar el backup.', color: Colors.red);
      return false;
    }
  }

  // Compartir la base de datos como backup
  Future<void> compartirBackup(BuildContext context) async {
    await _backupService.compartirBackup(context);
  }
}
