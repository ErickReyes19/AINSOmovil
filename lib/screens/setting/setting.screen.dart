import 'package:ainso/controllers/empresa.controller.dart';
import 'package:ainso/providers/auth.provider.dart';
import 'package:ainso/screens/screens.dart';
import 'package:ainso/screens/verempresa/verEmpresa.screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../globals/widgets/widgets.dart';

class GridSettingsScreen extends StatefulWidget {
  const GridSettingsScreen({super.key});

  @override
  State<GridSettingsScreen> createState() => _GridSettingsScreenState();
}

class _GridSettingsScreenState extends State<GridSettingsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final tema = Theme.of(context).colorScheme;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios, color: tema.primary),
        ),
        titleSpacing: 0,
        title: TextSecundario(
          texto: 'Configuraciones',
          colorTexto: tema.onSurface,
        ),
      ),
      backgroundColor: tema.surface,
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: size.width * 0.03,
              top: size.height * 0.02,
              right: size.width * 0.03,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    IntrinsicHeight(
                      child: Row(
                        children: [
                          Expanded(
                            child: GridItem(
                              icono: Icons.edit,
                              funcion: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => ActualizarUsuarioScreen(
                                          usuario: authProvider.nombreUsuario,
                                        ),
                                  ),
                                );
                              },
                              texto: 'Cambiar usuario y contraseña',
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: GridItem(
                              icono: Icons.cloud_upload,
                              funcion: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => BackupScreen(),
                                  ),
                                );
                              },
                              texto: 'Copia de seguridad',
                            ),
                          ),
                        ],
                      ),
                    ),
                    IntrinsicHeight(
                      child: Row(
                        children: [
                          Expanded(
                            child: GridItem(
                              icono: Icons.home,
                              funcion: () {
                                EmpresaController().traerEmpresa(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const EmpresaVisorScreen(),
                                  ),
                                );
                              },
                              texto: 'Configuración de la empresa',
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(child: Container()),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
