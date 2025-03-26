// ignore_for_file: use_build_context_synchronously

import 'package:ainso/controllers/cotizacion.controller.dart';
import 'package:ainso/models/cotizacionCliente.model.dart';
import 'package:ainso/screens/detalleCotizacion/detallecotizacion.screen.dart';
import 'package:flutter/material.dart';

import 'package:intl/date_symbol_data_local.dart';

import '../../../globals/widgets/widgets.dart';
import 'package:intl/intl.dart';

class CardCotizacion extends StatefulWidget {
  const CardCotizacion({super.key, required this.cotizacion});

  final CotizacionCliente cotizacion;

  @override
  State<CardCotizacion> createState() => _CardCotizacionState();
}

class _CardCotizacionState extends State<CardCotizacion> {
  final formatoLps = NumberFormat.currency(
    locale: 'en_US',
    symbol: 'HNL ',
    decimalDigits: 2,
  );
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
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.03,
        vertical: 10,
      ),
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: size.width * 0.03),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(3)),
        color: tema.surface,
      ),
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
                        texto: widget.cotizacion.cliente.nombre,
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
                      texto:
                          widget
                              .cotizacion
                              .cotizacion
                              .cotizacion
                              .numeroCotizacion
                              .toString(),
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
                texto: DateFormat(
                  'd MMMM y',
                  'es-MX',
                ).format(widget.cotizacion.cotizacion.cotizacion.fecha),
                colorTexto: tema.primary,
                textAlign: TextAlign.left,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextParrafo(
                texto: 'Tipo de pago: ',
                colorTexto: tema.secondary,
                textAlign: TextAlign.left,
              ),
              TextParrafo(
                texto: widget.cotizacion.cotizacion.cotizacion.tipoPago,
                colorTexto: tema.primary,
                textAlign: TextAlign.left,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextParrafo(
                texto: 'Tipo de cotización: ',
                colorTexto: tema.secondary,
                textAlign: TextAlign.left,
              ),
              TextParrafo(
                texto: widget.cotizacion.cotizacion.cotizacion.tipoCotizacion,
                colorTexto: tema.primary,
                textAlign: TextAlign.left,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextParrafo(
                texto: 'Sub Total: ',
                colorTexto: tema.secondary,
                textAlign: TextAlign.left,
              ),
              Expanded(child: Container()),
              TextParrafo(
                texto: formatoLps.format(
                  widget.cotizacion.cotizacion.cotizacion.subtotal,
                ),
                colorTexto: tema.primary,
                textAlign: TextAlign.right,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextParrafo(
                texto: 'Isv: ',
                colorTexto: tema.secondary,
                textAlign: TextAlign.left,
              ),
              Expanded(child: Container()),
              TextParrafo(
                texto: formatoLps.format(
                  widget.cotizacion.cotizacion.cotizacion.isv,
                ),
                colorTexto: tema.primary,
                textAlign: TextAlign.right,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextParrafo(
                texto: 'Total: ',
                colorTexto: tema.secondary,
                textAlign: TextAlign.left,
              ),
              Expanded(child: Container()),
              TextParrafo(
                texto: formatoLps.format(
                  widget.cotizacion.cotizacion.cotizacion.total,
                ),
                colorTexto: tema.primary,
                textAlign: TextAlign.right,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  CotizacionController().obtenerCotizacionPorId(
                    widget.cotizacion.cotizacion.cotizacion.idCotizacion,
                    context,
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetalleCotizacionScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const TextParrafo(texto: 'Ver Detalle'),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const TextParrafo(texto: 'Finalizar'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
