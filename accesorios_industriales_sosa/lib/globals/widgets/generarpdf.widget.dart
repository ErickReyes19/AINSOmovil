import 'dart:io';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../models/factura.model.dart';

Future<void> generateAndSharePdf(
    List<Factura> facturas, String nombreCliente, double total) async {
  final formatoLps = NumberFormat.currency(
    locale: 'en_US',
    symbol: 'LPS ',
    decimalDigits: 2,
  );

  final pdf = pw.Document();

  // Cargar imagen (logo)
  final ByteData data = await rootBundle.load('assets/images/iaslogo.png');
  final Uint8List uint8List = data.buffer.asUint8List();
  final image = pw.MemoryImage(uint8List);

  // Aplicar tema global para el PDF
  final theme = pw.ThemeData.withFont(
    base: pw.Font.helvetica(),
  );

  pdf.addPage(
    pw.MultiPage(
      theme: theme,
      margin: pw.EdgeInsets.all(24),
      build: (pw.Context context) {
        return [
          // ENCABEZADO
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('ACCESORIOS INDUSTRIALES SOSA',
                      style: pw.TextStyle(
                          fontSize: 22, fontWeight: pw.FontWeight.bold)),
                  pw.Text('Estado de cuenta', style: pw.TextStyle(fontSize: 14)),
                ],
              ),
              pw.Container(
                width: 130,
                height: 130,
                child: pw.Image(image),
              )
            ],
          ),
          pw.SizedBox(height: 20),

          // INFORMACIÓN DEL CLIENTE
          pw.Container(
            padding: pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(),
              borderRadius: pw.BorderRadius.circular(5),
            ),
            child: pw.Row(
              children: [
                pw.Text('Cliente: ', style: pw.TextStyle(fontSize: 14)),
                pw.Text(nombreCliente,
                    style: pw.TextStyle(
                        fontSize: 14, fontWeight: pw.FontWeight.bold)),
              ],
            ),
          ),
          pw.SizedBox(height: 20),

          // TABLA DE FACTURAS CON MÁS ESPACIO PARA "DESCRIPCIÓN"
          pw.Table(
            columnWidths: {
              0: pw.FlexColumnWidth(1.5), // Fecha
              1: pw.FlexColumnWidth(1), // N° Factura
              2: pw.FlexColumnWidth(3), // Descripción (más grande)
              3: pw.FlexColumnWidth(1.5), // Valor Factura
            },
            border: pw.TableBorder.all(),
            children: [
              // CABECERA
              pw.TableRow(
                decoration: pw.BoxDecoration(border: pw.Border.all()),
                children: [
                  pw.Padding(
                    padding: pw.EdgeInsets.all(8),
                    child: pw.Text('Fecha',
                        style: pw.TextStyle(
                            fontSize: 12, fontWeight: pw.FontWeight.bold),
                        textAlign: pw.TextAlign.center),
                  ),
                  pw.Padding(
                    padding: pw.EdgeInsets.all(8),
                    child: pw.Text('N° Factura',
                        style: pw.TextStyle(
                            fontSize: 12, fontWeight: pw.FontWeight.bold),
                        textAlign: pw.TextAlign.center),
                  ),
                  pw.Padding(
                    padding: pw.EdgeInsets.all(8),
                    child: pw.Text('Descripción',
                        style: pw.TextStyle(
                            fontSize: 12, fontWeight: pw.FontWeight.bold),
                        textAlign: pw.TextAlign.center),
                  ),
                  pw.Padding(
                    padding: pw.EdgeInsets.all(8),
                    child: pw.Text('V. Factura',
                        style: pw.TextStyle(
                            fontSize: 12, fontWeight: pw.FontWeight.bold),
                        textAlign: pw.TextAlign.center),
                  ),
                ],
              ),
              // FILAS DE FACTURAS
              ...facturas.map((factura) {
                return pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: pw.EdgeInsets.all(8),
                      child: pw.Text(
                          DateFormat('d MMMM y', 'es-MX').format(factura.fecha),
                          style: pw.TextStyle(fontSize: 10),
                          textAlign: pw.TextAlign.center),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.all(8),
                      child: pw.Text(factura.numeroFactura,
                          style: pw.TextStyle(fontSize: 10),
                          textAlign: pw.TextAlign.center),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.all(8),
                      child: pw.Text(factura.descripcion ?? '',
                          style: pw.TextStyle(fontSize: 10),
                          textAlign: pw.TextAlign.left),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.all(8),
                      child: pw.Text(formatoLps.format(factura.precio),
                          style: pw.TextStyle(fontSize: 10),
                          textAlign: pw.TextAlign.right),
                    ),
                  ],
                );
              }).toList(),
            ],
          ),
          pw.SizedBox(height: 20),

          // TOTAL
          pw.Container(
            padding: pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(),
              borderRadius: pw.BorderRadius.circular(5),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Total:',
                    style: pw.TextStyle(
                        fontSize: 14, fontWeight: pw.FontWeight.bold)),
                pw.Text(formatoLps.format(total),
                    style: pw.TextStyle(
                        fontSize: 14, fontWeight: pw.FontWeight.bold)),
              ],
            ),
          ),
        ];
      },
    ),
  );

  // Guardar el PDF en un archivo temporal
  final tempDir = await getTemporaryDirectory();
  final pdfFile = File('${tempDir.path}/facturas_$nombreCliente.pdf');
  await pdfFile.writeAsBytes(await pdf.save());

  // Abrir el PDF generado
  await OpenFile.open(pdfFile.path);
}
