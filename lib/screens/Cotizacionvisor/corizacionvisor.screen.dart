import 'package:ainso/models/cotizacionCliente.model.dart';
import 'package:ainso/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../globals/widgets/widgets.dart';
import 'components/cardcotizacion.component.dart';

class CotizacionVisor extends StatefulWidget {
  const CotizacionVisor({super.key});
  
  @override
  State<CotizacionVisor> createState() => _CotizacionVisorState();
}

class _CotizacionVisorState extends State<CotizacionVisor> {
  final formatoLps = NumberFormat.currency(
    locale: 'en_US',
    symbol: 'LPS ',
    decimalDigits: 2,
  );

  num sumaCant(List<CotizacionCliente> listproduccionElement) {
    num valor = 0;
    for (var e in listproduccionElement) {
      valor += e.cotizacion.cotizacion.total;
    }
    return valor;
  }

  @override
  void initState() {
    initializeDateFormatting('es_MX', null); // Esto permite la localización de fechas
    super.initState();
  }

  final formato = NumberFormat.decimalPattern('en-us');

  @override
  Widget build(BuildContext context) {
    final cotizacionProvider = Provider.of<CotizacionProvider>(context);
    Size size = MediaQuery.of(context).size;
    final tema = Theme.of(context).colorScheme;
    
    return SafeArea(
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: tema.surface,
            body: Column(
              children: [
                // AppBar
                AppBar(
                  backgroundColor: tema.surface,
                  elevation: 0,
                  leading: IconButton(
                    onPressed: () {
                      cotizacionProvider.resetProvider();
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back_ios, color: tema.primary),
                  ),
                  titleSpacing: 0,
                  title: TextSecundario(
                    texto: 'Cotizaciones',
                    colorTexto: tema.primary,
                  ),
                ),
                // Verificar si hay facturas
                cotizacionProvider.cotizaciones.isNotEmpty
                    ? Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              // ListView.builder
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                itemCount: cotizacionProvider.cotizaciones.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return CardCotizacion(
                                    cotizacion: cotizacionProvider
                                        .cotizaciones[index],
                                  );
                                },
                              ),
                              Container(
                                color: tema.primary,
                                child: Padding(
                                  padding: const EdgeInsets.all(7.0),
                                  child: Row(
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            TextSecundario(
                                              colorTexto: tema.onPrimary,
                                              textAlign: TextAlign.right,
                                              texto: formatoLps.format(
                                                sumaCant(cotizacionProvider.cotizaciones),
                                              ),
                                            ),
                                            const SizedBox(width: 20),
                                          ],
                                        ),
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
          // Cargando Widget
          if (cotizacionProvider.loading)
            CargandoWidget(size: size, conColor: true),
        ],
      ),
    );
  }
}
