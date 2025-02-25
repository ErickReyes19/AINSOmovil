import 'package:ainso/controllers/clientes.controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../globals/widgets/widgets.dart';
import '../../models/models.dart';
import '../../providers/providers.dart';

class ActualizarClienteScreen extends StatefulWidget {
  final String nombreCliente;
  final bool estado;
  final int id;
  final String tipoCliente; // Agregamos tipoCliente
  final String titulo; // Agregamos tipoCliente

  const ActualizarClienteScreen({
    super.key,
    required this.nombreCliente,
    required this.estado,
    required this.id,
    required this.tipoCliente, // Añadimos tipoCliente
    required this.titulo, // Añadimos tipoCliente
  });

  @override
  State<ActualizarClienteScreen> createState() =>
      _ActualizarClienteScreenState();
}

class _ActualizarClienteScreenState extends State<ActualizarClienteScreen>
    with WidgetsBindingObserver {
  late TextEditingController txtNombreCliente =
      TextEditingController(text: widget.nombreCliente);
  late bool activos;
  late String _selectedTipoCliente; // Para el tipo de cliente

  @override
  void initState() {
    super.initState();
    txtNombreCliente = TextEditingController(text: widget.nombreCliente);
    activos = widget.estado;
    _selectedTipoCliente = widget.tipoCliente; // Inicializamos el tipo de cliente
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context).colorScheme;
    Size size = MediaQuery.of(context).size;
    final clientesProvider = Provider.of<ClientesProvider>(context);

    return Stack(
      children: [
        Scaffold(
          appBar: customAppBar(
              tema: tema, titulo: widget.titulo, context: context),
          backgroundColor: tema.surface,
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
            child: ListView(
              children: [
                const TextParrafo(texto: 'Nombre Cliente'),
                TextField(
                  controller: txtNombreCliente,
                  onChanged: (String value) {},
                  style: TextStyle(color: tema.onSurface),
                  decoration: InputDecoration(
                      labelStyle:
                          GoogleFonts.poppins(color: tema.onSurface),
                      hintStyle:
                          GoogleFonts.poppins(color: tema.onSurface),
                      border: const OutlineInputBorder(),
                      hintText: "Ej: Mario Ponce"),
                ),
                const SizedBox(
                  height: 10,
                ),
                const TextParrafo(texto: 'Tipo de Cliente'),
                DropdownButton<String>(
                  value: _selectedTipoCliente,
                  items: ['Cliente', 'Proveedor'].map((String tipo) {
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
                const SizedBox(
                  height: 10,
                ),
                const TextParrafo(texto: 'Estado'),
                Container(
                  alignment: Alignment.bottomLeft,
                  child: Switch(
                    value: activos,
                    onChanged: (value) {
                      setState(() {
                        activos = value;
                      });
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ButtonXXL(
                  funcion: () async {
                    int estado = activos ? 1 : 0; // Convertir bool a int

                    Cliente cliente = Cliente(
                      nombre: txtNombreCliente.text,
                      idCliente: widget.id,
                      estado: estado,
                      tipo: _selectedTipoCliente, // Añadir tipo de cliente
                    );

                    ClientesLocalesController()
                        .actualizarCliente(cliente, context)
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
                  texto: 'Actualizar cliente',
                  sinMargen: true,
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
        if (clientesProvider.loading)
          CargandoWidget(size: size, conColor: true)
      ],
    );
  }
}
