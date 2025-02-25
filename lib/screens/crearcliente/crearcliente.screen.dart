// ignore_for_file: use_build_context_synchronously

import 'package:ainso/controllers/clientes.controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../globals/widgets/widgets.dart';
import '../../models/models.dart';
import '../../providers/providers.dart';

class CrearClienteScreen extends StatefulWidget {
  final String titulo;
  const CrearClienteScreen({super.key, required this.titulo});

  @override
  State<CrearClienteScreen> createState() => _CrearClienteScreenState();
}

class _CrearClienteScreenState extends State<CrearClienteScreen>
    with WidgetsBindingObserver {
  late TextEditingController txtNombreCliente = TextEditingController();
  String _selectedTipoCliente = 'Cliente'; // Usamos cadena en lugar de enum

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context).colorScheme;
    Size size = MediaQuery.of(context).size;
    final clientesProvider = Provider.of<ClientesProvider>(context);

    return SafeArea(
      child: Stack(
        children: [
          Scaffold(
            appBar: customAppBar(
              tema: tema,
              titulo: widget.titulo,
              context: context,
            ),
            backgroundColor: tema.surface,
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
              child: ListView(
                children: [
                  TextParrafo(
                    fontWeight: FontWeight.bold,
                    colorTexto: tema.primary,
                    texto: 'Nombre Cliente',
                  ),
                  TextField(
                    controller: txtNombreCliente,
                    onChanged: (String value) {},
                    style: TextStyle(color: tema.primary),
                    decoration: InputDecoration(
                      labelStyle: GoogleFonts.poppins(color: tema.onSurface),
                      hintStyle: GoogleFonts.poppins(color: tema.primary),
                      border: const OutlineInputBorder(),
                      hintText: "Ej: Mario Ponce",
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextParrafo(
                    fontWeight: FontWeight.bold,
                    colorTexto: tema.primary,
                    texto: 'Tipo de Cliente',
                  ),
                  DropdownButton<String>(
                    value: _selectedTipoCliente,
                    items:
                        ['Cliente', 'Proveedor'].map((String tipo) {
                          return DropdownMenuItem<String>(
                            value: tipo,
                            child: Text(
                              tipo,
                              style: GoogleFonts.poppins(color: tema.primary),
                            ),
                          );
                        }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedTipoCliente = newValue!;
                      });
                    },
                    isExpanded: true,
                    dropdownColor: tema.surface,
                    style: TextStyle(color: tema.primary),
                  ),
                  const SizedBox(height: 10),
                  ButtonXXL(
                    funcion: () async {
                      if (txtNombreCliente.text.isEmpty) {
                        alertError(
                          context,
                          mensaje: "Debe de colocar un nombre",
                        );
                        return;
                      }

                      Cliente cliente = Cliente(
                        nombre: txtNombreCliente.text,
                        estado: 1,
                        tipo:
                            _selectedTipoCliente, 
                      );

                      ClientesLocalesController()
                          .insertarCliente(cliente, context)
                          .then((value) => clientesProvider.resetProvider())
                          .then((value) {
                            // Verificar el tipo de cliente y hacer la consulta correspondiente
                            if (_selectedTipoCliente == 'Cliente') {
                              return ClientesLocalesController()
                                  .traerClientesLocalesCliente(context);
                            } else {
                              return ClientesLocalesController()
                                  .traerClientesLocalesProveedor(context);
                            }
                          })
                          .then((value) => Navigator.pop(context));
                    },
                    texto: 'Crear cliente',
                    sinMargen: true,
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
          if (clientesProvider.loading)
            CargandoWidget(size: size, conColor: true),
        ],
      ),
    );
  }
}
