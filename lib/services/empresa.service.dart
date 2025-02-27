// ignore_for_file: avoid_print

import 'package:ainso/services/services.dart';
import '../models/models.dart';

class EmpresaLocalesService {
  final database = LocalDataBaseService.db.database;

  Future<int> insertarEmpresa(Empresa empresa) async {
    final db = await database;

    try {
      final idEmpresa = await db.insert('Empresa', {
        'nombre': empresa.nombre,
        'direccion': empresa.direccion,
        'email': empresa.email,
        'rtn': empresa.rtn,
      });

      for (var banco in empresa.bancos) {
        await db.insert('Banco', {
          'banco': banco.banco,
          'nombre': banco.nombre,
          'cuenta': banco.cuenta,
          'idEmpresa': idEmpresa, 
        });
      }

      for (var telefono in empresa.telefonos) {
        await db.insert('Telefono', {
          'telefono': telefono.telefono,
          'idEmpresa': idEmpresa, 
        });
      }

      return idEmpresa; 
    } catch (e) {
      print('Error al insertar la empresa: $e');
      return -1; 
    }
  }

  Future<Empresa?> traerEmpresaLocal() async {
    try {
      final db = await database;
      final res = await db.query('Empresa', limit: 1);

      if (res.isNotEmpty) {
        var e = res.first;
        int idEmpresa = e['idEmpresa'] as int;

        final bancosRes = await db.query(
          'Banco',
          where: 'idEmpresa = ?',
          whereArgs: [idEmpresa],
        );
        List<Banco> bancos = bancosRes.map((b) => Banco.fromJson(b)).toList();

        final telefonosRes = await db.query(
          'Telefono',
          where: 'idEmpresa = ?',
          whereArgs: [idEmpresa],
        );
        List<Telefono> telefonos =
            telefonosRes.map((t) => Telefono.fromJson(t)).toList();

        return Empresa.fromJson({
          ...e, 
          'bancos': bancos.map((b) => b.toJson()).toList(),
          'telefonos': telefonos.map((t) => t.toJson()).toList(),
        });
      }
    } catch (e) {
      print('Error al traer la empresa local: $e');
    }

    return null;
  }

  /// Método para editar la empresa:
  /// - Actualiza los datos básicos de la tabla Empresa.
  /// - Elimina los registros anteriores de Banco y Telefono asociados al idEmpresa.
  /// - Reinserta los bancos y teléfonos proporcionados.
  Future<int> editarEmpresa(Empresa empresa) async {
    final db = await database;
    try {
      // Actualiza los campos básicos de la empresa.
      int count = await db.update(
        'Empresa',
        {
          'nombre': empresa.nombre,
          'direccion': empresa.direccion,
          'email': empresa.email,
          'rtn': empresa.rtn,
        },
        where: 'idEmpresa = ?',
        whereArgs: [empresa.idEmpresa],
      );

      // Reemplazar bancos: eliminar los existentes y reinserta los nuevos.
      await db.delete('Banco', where: 'idEmpresa = ?', whereArgs: [empresa.idEmpresa]);
      for (var banco in empresa.bancos) {
        await db.insert('Banco', {
          'banco': banco.banco,
          'nombre': banco.nombre,
          'cuenta': banco.cuenta,
          'idEmpresa': empresa.idEmpresa,
        });
      }

      // Reemplazar teléfonos: eliminar los existentes y reinserta los nuevos.
      await db.delete('Telefono', where: 'idEmpresa = ?', whereArgs: [empresa.idEmpresa]);
      for (var telefono in empresa.telefonos) {
        await db.insert('Telefono', {
          'telefono': telefono.telefono,
          'idEmpresa': empresa.idEmpresa,
        });
      }

      return count; // Retorna la cantidad de filas afectadas en la tabla Empresa.
    } catch (e) {
      print('Error al editar la empresa: $e');
      return -1;
    }
  }
}
