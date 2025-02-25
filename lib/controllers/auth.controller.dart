import 'package:ainso/models/models.dart';
import 'package:ainso/screens/home/home.screen.dart';
import 'package:ainso/screens/login/login.screen.dart';
import 'package:ainso/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

import '../globals/functions/functions.dart';
import '../globals/widgets/widgets.dart';
import '../providers/providers.dart';

class AuthController {
  final cuerpoController = CuerpoDeController();
  final AuthProvider? authProvider;
  final service = AuthService();

  AuthController({this.authProvider});

  Future<bool> loginController(String usuario, String password, context) async {
    final authprovider = Provider.of<AuthProvider>(context, listen: false);
    if (usuario.isEmpty || password.isEmpty) {
      alertError(context, mensaje: 'Por favor complete todos los campos');
      authprovider.error = true;
    } else {
      authprovider.loading = true;
      final respuesta =
          await AuthService().login(usuario.trim(), password.trim());
          
      if (respuesta == 1) {
        const storage = FlutterSecureStorage();
        storage.write(key: 'token', value: respuesta.toString());
        storage.write(key: 'user', value: usuario.trim());
        authprovider.nombreUsuario = usuario;
        authprovider.password = password;

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const HomeScreen()),
            (Route<dynamic> route) => false);
        authprovider.loading = false;
        return true;
      } else {
        switch (respuesta) {
          case 0:
            globalSnackBar('Usuario o contraseña incorrectos.');
            break;
          case 401:
            globalSnackBar(
                'Por favor inicie sesión para realizar esta acción.');
            break;
          case 500:
            alertError(context,
                mensaje:
                    'Ocurrió un error interno en el servidor al cargar la información, contacte con soporte técnico.');
            break;
          case 1200:
            alertError(context,
                mensaje: 'Ocurrió un error al cargar la información.');
            break;
          case 4501:
            alertError(context,
                mensaje:
                    'Ocurrió un error al cargar la información, verifique si:  tiene conexión a internet, los datos móviles o el wifi están activados, se encuentra conectado a una red interna sin acceso al servidor.');
            break;
          default:
        }
        authprovider.loading = false;
      }
    }
    return false;
  }

  Future<bool> actualizarUsuario(
      String contrasena, String usuarioName, context) async {
    final provider = Provider.of<AuthProvider>(context, listen: false);
    Usuario usuario =
        Usuario(idUsuario: 1, usuario: usuarioName, contrasena: contrasena);

    try {
      provider.loading = true;
      service.actualizarUsuarioLocal(usuario);
      provider.loading = false;
      sncackbarGlobal('Usuario actualizado con éxito.', color: Colors.green);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> resetUsuario(String pin, context) async {
    if (pin == '112233') {
      final provider = Provider.of<ClientesProvider>(context, listen: false);

      Usuario usuario =
          Usuario(idUsuario: 1, usuario: 'Usuario', contrasena: '12345');
      try {
        provider.loading = true;
        service.resetUsuarioLocal(usuario);
        provider.loading = false;
        sncackbarGlobal('Contraseña reseteada con éxito.', color: Colors.green);
        return true;
      } catch (e) {
        return false;
      }
    } else {
        sncackbarGlobal('Pin incorrecto.', color: Colors.red);
    }
    return false;
  }

  Future validarTokenController(context) async {
    const storage = FlutterSecureStorage();
    final authprovider = Provider.of<AuthProvider>(context, listen: false);
    final token = await storage.read(key: 'token');
    if (token != null) {
      authprovider.loading = true;
      final respuesta = await AuthService().validarTokenService(token);
      if (respuesta == 1) {
        authprovider.loading = false;
        final nombreUsuario = await storage.read(key: 'user');
        authprovider.nombreUsuario = nombreUsuario ?? '';
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const HomeScreen()));
        return true;
      }
      switch (respuesta) {
        case 0:
          logoutController(context);
          globalSnackBar('Por favor inicie sesión.');
          break;
        case 500:
          alertError(context,
              mensaje:
                  'Ocurrió un error interno cargar los datos de usuario, contacte con soporte técnico.');
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const LoginScreen()));
          break;
        case 1200:
          alertError(context,
              mensaje: 'Ocurrió un error al cargar los datos de usuario.');
          break;
        default:
      }
      authprovider.loading = false;
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const LoginScreen()));
      globalSnackBar('Por favor inicie sesión.');
    }
  }

  Future logoutController(context) async {
    try {
      const storage = FlutterSecureStorage();
      await storage.delete(key: 'token');
      await storage.delete(key: 'user');
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (Route<dynamic> route) => false);
    } catch (e) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (Route<dynamic> route) => false);
    }
    resetProviders(context);
  }
}
