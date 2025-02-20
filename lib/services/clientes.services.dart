// ignore_for_file: avoid_print

import 'package:accesorios_industriales_sosa/services/services.dart';

import '../models/models.dart';

class ClientesLocalesService {
  final database = LocalDataBaseService.db.database;

  insertarClienteLocal(Cliente cliente) async {
    final db = await database;
    final res = await db.insert('Clientes', cliente.toJson());

    return res;
  }

  Future<List<Cliente>> traerAllClientesLocales() async {
    List<Cliente> listClientes = [];

    try {
      final db = await database;
      final res = await db.query('Clientes');

      if (res.isNotEmpty) {
        for (var e in res) {
          if (e.containsKey('idCliente') &&
              e.containsKey('nombreCliente') &&
              e.containsKey('estado') &&
              e.containsKey('tipo')) {
            listClientes.add(Cliente.fromJson(e));
          } else {
            print(
              'La respuesta de la consulta no tiene todas las propiedades necesarias.',
            );
          }
        }
      }
    } catch (e) {
      print('Error al traer clientes locales: $e');
    }

    return listClientes;
  }

  Future<int> actualizarClienteLocal(Cliente cliente) async {
    final db = await database;
    return await db.update(
      'Clientes',
      cliente.toJson(),
      where: 'idCliente = ?',
      whereArgs: [cliente.idCliente],
    );
  }

  // Método para traer clientes locales donde tipo sea 'Cliente'
  Future<List<Cliente>> traerClientesLocalesCliente() async {
    List<Cliente> listClientes = [];

    try {
      final db = await database;
      final res = await db.query(
        'Clientes',
        where: 'tipo = ?',
        whereArgs: ['Cliente'],
      );

      if (res.isNotEmpty) {
        for (var e in res) {
          if (e.containsKey('idCliente') &&
              e.containsKey('nombreCliente') &&
              e.containsKey('estado') &&
              e.containsKey('tipo')) {
            listClientes.add(Cliente.fromJson(e));
          } else {
            print(
              'La respuesta de la consulta no tiene todas las propiedades necesarias.',
            );
          }
        }
      }
    } catch (e) {
      print('Error al traer clientes locales de tipo Cliente: $e');
    }

    return listClientes;
  }

  // Método para traer clientes locales donde tipo sea 'Proveedor'
  Future<List<Cliente>> traerClientesLocalesProveedor() async {
    List<Cliente> listClientes = [];

    try {
      final db = await database;
      final res = await db.query(
        'Clientes',
        where: 'tipo = ?',
        whereArgs: ['Proveedor'],
      );

      if (res.isNotEmpty) {
        for (var e in res) {
          if (e.containsKey('idCliente') &&
              e.containsKey('nombreCliente') &&
              e.containsKey('estado') &&
              e.containsKey('tipo')) {
            listClientes.add(Cliente.fromJson(e));
          } else {
            print(
              'La respuesta de la consulta no tiene todas las propiedades necesarias.',
            );
          }
        }
      }
    } catch (e) {
      print('Error al traer clientes locales de tipo Proveedor: $e');
    }

    return listClientes;
  }

  // Método para traer clientes activos locales donde tipo sea 'Cliente'
  Future<List<Cliente>> traerClientesActivosLocalesCliente() async {
    List<Cliente> listClientes = [];

    try {
      final db = await database;
      final res = await db.query(
        'Clientes',
        where: 'Estado = ? AND tipo = ?',
        whereArgs: [1, 'Cliente'],
      );

      if (res.isNotEmpty) {
        for (var e in res) {
          if (e.containsKey('idCliente') &&
              e.containsKey('nombreCliente') &&
              e.containsKey('estado') &&
              e.containsKey('tipo')) {
            listClientes.add(Cliente.fromJson(e));
          } else {
            print(
              'La respuesta de la consulta no tiene todas las propiedades necesarias.',
            );
          }
        }
      }
    } catch (e) {
      print('Error al traer clientes activos locales de tipo Cliente: $e');
    }

    return listClientes;
  }

  // Método para traer clientes activos locales donde tipo sea 'Proveedor'
  Future<List<Cliente>> traerClientesActivosLocalesProveedor() async {
    List<Cliente> listClientes = [];

    try {
      final db = await database;
      final res = await db.query(
        'Clientes',
        where: 'Estado = ? AND tipo = ?',
        whereArgs: [1, 'Proveedor'],
      );

      if (res.isNotEmpty) {
        for (var e in res) {
          if (e.containsKey('idCliente') &&
              e.containsKey('nombreCliente') &&
              e.containsKey('estado') &&
              e.containsKey('tipo')) {
            listClientes.add(Cliente.fromJson(e));
          } else {
            print(
              'La respuesta de la consulta no tiene todas las propiedades necesarias.',
            );
          }
        }
      }
    } catch (e) {
      print('Error al traer clientes activos locales de tipo Proveedor: $e');
    }

    return listClientes;
  }
}
