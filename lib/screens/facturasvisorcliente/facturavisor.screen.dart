import 'package:ainso/models/factura.model.dart';
import 'package:ainso/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../globals/widgets/generarpdf.widget.dart';
import '../../globals/widgets/widgets.dart';
import 'components/cardfactura.component.dart';

class FacturasVisorCliente extends StatefulWidget {
  const FacturasVisorCliente({super.key});
  @override
  State<FacturasVisorCliente> createState() => _FacturasVisorClienteState();
}

class _FacturasVisorClienteState extends State<FacturasVisorCliente> {
  double sumaCant(List<Factura> listproduccionElement) {
    double valor = 0;
    for (var e in listproduccionElement) {
      valor += e.precio;
    }
    return valor;
  }

  final formatoLps = NumberFormat.currency(
    locale: 'en_US',
    symbol: 'LPS ',
    decimalDigits: 2,
  );

  @override
  void initState() {
    initializeDateFormatting('es_MX', null);

    super.initState();
  }

  final formato = NumberFormat.decimalPattern('en-us');
  @override
  Widget build(BuildContext context) {
    final facturaProvider = Provider.of<FacturaProvider>(context);
    final clientesProvider = Provider.of<ClientesProvider>(context);
    Size size = MediaQuery.of(context).size;
    final tema = Theme.of(context).colorScheme;
    return SafeArea(
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: tema.surface,
            body: Column(
              children: [
                AppBar(
                  actions: [
                    IconButton(
                      onPressed: () {
                        if (facturaProvider.listFacturaOrdenadaFecha.isEmpty) {
                          alertError(
                            context,
                            mensaje:
                                'Debe de tener facturas para poder exportarlas',
                          );
                          return;
                        }
                        generateAndSharePdf(
                          facturaProvider.listFacturaOrdenadaFecha,
                          facturaProvider
                              .listFacturaOrdenadaFecha[0]
                              .nombreCliente!,
                          sumaCant(facturaProvider.listFacturaOrdenadaFecha),
                        );
                      },
                      icon: Icon(Icons.ios_share, color: tema.primary),
                    ),
                  ],
                  backgroundColor: tema.surfaceBright,
                  elevation: 0,
                  leading: IconButton(
                    onPressed: () {
                      facturaProvider.resetProvider();
                      clientesProvider.resetProvider();
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back_ios, color: tema.primary),
                  ),
                  titleSpacing: 0,
                  title: TextSecundario(
                    texto: 'Facturas',
                    colorTexto: tema.primary,
                  ),
                ),
                facturaProvider.listFactura.isNotEmpty
                    ? Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                              ),
                              child: TextPrincipal(
                                texto:
                                    facturaProvider
                                        .listFactura[0]
                                        .nombreCliente!,
                              ),
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              itemCount: facturaProvider.listFactura.length,
                              itemBuilder: (BuildContext context, int index) {
                                return CardFactura(
                                  factura: facturaProvider.listFactura[index],
                                );
                              },
                            ),
                            Container(
                              color: tema.primary,
                              child: Padding(
                                padding: const EdgeInsets.all(7.0),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(width: size.width * 0.03),
                                        Expanded(
                                          flex: 5,
                                          child: TextParrafo(
                                            colorTexto: tema.onPrimary,
                                            texto: 'Total General: ',
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 5,
                                          child: Row(
                                            // Agregado un Row para alinear correctamente los textos
                                            mainAxisAlignment:
                                                MainAxisAlignment
                                                    .end, // Alinear a la derecha
                                            children: [
                                              Expanded(
                                                child: TextSecundario(
                                                  colorTexto: tema.onPrimary,
                                                  textAlign: TextAlign.right,
                                                  texto: formatoLps.format(
                                                    sumaCant(
                                                      facturaProvider
                                                          .listFactura,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 20),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    : NoDataWidget(tema: tema, size: size),
              ],
            ),
          ),
          if (facturaProvider.loading)
            CargandoWidget(size: size, conColor: true),
        ],
      ),
    );
  }
}
