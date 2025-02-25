import 'package:ainso/controllers/backup.controller.dart';
import 'package:flutter/material.dart';

class BackupScreen extends StatelessWidget {
  const BackupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final backupController = BackupController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Copia y respaldo"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Opciones de copia y respaldo',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),

              // Botón para generar un backup
              ElevatedButton.icon(
                onPressed: () async {
                  await backupController.crearBackup(context);
                },
                icon: const Icon(Icons.cloud_upload),
                label: const Text("Generar Backup"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: Colors.blue,
                ),
              ),
              const SizedBox(height: 20),

              // Botón para importar un backup
              ElevatedButton.icon(
                onPressed: () async {
                  // Aquí debes implementar un picker para seleccionar el archivo de backup
                  String backupPath = "/data/user/0/com.ainso.ainso/app_flutter/ais.db"; // Reemplázalo con la lógica real
                  await backupController.restaurarBackup(backupPath, context);

                },
                icon: const Icon(Icons.cloud_download),
                label: const Text("Importar Backup"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: Colors.green,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
