import 'package:ainso/controllers/clientes.controller.dart';
import 'package:ainso/screens/crearcotizacion/crearcotizacion.screen.dart';
import 'package:ainso/screens/filtroCotizacionReporte/filtroCotizacion.screen.dart';
import 'package:ainso/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../controllers/controller.dart';
import '../../globals/widgets/widgets.dart';
import '../../providers/providers.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final authprovider = Provider.of<AuthProvider>(context, listen: false);
      if (authprovider.nombreUsuario.isEmpty) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context).colorScheme;
    Size size = MediaQuery.of(context).size;
    final authprovider = Provider.of<AuthProvider>(context, listen: true);

    return Scaffold(
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: GoogleFonts.poppins(
                              fontSize: 21,
                              fontWeight: FontWeight.w600,
                            ),
                            children: [
                              TextSpan(
                                text: '¡Hola ',
                                style: TextStyle(color: tema.secondary),
                              ),
                              TextSpan(
                                text: '${authprovider.nombreUsuario}!',
                                style: GoogleFonts.poppins(color: tema.primary),
                              ),
                            ],
                          ),
                        ),
                        TextParrafo(
                          texto: '¿Qué deseas hacer hoy?',
                          colorTexto: tema.secondary,
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const GridSettingsScreen(),
                          ),
                        );
                      },
                      icon: Icon(Icons.settings, color: tema.primary),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Column(
                  children: [
                    IntrinsicHeight(
                      child: Row(
                        children: [
                          Expanded(
                            child: GridItem(
                              icono: Icons.event,
                              funcion: () {
                                ClientesLocalesController()
                                    .traerClientesLocalesCliente(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const CrearFacturaScreen(),
                                  ),
                                );
                              },
                              texto: 'Crear factura',
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: GridItem(
                              icono: Icons.person_search_outlined,
                              funcion: () {
                                ClientesLocalesController()
                                    .traerClientesLocalesCliente(context);

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => const ClientesVisorScreen(
                                          titulo: "Cliente",
                                        ),
                                  ),
                                );
                              },
                              texto: 'Clientes',
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
                              icono: Icons.contact_support_outlined,
                              funcion: () {
                                ClientesLocalesController()
                                    .traerAllClientesLocales(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const FiltroFacuraScreen(),
                                  ),
                                );
                              },
                              texto: 'Consultas',
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: GridItem(
                              icono: Icons.person_search_outlined,
                              funcion: () {
                                ClientesLocalesController()
                                    .traerClientesLocalesProveedor(context);

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => const ClientesVisorScreen(
                                          titulo: "Proveedor",
                                        ),
                                  ),
                                );
                              },
                              texto: 'Proveedores',
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
                              icono: Icons.edit_document,
                              funcion: () {
                                // alertMantenimiento(context);
                                ClientesLocalesController()
                                    .traerClientesLocalesCliente(context);

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => CrearCotizacionScreen(),
                                  ),
                                );
                              },
                              texto: 'Crear cotización',
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: GridItem(
                              icono: Icons.contact_support_outlined,
                              funcion: () {
                                ClientesLocalesController()
                                    .traerAllClientesLocales(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => const FiltroCotizacionScreen(),
                                  ),
                                );
                              },
                              texto: 'Consultas',
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
                              colorContainer: tema.onSecondary,
                              icono: Icons.picture_as_pdf_outlined,
                              funcion: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => FiltroCotizacionReporteScreen(),
                                  ),
                                );
                              },
                              texto: 'Generar reporte cotización',
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: GridItem(
                              icono: Icons.logout_rounded,
                              funcion: () {
                                dialogDecision(
                                  'Cerrar sesión',
                                  '¿Está seguro que desea cerrar sesión?',
                                  () {
                                    AuthController(
                                      authProvider: authprovider,
                                    ).logoutController(context);
                                  },
                                  () {
                                    Navigator.pop(context);
                                  },
                                  context,
                                );
                              },
                              texto: 'Cerrar Sesión',
                            ),
                          ),
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
