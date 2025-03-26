import 'package:ainso/controllers/empresa.controller.dart';
import 'package:ainso/globals/widgets/generarpdf.widget.dart';
import 'package:ainso/globals/widgets/generarpdfreporte.widget.dart';
import 'package:ainso/globals/widgets/widgets.dart';
import 'package:ainso/models/models.dart';
import 'package:ainso/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class DetalleCotizacionScreen extends StatelessWidget {
  const DetalleCotizacionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cotizacionCliente =
        Provider.of<CotizacionProvider>(context).cotizacionCliente;
    final empresa =
        Provider.of<EmpresaProvider>(context).empresa;

    if (cotizacionCliente == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Detalle de Cotización")),
        body: const Center(child: Text("No se encontró la cotización.")),
      );
    }

    final cotizacion = cotizacionCliente.cotizacion;
    final cliente = cotizacionCliente.cliente;
    final items = cotizacion.items;

    final tema = Theme.of(context).colorScheme;
    // Formateador de moneda
    final formatoLps = NumberFormat.currency(
      locale: 'en_US',
      symbol: 'LPS ',
      decimalDigits: 2,
    );

    return Scaffold(
      appBar: customAppBar(tema: tema, titulo: 'Detalle de cotización', context: context, widgetFinal: IconButton(onPressed: (){
        EmpresaController().traerEmpresa(context);
        
        GenerarPdfCotizacion(
          cotizacionCliente,
          empresa!
        );
      }, icon: Icon(Icons.print))),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Titulo de la sección de cotización
            _buildSectionHeader("Información de la Cotización"),
            const SizedBox(height: 10),
            _buildCotizacionCard(cotizacion, formatoLps),
            const SizedBox(height: 16),

            // Titulo de la sección del cliente
            _buildSectionHeader("Datos del Cliente"),
            const SizedBox(height: 10),
            _buildClienteCard(cliente),
            const SizedBox(height: 16),

            // Titulo de la sección de ítems
            _buildSectionHeader("Items de la Cotización"),
            const SizedBox(height: 10),
            _buildItemsList(items, formatoLps),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.teal,
      ),
    );
  }

  Widget _buildCotizacionCard(Cotizacion cotizacion, NumberFormat formatoLps) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow(
              "Número de Cotización:",
              cotizacion.cotizacion.numeroCotizacion,
            ),
            _buildInfoRow(
              "Fecha:",
              cotizacion.cotizacion.fecha.toLocal().toString().split(' ')[0],
            ),
            _buildInfoRow("Tipo de Pago:", cotizacion.cotizacion.tipoPago),
            _buildInfoRow(
              "Tipo de Cotización:",
              cotizacion.cotizacion.tipoCotizacion,
            ),
            const Divider(),
            _buildInfoRow(
              "Subtotal:",
              formatoLps.format(cotizacion.cotizacion.subtotal),
            ),
            _buildInfoRow("ISV:", formatoLps.format(cotizacion.cotizacion.isv)),
            _buildInfoRow(
              "Total:",
              formatoLps.format(cotizacion.cotizacion.total),
              isBold: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClienteCard(Cliente cliente) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow("Nombre:", cliente.nombre),
            _buildInfoRow("Tipo:", cliente.tipo),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            fontSize: 16,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildItemsList(List<Item> items, NumberFormat formatoLps) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow("Nombre:", item.nombre, isBold: true),
                _buildInfoRow("Descripción:", item.descripcion),
                _buildInfoRow("Cantidad:", "${item.cantidad}"),
                _buildInfoRow("Precio:", formatoLps.format(item.precio)),
                _buildInfoRow(
                  "Total:",
                  formatoLps.format(item.total),
                  isBold: true,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
