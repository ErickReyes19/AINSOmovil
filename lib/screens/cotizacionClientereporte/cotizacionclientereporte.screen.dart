import 'package:ainso/models/models.dart';
import 'package:ainso/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ReporteCotizacionScreen extends StatelessWidget {
  final formatoLps = NumberFormat.currency(
    locale: 'en_US',
    symbol: 'LPS ',
    decimalDigits: 2,
  );

  ReporteCotizacionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CotizacionProvider>(context);
    final cotizacionReporte = provider.cotizacionClienteReporte;
    print(cotizacionReporte);
    if (cotizacionReporte == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Reporte de Cotizaciones")),
        body: const Center(child: Text("No hay datos disponibles.")),
      );
    }

    final cliente = cotizacionReporte.cliente;
    final cotizaciones = cotizacionReporte.cotizaciones;

    return Scaffold(
      appBar: AppBar(title: const Text("Reporte de Cotizaciones")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildSectionHeader("Datos del Cliente"),
            _buildClienteCard(cliente),
            const SizedBox(height: 20),

            _buildSectionHeader("Cotizaciones"),
            if (cotizaciones.isEmpty)
              const Center(child: Text("No hay cotizaciones disponibles."))
            else
              _buildCotizacionesList(cotizaciones),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.teal,
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

  Widget _buildCotizacionesList(List<Cotizacion> cotizaciones) {
    return Column(
      children:
          cotizaciones.map((cotizacion) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ExpansionTile(
                title: Text(
                  "Cotización #${cotizacion.cotizacion.numeroCotizacion} - ${formatoLps.format(cotizacion.cotizacion.total)}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  "Fecha: ${cotizacion.cotizacion.fecha.toLocal().toString().split(' ')[0]}",
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow(
                          "Tipo de Pago:",
                          cotizacion.cotizacion.tipoPago,
                        ),
                        _buildInfoRow(
                          "Tipo de Cotización:",
                          cotizacion.cotizacion.tipoCotizacion,
                        ),
                        const Divider(),
                        _buildInfoRow(
                          "Subtotal:",
                          formatoLps.format(cotizacion.cotizacion.subtotal),
                        ),
                        _buildInfoRow(
                          "ISV:",
                          formatoLps.format(cotizacion.cotizacion.isv),
                        ),
                        _buildInfoRow(
                          "Total:",
                          formatoLps.format(cotizacion.cotizacion.total),
                          isBold: true,
                        ),
                        const SizedBox(height: 10),
                        _buildSectionHeader("Items"),
                        if (cotizacion.items.isEmpty)
                          const Center(
                            child: Text("No hay items en esta cotización."),
                          )
                        else
                          _buildItemsList(cotizacion.items),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
    );
  }

  Widget _buildItemsList(List<Item> items) {
    return Column(
      children:
          items.map((item) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 6),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                title: Text(
                  item.nombre,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Descripción: ${item.descripcion}"),
                    Text("Cantidad: ${item.cantidad}"),
                    Text("Precio: ${formatoLps.format(item.precio)}"),
                    Text(
                      "Total: ${formatoLps.format(item.total)}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
