// ignore_for_file: avoid_print

import 'package:ainso/cosntans.dart';
import 'package:ainso/globals/widgets/dialogtext.widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_auth/local_auth.dart'; // Agregado
import 'package:provider/provider.dart';

import '../../controllers/controller.dart';
import '../../globals/widgets/widgets.dart';
import '../../providers/providers.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController txtUser = TextEditingController(text: '');
  TextEditingController txtPass = TextEditingController(text: '');
  bool verContrasena = true;

  final LocalAuthentication auth = LocalAuthentication(); // Agregado

  Future<void> _authenticateWithBiometrics() async {
    // Agregado
    try {
      bool canCheckBiometrics = await auth.canCheckBiometrics;
      bool isAuthenticated = false;
      if (canCheckBiometrics) {
        isAuthenticated = await auth.authenticate(
          localizedReason: 'Autentíquese con su huella digital',
          options: const AuthenticationOptions(biometricOnly: true),
        );
      }
      if (isAuthenticated) {
        // Al autenticar con huella se mandan credenciales fijas
        AuthController().loginController("Usuario", "12345", context);
      }
    } catch (e) {
      print("Error en autenticación biométrica: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final tema = Theme.of(context).colorScheme;
    final authprovider = Provider.of<AuthProvider>(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: tema.surface,
        body: Stack(
          children: [
            ListView(
              children: [
                SizedBox(height: size.height * 0.04),
                Center(
                  child: Image.asset(
                    AppAssets().logoAppWhite,
                    width: size.width * 0.5,
                    height: size.height * 0.25,
                  ),
                ),
                SizedBox(height: size.height * 0.08),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      TextPrincipal(
                        texto: 'Autenticación',
                        colorTexto: tema.primary,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Ingrese sus credenciales para acceder.',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: size.width * 0.05,
                    bottom: size.height * 0.01,
                    left: size.width * 0.04,
                    right: size.width * 0.04,
                  ),
                  child: TextField(
                    controller: txtUser,
                    onChanged: (String value) {
                      if (value.isNotEmpty && authprovider.error) {
                        authprovider.error = false;
                      }
                    },
                    style: TextStyle(color: tema.onSurface),
                    decoration: InputDecoration(
                      labelStyle: GoogleFonts.poppins(color: tema.onSurface),
                      hintStyle: GoogleFonts.poppins(color: tema.onSurface),
                      errorText:
                          authprovider.error
                              ? 'Este campo es obligatorio'
                              : null,
                      border: const OutlineInputBorder(),
                      hintText: 'Usuario',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
                  child: TextField(
                    controller: txtPass,
                    obscureText: verContrasena,
                    style: TextStyle(color: tema.onSurface),
                    decoration: InputDecoration(
                      labelStyle: GoogleFonts.poppins(color: tema.onSurface),
                      hintStyle: GoogleFonts.poppins(color: tema.onSurface),
                      errorText:
                          authprovider.error
                              ? 'Este campo es obligatorio'
                              : null,
                      errorBorder: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        onPressed: () {
                          (!verContrasena)
                              ? verContrasena = true
                              : verContrasena = false;
                          setState(() {});
                        },
                        icon: Icon(
                          (!verContrasena)
                              ? Icons.remove_red_eye
                              : Icons.remove_red_eye_outlined,
                        ),
                      ),
                      border: const OutlineInputBorder(),
                      hintText: 'Contraseña',
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                GestureDetector(
                  onTap: () {
                    dialogText(context);
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.04,
                    ),
                    child: TextParrafo(
                      colorTexto: tema.primary,
                      textAlign: TextAlign.right,
                      texto: 'Olvide mi contraseña',
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.10),
                ButtonXXL(
                  funcion: () {
                    AuthController().loginController(
                      txtUser.text.trim(),
                      txtPass.text.trim(),
                      context,
                    );
                  },
                  texto: 'Iniciar sesión',
                  colorTexto: tema.surface,
                ),
                // Botón de huella dactilar agregado
                Center(
                  child: IconButton(
                    icon: Icon(
                      Icons.fingerprint,
                      size: 40,
                      color: tema.primary,
                    ),
                    onPressed: _authenticateWithBiometrics,
                  ),
                ),
                SizedBox(height: size.height * 0.02),
              ],
            ),
            if (authprovider.loading)
              Container(
                color: Colors.black12,
                width: size.width,
                height: size.height,
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }
}
