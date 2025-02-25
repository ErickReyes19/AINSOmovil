// ignore_for_file: use_build_context_synchronously

import 'package:ainso/controllers/auth.controller.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../globals/widgets/widgets.dart';
import '../../providers/providers.dart';

class ActualizarUsuarioScreen extends StatefulWidget {
  final String usuario;

  const ActualizarUsuarioScreen({
    super.key,
    required this.usuario,
  });

  @override
  State<ActualizarUsuarioScreen> createState() =>
      _ActualizarUsuarioScreenState();
}

class _ActualizarUsuarioScreenState extends State<ActualizarUsuarioScreen>
    with WidgetsBindingObserver {
  late TextEditingController txtUsuario =
      TextEditingController(text: widget.usuario);
  late TextEditingController txtPass = TextEditingController();
  late TextEditingController txtPass2 = TextEditingController();
  bool verContrasena = true;
  bool verContrasena2 = true;

  @override
  void initState() {
    super.initState();
    txtUsuario = TextEditingController(text: widget.usuario);
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context).colorScheme;
    Size size = MediaQuery.of(context).size;
    final clientesProvider = Provider.of<ClientesProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    return Stack(
      children: [
        Scaffold(
          appBar: customAppBar(
              tema: tema, titulo: "Actualizar usuario", context: context),
          backgroundColor: tema.surface,
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
            child: ListView(
              children: [
                const TextParrafo(texto: 'Nombre Usuario'),
                TextField(
                  controller: txtUsuario,
                  onChanged: (String value) {},
                  style: TextStyle(color: tema.onSurface),
                  decoration: InputDecoration(
                      labelStyle:
                          GoogleFonts.poppins(color: tema.onSurface),
                      hintStyle:
                          GoogleFonts.poppins(color: tema.onSurface),
                      border: const OutlineInputBorder(),
                      hintText: "Ej: ErickR"),
                ),
                const SizedBox(
                  height: 10,
                ),
                const TextParrafo(texto: 'Nueva Contraseña'),
                TextField(
                  controller: txtPass,
                  obscureText: verContrasena,
                  style: TextStyle(color: tema.onSurface),
                  decoration: InputDecoration(
                      labelStyle:
                          GoogleFonts.poppins(color: tema.onSurface),
                      hintStyle:
                          GoogleFonts.poppins(color: tema.onSurface),
                      errorText: authProvider.error
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
                          )),
                      border: const OutlineInputBorder(),
                      hintText: 'Contraseña'),
                ),
                const SizedBox(
                  height: 10,
                ),
                const TextParrafo(texto: 'Repetir Contraseña'),
                TextField(
                  controller: txtPass2,
                  obscureText: verContrasena2,
                  style: TextStyle(color: tema.onSurface),
                  decoration: InputDecoration(
                      labelStyle:
                          GoogleFonts.poppins(color: tema.onSurface),
                      hintStyle:
                          GoogleFonts.poppins(color: tema.onSurface),
                      errorText: authProvider.error
                          ? 'Este campo es obligatorio'
                          : null,
                      errorBorder: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                          onPressed: () {
                            (!verContrasena2)
                                ? verContrasena2 = true
                                : verContrasena2 = false;
                            setState(() {});
                          },
                          icon: Icon(
                            (!verContrasena2)
                                ? Icons.remove_red_eye
                                : Icons.remove_red_eye_outlined,
                          )),
                      border: const OutlineInputBorder(),
                      hintText: 'Contraseña'),
                ),
                const SizedBox(
                  height: 10,
                ),
                ButtonXXL(
                  funcion: () async {
                
                    if (txtPass.text != txtPass2.text) {
                      alertError(context,
                          mensaje: 'Las contraseñas no coinciden');
                      return;
                    }

                    if (txtPass.text.isEmpty && txtPass2.text.isEmpty) {
                      

                      AuthController()
                          .actualizarUsuario(authProvider.password, txtUsuario.text, context)
                          .then((value) =>
                              AuthController().logoutController(context));
                      return;
                    } else {
                      AuthController()
                          .actualizarUsuario(txtPass.text, txtUsuario.text, context)
                          .then((value) =>
                              AuthController().logoutController(context));
                      return;
                    }
                  },
                  texto: 'Actualizar usuario',
                  sinMargen: true,
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
        if (clientesProvider.loading) CargandoWidget(size: size, conColor: true)
      ],
    );
  }
}
