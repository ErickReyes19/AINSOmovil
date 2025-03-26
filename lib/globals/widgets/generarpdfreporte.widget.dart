import 'dart:io';
import 'dart:typed_data';
import 'package:ainso/models/cotizacionCliente.model.dart';
import 'package:ainso/models/models.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

Future<void> GenerarPdfCotizacion(
  CotizacionCliente cotizacionCliente,
  Empresa empresa,
) async {
  final formatoMoneda = NumberFormat.currency(
    locale: 'en_US',
    symbol: '', // Sin símbolo, con punto decimal
    decimalDigits: 2,
  );

  final pdf = pw.Document();

  // Cargar imagen (logo)
  final ByteData data = await rootBundle.load('assets/images/iaslogo.png');
  final ByteData sello = await rootBundle.load('assets/images/sello.png');
  final Uint8List uint8List = data.buffer.asUint8List();
  final Uint8List uint8Listsello = sello.buffer.asUint8List();
  final image = pw.MemoryImage(uint8List);
  final selloimagen = pw.MemoryImage(uint8Listsello);

  // Fecha actual para la factura
  final fechaCotizacion = DateFormat(
    'd MMMM y',
    'es-MX',
  ).format(DateTime.now());

  // Tema global del PDF
  final theme = pw.ThemeData.withFont(base: pw.Font.helvetica());

  pdf.addPage(
    pw.MultiPage(
      theme: theme,
      margin: pw.EdgeInsets.all(24),
      build: (pw.Context context) {
        return [
          // ENCABEZADO PRINCIPAL
          pw.Stack(
            children: [
              pw.Column(
                children: [
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Container(
                        width: 140,
                        height: 140,
                        child: pw.Image(image),
                      ),
                      // Información de la empresa y factura
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                        children: [
                          pw.Text(
                            empresa.nombre,
                            style: pw.TextStyle(
                              fontSize: 22,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.blueAccent,
                            ),
                            textAlign: pw.TextAlign.center,
                          ),
                          pw.Text(
                            empresa.direccion,
                            style: pw.TextStyle(fontSize: 14),
                            textAlign: pw.TextAlign.center,
                          ),
                          // Mostrar los teléfonos separados por comas
                          pw.Text(
                            'Teléfonos: ${empresa.telefonos.map((tel) => tel.telefono).join(', ')}',
                            style: pw.TextStyle(fontSize: 12),
                            textAlign: pw.TextAlign.center,
                          ),
                          pw.Text(
                            'Email: ${empresa.email}',
                            style: pw.TextStyle(fontSize: 12),
                            textAlign: pw.TextAlign.center,
                          ),
                          pw.Text(
                            'RTN: ${empresa.rtn}',
                            style: pw.TextStyle(
                              fontSize: 12,
                              fontWeight: pw.FontWeight.bold,
                            ),
                            textAlign: pw.TextAlign.center,
                          ),
                        ],
                      ),

                      // Logo
                    ],
                  ),
                  pw.SizedBox(height: 20),

                  pw.Table(
                    border: pw.TableBorder.all(), // Borde de la tabla
                    columnWidths: {
                      0: pw.FlexColumnWidth(
                        1,
                      ), // Ajustar el ancho de las columnas
                      1: pw.FlexColumnWidth(1),
                      2: pw.FlexColumnWidth(1),
                      3: pw.FlexColumnWidth(1),
                    },
                    children: [
                      // Fila de encabezado
                      pw.TableRow(
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(),
                          color: PdfColors.blueAccent100,
                        ),
                        children: [
                          pw.Padding(
                            padding: pw.EdgeInsets.all(8),
                            child: pw.Text(
                              'Cliente',
                              style: pw.TextStyle(
                                fontSize: 10,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ),
                          pw.Padding(
                            padding: pw.EdgeInsets.all(8),
                            child: pw.Text(
                              'Tipo de Cotización',
                              style: pw.TextStyle(
                                fontSize: 10,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ),
                          pw.Padding(
                            padding: pw.EdgeInsets.all(8),
                            child: pw.Text(
                              'Tipo de Pago',
                              style: pw.TextStyle(
                                fontSize: 10,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ),
                          pw.Padding(
                            padding: pw.EdgeInsets.all(8),
                            child: pw.Text(
                              'Fecha',
                              style: pw.TextStyle(
                                fontSize: 10,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Fila de datos
                      pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: pw.EdgeInsets.all(8),
                            child: pw.Text(
                              cotizacionCliente.cliente.nombre,
                              style: pw.TextStyle(fontSize: 10),
                            ),
                          ),
                          pw.Padding(
                            padding: pw.EdgeInsets.all(8),
                            child: pw.Text(
                              cotizacionCliente
                                  .cotizacion
                                  .cotizacion
                                  .tipoCotizacion,
                              style: pw.TextStyle(fontSize: 10),
                            ),
                          ),
                          pw.Padding(
                            padding: pw.EdgeInsets.all(8),
                            child: pw.Text(
                              cotizacionCliente.cotizacion.cotizacion.tipoPago,
                              
                              style: pw.TextStyle(fontSize: 10, color: PdfColors.red, fontWeight: pw.FontWeight.bold),
                            ),
                          ),
                          pw.Padding(
                            padding: pw.EdgeInsets.all(8),
                            child: pw.Text(
                              cotizacionCliente.cotizacion.cotizacion.fecha
                                  .toLocal()
                                  .toString()
                                  .split(' ')[0], // Formato de fecha
                              style: pw.TextStyle(fontSize: 10),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 20),

                  // TABLA DE ÍTEMS DE COTIZACIÓN (diseño de factura)
                  pw.Table(
                    columnWidths: {
                      0: pw.FlexColumnWidth(0.5), // Descripción
                      1: pw.FlexColumnWidth(3), // Cantidad
                      2: pw.FlexColumnWidth(0.6), // Unidad
                      3: pw.FlexColumnWidth(1), // Vr. Unitario
                      4: pw.FlexColumnWidth(1), // Total
                    },
                    border: pw.TableBorder.all(),
                    children: [
                      // CABECERA DE LA TABLA
                      pw.TableRow(
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(),
                          color: PdfColors.blueAccent100,
                        ),
                        children: [
                          pw.Padding(
                            padding: pw.EdgeInsets.all(8),
                            child: pw.Text(
                              'Cant',
                              style: pw.TextStyle(
                                fontSize: 10,
                                fontWeight: pw.FontWeight.bold,
                              ),
                              textAlign: pw.TextAlign.center,
                            ),
                          ),
                          pw.Padding(
                            padding: pw.EdgeInsets.all(8),
                            child: pw.Text(
                              'Descripción',
                              style: pw.TextStyle(
                                fontSize: 10,
                                fontWeight: pw.FontWeight.bold,
                              ),
                              textAlign: pw.TextAlign.center,
                            ),
                          ),
                          pw.Padding(
                            padding: pw.EdgeInsets.all(8),
                            child: pw.Text(
                              'Unidad',
                              style: pw.TextStyle(
                                fontSize: 10,
                                fontWeight: pw.FontWeight.bold,
                              ),
                              textAlign: pw.TextAlign.center,
                            ),
                          ),
                          pw.Padding(
                            padding: pw.EdgeInsets.all(8),
                            child: pw.Text(
                              'Vr. Unitario',
                              style: pw.TextStyle(
                                fontSize: 10,
                                fontWeight: pw.FontWeight.bold,
                              ),
                              textAlign: pw.TextAlign.center,
                            ),
                          ),
                          pw.Padding(
                            padding: pw.EdgeInsets.all(8),
                            child: pw.Text(
                              'Total',
                              style: pw.TextStyle(
                                fontSize: 10,
                                fontWeight: pw.FontWeight.bold,
                              ),
                              textAlign: pw.TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                      // FILAS DE ÍTEMS
                      ...cotizacionCliente.cotizacion.items.map((item) {
                        return pw.TableRow(
                          children: [
                            // Descripción o nombre del ítem
                            pw.Padding(
                              padding: pw.EdgeInsets.all(8),
                              child: pw.Text(
                                item.cantidad.toString(),
                                style: pw.TextStyle(fontSize: 10),
                                textAlign: pw.TextAlign.center,
                              ),
                            ),
                            pw.Padding(
                              padding: pw.EdgeInsets.all(8),
                              child: pw.Text(
                                item.nombre ?? '',
                                style: pw.TextStyle(fontSize: 10),
                                textAlign: pw.TextAlign.left,
                              ),
                            ),
                            // Cantidad
                            // Unidad
                            pw.Padding(
                              padding: pw.EdgeInsets.all(8),
                              child: pw.Text(
                                item.unidad ?? '',
                                style: pw.TextStyle(fontSize: 10),
                                textAlign: pw.TextAlign.center,
                              ),
                            ),
                            // Vr. Unitario
                            pw.Padding(
                              padding: pw.EdgeInsets.all(8),
                              child: pw.Text(
                                formatoMoneda.format(item.precio),
                                style: pw.TextStyle(fontSize: 10),
                                textAlign: pw.TextAlign.right,
                              ),
                            ),
                            // Total
                            pw.Padding(
                              padding: pw.EdgeInsets.all(8),
                              child: pw.Text(
                                formatoMoneda.format(item.total),
                                style: pw.TextStyle(fontSize: 10),
                                textAlign: pw.TextAlign.right,
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                      // FILA DE SUBTOTAL
                      pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: pw.EdgeInsets.all(8),
                            child: pw.Text(""),
                          ),
                          pw.Padding(
                            padding: pw.EdgeInsets.all(8),
                            child: pw.Text(""),
                          ),
                          pw.Padding(
                            padding: pw.EdgeInsets.all(8),
                            child: pw.Text(""),
                          ),
                          pw.Padding(
                            padding: pw.EdgeInsets.all(8),
                            child: pw.Text(
                              'Subtotal:',
                              style: pw.TextStyle(
                                fontSize: 10,
                              ),
                              textAlign: pw.TextAlign.center,
                            ),
                          ),
                          pw.Padding(
                            padding: pw.EdgeInsets.all(8),
                            child: pw.Text(
                              formatoMoneda.format(
                                cotizacionCliente
                                    .cotizacion
                                    .cotizacion
                                    .subtotal,
                              ),
                              style: pw.TextStyle(
                                fontSize: 10,
                                fontWeight: pw.FontWeight.bold,
                              ),
                              textAlign: pw.TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                      // FILA DE ISV
                      pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: pw.EdgeInsets.all(8),
                            child: pw.Text(""),
                          ),
                          pw.Padding(
                            padding: pw.EdgeInsets.all(8),
                            child: pw.Text(""),
                          ),
                          pw.Padding(
                            padding: pw.EdgeInsets.all(8),
                            child: pw.Text(""),
                          ),
                          pw.Padding(
                            padding: pw.EdgeInsets.all(8),
                            child: pw.Text(
                              'ISV (15%):',
                              style: pw.TextStyle(
                                fontSize: 10,
                              ),
                              textAlign: pw.TextAlign.center,
                            ),
                          ),
                          pw.Padding(
                            padding: pw.EdgeInsets.all(8),
                            child: pw.Text(
                              formatoMoneda.format(
                                cotizacionCliente.cotizacion.cotizacion.isv,
                              ),
                              style: pw.TextStyle(
                                fontSize: 10,
                                fontWeight: pw.FontWeight.bold,
                              ),
                              textAlign: pw.TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                      // FILA DE TOTAL
                      pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: pw.EdgeInsets.all(8),
                            child: pw.Text(""),
                          ),
                          pw.Padding(
                            padding: pw.EdgeInsets.all(8),
                            child: pw.Text(""),
                          ),
                          pw.Padding(
                            padding: pw.EdgeInsets.all(8),
                            child: pw.Text(""),
                          ),
                          pw.Padding(
                            padding: pw.EdgeInsets.all(8),
                            child: pw.Text(
                              'Total:',
                              style: pw.TextStyle(
                                fontSize: 10,
                              ),
                              textAlign: pw.TextAlign.center,
                            ),
                          ),
                          pw.Padding(
                            padding: pw.EdgeInsets.all(8),
                            child: pw.Text(
                              formatoMoneda.format(
                                cotizacionCliente.cotizacion.cotizacion.total,
                              ),
                              style: pw.TextStyle(
                                fontSize: 10,
                                fontWeight: pw.FontWeight.bold,
                              ),
                              textAlign: pw.TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 20),
                  // Información de los bancos
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children:
                        empresa.bancos.map((banco) {
                          return pw.Row(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(
                                'Banco: ${banco.banco}',
                                style: pw.TextStyle(fontSize: 12),
                              ),
                              pw.Text(
                                'Nombre: ${banco.nombre}',
                                style: pw.TextStyle(fontSize: 12),
                              ),
                              pw.Text(
                                'Cuenta: ${banco.cuenta}',
                                style: pw.TextStyle(fontSize: 12),
                              ),
                              pw.SizedBox(
                                height: 10,
                              ), // Espacio entre los bancos
                            ],
                          );
                        }).toList(),
                  ),
                ],
              ),
              pw.Positioned(
                left: 160, // Ajusta la posición en el eje X
                top: 230, // Ajusta la posición en el eje Y
                child: pw.Opacity(
                  opacity: 0.5, // Ajusta la opacidad del sello
                  child: pw.Container(
                    alignment: pw.Alignment.centerRight,
                    width: 140,
                    height: 140,
                    child: pw.Image(selloimagen),
                  ),
                ),
              ),
            ],
          ),
        ];
      },
    ),
  );

  // Guardar el PDF en un archivo temporal
  final tempDir = await getTemporaryDirectory();
  final pdfFile = File(
    '${tempDir.path}/cotizacion_${cotizacionCliente.cliente.nombre}.pdf',
  );
  await pdfFile.writeAsBytes(await pdf.save());

  // Abrir el PDF generado
  await OpenFile.open(pdfFile.path);
}
