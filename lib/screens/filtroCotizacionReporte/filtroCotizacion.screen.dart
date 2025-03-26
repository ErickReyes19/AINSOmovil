// ignore_for_file: use_build_context_synchronously

import 'package:ainso/controllers/clientes.controller.dart';
import 'package:ainso/controllers/controller.dart';
import 'package:ainso/screens/cotizacionClientereporte/cotizacionclientereporte.screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';

import '../../globals/widgets/widgets.dart';
import '../../providers/providers.dart';
import 'components/buscarcliente.component.dart';

class FiltroCotizacionReporteScreen extends StatefulWidget {
  const FiltroCotizacionReporteScreen({super.key});

  @override
  State<FiltroCotizacionReporteScreen> createState() =>
      _FiltroCotizacionReporteScreenState();
}

class _FiltroCotizacionReporteScreenState
    extends State<FiltroCotizacionReporteScreen> {
  late TextEditingController txtFechaInicialController =
      TextEditingController();
  late TextEditingController txtFechaFinalController = TextEditingController();
  String tipoSeleccionado = 'Cliente'; // Inicializamos en 'Cliente'

  @override
  void initState() {
    initializeDateFormatting('es_MX', null);
    txtFechaInicialController.text = DateFormat.yMMMd(
      'es-MX',
    ).format(DateTime.now());
    txtFechaFinalController.text = DateFormat.yMMMd(
      'es-MX',
    ).format(DateTime.now());
    super.initState();
  }

  DateTime fechaInicio = DateTime.now();
  DateTime fechaFinal = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final clienteProvider = Provider.of<ClientesProvider>(context);
    final cotizacionesProvider = Provider.of<CotizacionProvider>(context);
    final tema = Theme.of(context).colorScheme;
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: tema.surface,
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
              child: ListView(
                children: [
                  AppBar(
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    leading: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                        clienteProvider.resetProvider();
                      },
                      icon: Icon(Icons.arrow_back_ios, color: tema.primary),
                    ),
                    titleSpacing: 0,
                    title: TextSecundario(
                      texto: 'Cotizaciones reporte',
                      colorTexto: tema.primary,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Selector de tipo (Cliente o Proveedor)
                  const TextParrafo(texto: 'Tipo de Cliente/Proveedor'),
                  DropdownButton<String>(
                    value: tipoSeleccionado,
                    onChanged: (String? newValue) async {
                      if (newValue != null) {
                        setState(() {
                          tipoSeleccionado = newValue;
                        });
                        // Ejecuta la llamada según el tipo seleccionado
                        if (tipoSeleccionado == 'Cliente') {
                          await ClientesLocalesController()
                              .traerClientesActivosLocalesCliente(context);
                        } else {
                          await ClientesLocalesController()
                              .traerClientesActivosLocalesProveedor(context);
                        }
                      }
                    },
                    items:
                        <String>[
                          'Cliente',
                          'Proveedor',
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                  ),
                  const SizedBox(height: 10),

                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: TextSecundario(
                          textAlign: TextAlign.left,
                          texto:
                              tipoSeleccionado == 'Cliente'
                                  ? "Cliente:"
                                  : "Proveedor:",
                        ),
                      ),
                      Expanded(flex: 7, child: BuscadorClientesTodos()),
                    ],
                  ),
                  const SizedBox(height: 14),
                  ButtonXXL(
                    funcion: () async {
                      await CotizacionController()
                          .obtenerCotizacionReportePorClienteId(
                            clienteProvider.idClienteSelected,
                            context,
                          );
                      if (clienteProvider.idClienteSelected == 0) {
                        sncackbarGlobal("Seleccione un cliente");
                        return;
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ReporteCotizacionScreen(),
                        ),
                      );
                    },
                    texto: 'Continuar',
                    sinMargen: true,
                  ),
                ],
              ),
            ),
          ),
          if (clienteProvider.loading || cotizacionesProvider.loading)
            CargandoWidget(size: size, conColor: true),
        ],
      ),
    );
  }
}
