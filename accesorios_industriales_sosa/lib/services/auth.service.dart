import 'dart:async';
import 'dart:io';

import 'package:accesorios_industriales_sosa/models/models.dart';
import 'package:http/http.dart' as http;

import 'services.dart';

class AuthService {

   final database = LocalDataBaseService.db.database;


  Future login(String usuario, String password) async {
    try {
      final database = await LocalDataBaseService.db.database;

      // Consultar la base de datos para encontrar un usuario con las credenciales proporcionadas
      final List<Map<String, dynamic>> response = await database.query(
        'Usuario',
        where: 'usuario = ? AND contraseña = ?',
        whereArgs: [usuario, password],
      );

      if (response.isNotEmpty) {
        return 1;
      }
      if (response.isEmpty) {
        return 0;
      }
    } catch (e) {
      http.Client().close();
      if (e is TimeoutException) {
        return 4500;
      }
      if (e is SocketException) {
        return 4501;
      }
      return 1200;
    } finally {
      http.Client().close();
    }
  }

  Future<int> actualizarUsuarioLocal(Usuario usuario) async {
    final db = await database;
    return await db.update(
      'Usuario',
      usuario.toJson(),
      where: 'IdUsuario = ?',
      whereArgs: [1],
    );
  }
  
  Future<int> resetUsuarioLocal(Usuario usuario) async {
    final db = await database;
    return await db.update(
      'Usuario',
      usuario.toJson(),
      where: 'IdUsuario = ?',
      whereArgs: [1],
    );
  }

  Future validarTokenService(String token) async {
    try {
      if (token == "1") {
        return 1;
      } else {
        return 0;
      }
    } catch (e) {
      http.Client().close();
      if (e is TimeoutException) {
        return 4500;
      }
      if (e is SocketException) {
        return 4501;
      }
      return 1200;
    } finally {
      http.Client().close();
    }
  }
}
