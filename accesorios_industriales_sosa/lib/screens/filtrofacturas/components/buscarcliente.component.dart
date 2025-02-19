
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/models.dart';
import '../../../providers/clientes.provider.dart';

class BuscadorClientesTodos extends StatefulWidget {
  const BuscadorClientesTodos({super.key});

  @override
  State<BuscadorClientesTodos> createState() => _BuscadorClientesTodosState();
}

class _BuscadorClientesTodosState extends State<BuscadorClientesTodos> {
  TextEditingController controllerBusqueda = TextEditingController();
  String _displayStringForOption(Cliente cliente) => cliente.nombre;
  List<Cliente> listClientes = [];
  @override
  Widget build(BuildContext context) {
    final clientesProvider = Provider.of<ClientesProvider>(context);
    return Autocomplete<Cliente>(
        fieldViewBuilder: (BuildContext context, fieldTextEditingController,
            fieldFocusNode, onFieldSubmitted) {
          return TextField(
            controller: fieldTextEditingController,
            focusNode: fieldFocusNode,
            onChanged: (String value) {
              controllerBusqueda.text = value;
            },
            decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 1,
                  ),
                ),
                hintText: 'TODOS'),
          );
        },
        displayStringForOption: _displayStringForOption,
        onSelected: (Cliente seleccion) {
          clientesProvider.idClienteSelected = seleccion.idCliente!;
        },
        optionsBuilder: (TextEditingValue textEditingValue) {
          if (textEditingValue.text == '') {
            clientesProvider.idClienteSelected = 0;
            return listClientes;
          }
          return clientesProvider.listCliente.where((cliente) => cliente
              .nombre
              .toUpperCase()
              .contains(textEditingValue.text.toUpperCase()));
        });
  }
}