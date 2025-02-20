// ignore_for_file: use_build_context_synchronously

import 'package:accesorios_industriales_sosa/controllers/facturas.controller.dart';
import 'package:accesorios_industriales_sosa/screens/screens.dart';
import 'package:flutter/material.dart';

import '../../../globals/widgets/widgets.dart';
import '../../../models/models.dart';

class CardClientes extends StatefulWidget {
  const CardClientes({super.key, required this.cliente});

  final Cliente cliente;

  @override
  State<CardClientes> createState() => _CardClientesState();
}

class _CardClientesState extends State<CardClientes> {
  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context).colorScheme;
    Size size = MediaQuery.of(context).size;
    return Container(
      padding:
          EdgeInsets.symmetric(horizontal: size.width * 0.03, vertical: 10),
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: size.width * 0.03),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(5),
          ),
          color: tema.surface),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              FacturasLocalesController()
                  .traerFacturasLocalesPorIdCliente(
                      context, widget.cliente.idCliente!)
                  .then((value) => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const FacturasVisorCliente())));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextSecundario(
                    texto: widget.cliente.nombre,
                    colorTexto: tema.onSurface,
                    textAlign: TextAlign.left,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.02, vertical: 3),
                  decoration: BoxDecoration(
                      color: widget.cliente.estado == 1
                          ? Colors.green
                          : Colors.red,
                      borderRadius:
                          BorderRadius.all(Radius.circular(size.height * 100))),
                  child: TextParrafo(
                      texto: widget.cliente.estado == 0 ? 'Inactivo' : 'Activo',
                      colorTexto: tema.onPrimary),
                ),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(8.0), backgroundColor: tema.surface),
                    onPressed: () {
                      bool estado;
                      if (widget.cliente.estado == 1) {
                        estado = true;
                      } else {
                        estado = false;
                      }
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ActualizarClienteScreen(
                                    estado: estado,
                                    id: widget.cliente.idCliente!,
                                    nombreCliente: widget.cliente.nombre,
                                    tipoCliente: widget.cliente.tipo,
                                  )));
                    },
                    child: const Text(
                      'Editar',
                    )),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
