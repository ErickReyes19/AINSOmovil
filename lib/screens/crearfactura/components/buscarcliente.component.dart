import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../models/models.dart';
import '../../../providers/providers.dart';

class BuscadorClientes extends StatefulWidget {
  const BuscadorClientes({super.key});

  @override
  State<BuscadorClientes> createState() => _BuscadorClientesState();
}

class _BuscadorClientesState extends State<BuscadorClientes> {
  late TextEditingController controllerBusqueda = TextEditingController();
  String _displayStringForOption(Cliente cliente) => cliente.nombre;
  List<Cliente> listClientes = [];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context).colorScheme;
    final clientesProvider = Provider.of<ClientesProvider>(context);
    return Autocomplete<Cliente>(
        fieldViewBuilder: (BuildContext context, fieldTextEditingController,
            fieldFocusNode, onFieldSubmitted) {
          return TextField(
            style: TextStyle(color: tema.secondary),
            onTap: () {
              clientesProvider.idClienteSelected = 0;
            },
            controller: fieldTextEditingController,
            focusNode: fieldFocusNode,
            onChanged: (String value) {
              controllerBusqueda.text = value;
            },
            decoration: InputDecoration(
                hintStyle: GoogleFonts.poppins(color: tema.primary),
                border: const OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 1,
                  ),
                ),
                hintText: 'Ej. Otoniel Reyes'),
          );
        },
        displayStringForOption: _displayStringForOption,
        onSelected: (Cliente seleccion) {
          clientesProvider.idClienteSelected = seleccion.idCliente!;

          setState(() {});
        },
        optionsBuilder: (TextEditingValue textEditingValue) {
          if (textEditingValue.text == '') {
            return clientesProvider.listCliente;
          }
          return clientesProvider.listCliente.where((cliente) => cliente.nombre
              .toUpperCase()
              .contains(textEditingValue.text.toUpperCase()));
        });
  }
}
