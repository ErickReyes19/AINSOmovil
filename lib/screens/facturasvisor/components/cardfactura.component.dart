// ignore_for_file: use_build_context_synchronously

import 'package:accesorios_industriales_sosa/controllers/facturas.controller.dart';
import 'package:accesorios_industriales_sosa/models/factura.model.dart';
import 'package:accesorios_industriales_sosa/screens/actualizarfactura/actualizarfactura.screen.dart';
import 'package:flutter/material.dart';

import 'package:intl/date_symbol_data_local.dart';

import '../../../globals/widgets/widgets.dart';
import 'package:intl/intl.dart';

class CardFactura extends StatefulWidget {
  const CardFactura({super.key, required this.factura});

  final Factura factura;

  @override
  State<CardFactura> createState() => _CardFacturaState();
}

class _CardFacturaState extends State<CardFactura> {
  final formato = NumberFormat.decimalPattern('en_us');
  @override
  void initState() {
    initializeDateFormatting('es_MX', null);
    super.initState();
  }

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
            Radius.circular(3),
          ),
          color: tema.surface),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextPrincipal(
                        texto: widget.factura.nombreCliente ?? "No disponible",
                        colorTexto: tema.secondary,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextParrafo(
                      texto: 'N° Factura: ',
                      colorTexto: tema.secondary,
                      textAlign: TextAlign.left,
                    ),
                    TextPrincipal(
                      texto: widget.factura.numeroFactura.toString(),
                      colorTexto: tema.primary,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextParrafo(
                texto: 'Fecha: ',
                colorTexto: tema.secondary,
                textAlign: TextAlign.left,
              ),
              TextParrafo(
                texto: DateFormat('d MMMM y', 'es-MX')
                    .format(widget.factura.fecha),
                colorTexto: tema.primary,
                textAlign: TextAlign.left,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextParrafo(
                texto: 'Descripción: ',
                colorTexto: tema.secondary,
                textAlign: TextAlign.left,
              ),
              TextParrafo(
                texto: widget.factura.descripcion ?? 'No Disponible',
                colorTexto: tema.primary,
                textAlign: TextAlign.left,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextParrafo(
                texto: 'Precio: ',
                colorTexto: tema.secondary,
                textAlign: TextAlign.left,
              ),
              TextParrafo(
                texto: 'Lps ${formato.format(widget.factura.precio)}',
                colorTexto: tema.primary,
                textAlign: TextAlign.left,
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => ActualizarFacturaScreen(
                                factura: widget.factura,
                              )));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                child: const TextParrafo(texto: 'Editar'),
              ),
              const SizedBox(
                width: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  dialogDecision('Cambiar Estado de factura',
                      '¿Desea cambiar el estado de la factura?', () {
                    FacturasLocalesController()
                        .cambiarEstado(context, widget.factura.idFactura!)
                        .then((value) => Navigator.pop(context))
                        .then((value) => Navigator.pop(context));
                  }, () {
                    Navigator.pop(context);
                  }, context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: const TextParrafo(texto: 'Finalizar'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
