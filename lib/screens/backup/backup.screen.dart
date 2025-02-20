import 'package:accesorios_industriales_sosa/controllers/backup.controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BackupScreen extends StatelessWidget {
  const BackupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final backupController = BackupController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Backup & Restore"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Backup & Restore Options',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),

              // Botón para generar un backup
              ElevatedButton.icon(
                onPressed: () async {
                  bool result = await backupController.crearBackup(context);
                  if (result) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Backup generado con éxito.")),
                    );
                  }
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
                  String backupPath = "/data/user/0/com.example.accesorios_industriales_sosa/app_flutter/ais.db"; // Reemplázalo con la lógica real
                  bool result = await backupController.restaurarBackup(backupPath, context);
                  if (result) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Backup restaurado con éxito.")),
                    );
                  }
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
