import 'package:ainso/models/models.dart';
import 'package:ainso/providers/providers.dart';
import 'package:ainso/services/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../globals/widgets/widgets.dart';

class EmpresaController {
  final service = EmpresaLocalesService();

  Future<bool> insertarEmpresa(Empresa empresa, BuildContext context) async {
    final provider = Provider.of<EmpresaProvider>(context, listen: false);
    try {
      provider.loading = true;
      await service.insertarEmpresa(empresa);
      provider.empresa = empresa;
      provider.loading = false;
      sncackbarGlobal('Empresa agregada con éxito.', color: Colors.green);
      return true;
    } catch (e) {
      provider.loading = false;
      sncackbarGlobal('Error al agregar la empresa.', color: Colors.red);
      return false;
    }
  }

  Future<bool> traerEmpresa(BuildContext context) async {
    final provider = Provider.of<EmpresaProvider>(context, listen: false);
    try {
      provider.loading = true;
      provider.empresa = await service.traerEmpresaLocal();
      provider.loading = false;
      return true;
    } catch (e) {
      provider.empresa = null;
      provider.loading = false;
      return false;
    }
  }

  /// Método para editar la empresa
  Future<bool> editarEmpresa(Empresa empresa, BuildContext context) async {
    final provider = Provider.of<EmpresaProvider>(context, listen: false);
    try {
      provider.loading = true;
      int result = await service.editarEmpresa(empresa);

      if (result > 0) {
        provider.empresa = empresa; // Actualiza los datos de la empresa en el provider
        sncackbarGlobal('Empresa actualizada con éxito.', color: Colors.green);
        provider.loading = false;
        return true;
      } else {
        provider.loading = false;
        sncackbarGlobal('Error al actualizar la empresa.', color: Colors.red);
        return false;
      }
    } catch (e) {
      provider.loading = false;
      sncackbarGlobal('Error al editar la empresa.', color: Colors.red);
      return false;
    }
  }
}
