// ignore_for_file: avoid_print

import 'package:ainso/models/factura.model.dart';
import 'package:ainso/services/services.dart';
import 'package:intl/intl.dart';

class FacturasLocalesService {
  final database = LocalDataBaseService.db.database;

  insertarFacturaLocal(Factura factura) async {
    final db = await database;
    final res = await db.insert('Facturas', factura.toJson());
    return res;
  }

  Future<int> actualizarFacturaLocal(Factura factura) async {
    final db = await database;
    print(factura.toJson());
    try {
      print(factura.idFactura);

      return await db.update(
        'Facturas',
        factura.toJson(),
        where: 'idFactura = ?',
        whereArgs: [factura.idFactura],
      );
    } catch (e) {
      print("error : $e");
    }
    return 0;
  }

Future<List<Factura>> traerFacturasLocalesCliente(
    DateTime fechaDesde, DateTime fechaHasta, int idCliente) async {
  List<Factura> listFactura = [];

  try {
    final db = await database;
    // Construir la cláusula WHERE base por fecha
    String whereClause = 'Fecha BETWEEN ? AND ?';
    List<dynamic> whereArgs = [
      DateFormat('yyyy-MM-dd').format(fechaDesde),
      DateFormat('yyyy-MM-dd').format(fechaHasta),
    ];

    // Filtrar por cliente específico si se proporciona
    if (idCliente != 0) {
      whereClause += ' AND Facturas.idCliente = ?';
      whereArgs.add(idCliente);
    }

    // Filtrar por tipo "Cliente"
    whereClause += ' AND Clientes.tipo = ?';
    whereArgs.add('Cliente');

    final res = await db.rawQuery('''
      SELECT Facturas.*, Clientes.nombreCliente 
      FROM Facturas
      INNER JOIN Clientes ON Facturas.idCliente = Clientes.idCliente
      WHERE $whereClause AND Facturas.estado = 0
    ''', whereArgs);

    if (res.isNotEmpty) {
      for (var e in res) {
        listFactura.add(Factura.fromJson(e));
      }
    }
  } catch (e) {
    print('Error al traer facturas locales para Cliente: $e');
  }

  return listFactura;
}

Future<List<Factura>> traerFacturasLocalesProveedor(
    DateTime fechaDesde, DateTime fechaHasta, int idCliente) async {
  List<Factura> listFactura = [];

  try {
    final db = await database;
    // Construir la cláusula WHERE base por fecha
    String whereClause = 'Fecha BETWEEN ? AND ?';
    List<dynamic> whereArgs = [
      DateFormat('yyyy-MM-dd').format(fechaDesde),
      DateFormat('yyyy-MM-dd').format(fechaHasta),
    ];

    // Filtrar por cliente específico si se proporciona
    if (idCliente != 0) {
      whereClause += ' AND Facturas.idCliente = ?';
      whereArgs.add(idCliente);
    }

    // Filtrar por tipo "Proveedor"
    whereClause += ' AND Clientes.tipo = ?';
    whereArgs.add('Proveedor');

    final res = await db.rawQuery('''
      SELECT Facturas.*, Clientes.nombreCliente 
      FROM Facturas
      INNER JOIN Clientes ON Facturas.idCliente = Clientes.idCliente
      WHERE $whereClause AND Facturas.estado = 0
    ''', whereArgs);

    if (res.isNotEmpty) {
      for (var e in res) {
        listFactura.add(Factura.fromJson(e));
      }
    }
  } catch (e) {
    print('Error al traer facturas locales para Proveedor: $e');
  }

  return listFactura;
}


  Future<void> cambiarEstadoFactura(int idFactura) async {
    try {
      final db = await database;

      await db.update(
        'Facturas',
        {'estado': 1},
        where: 'IdFactura = ?',
        whereArgs: [idFactura],
      );
    } catch (e) {
      print('Error al cambiar el estado de la factura: $e');
    }
  }

  Future<List<Factura>> traerFacturasLocalesPorId(int idCliente) async {
    List<Factura> listFactura = [];

    try {
      final db = await database;

      final res = await db.rawQuery('''
      SELECT Facturas.*, Clientes.nombreCliente 
      FROM Facturas
      INNER JOIN Clientes ON Facturas.idCliente = Clientes.idCliente
      WHERE Facturas.idCliente = ? AND Facturas.estado = 0
    ''', [idCliente]);

      if (res.isNotEmpty) {
        for (var e in res) {
          listFactura.add(Factura.fromJson(e));
        }
      }
    } catch (e) {
      print('Error al traer facturas locales: $e');
    }

    return listFactura;
  }
}
