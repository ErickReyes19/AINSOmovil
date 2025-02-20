// ignore_for_file: use_build_context_synchronously

import 'package:accesorios_industriales_sosa/controllers/facturas.controller.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../globals/widgets/widgets.dart';
import '../../models/factura.model.dart';
import '../../providers/providers.dart';

class ActualizarFacturaScreen extends StatefulWidget {
  final Factura factura;
  const ActualizarFacturaScreen({
    super.key,
    required this.factura,
  });

  @override
  State<ActualizarFacturaScreen> createState() =>
      _ActualizarFacturaScreenState();
}

class _ActualizarFacturaScreenState extends State<ActualizarFacturaScreen>
    with WidgetsBindingObserver {
  late TextEditingController txtNombreCliente =
      TextEditingController(text: widget.factura.nombreCliente);
  late TextEditingController txtNumFactura =
      TextEditingController(text: widget.factura.numeroFactura);
  late TextEditingController txtFechaController =
      TextEditingController(text: widget.factura.fecha.toString());
  late TextEditingController txtPrecio =
      TextEditingController(text: widget.factura.precio.toString());
  late TextEditingController txtDescripcion =
      TextEditingController(text: widget.factura.descripcion);

  @override
  void initState() {
    initializeDateFormatting('es_MX', null);
    txtFechaController.text = DateFormat.yMMMd('es-MX').format(widget.factura.fecha);
    super.initState();
  }

  late DateTime fechaFactura = widget.factura.fecha;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context).colorScheme;
    Size size = MediaQuery.of(context).size;
    final clientesProvider = Provider.of<ClientesProvider>(context);

    return SafeArea(
      child: Stack(
        children: [
          Scaffold(
            appBar: customAppBar(
                funcionAtras: (() {
                  clientesProvider.resetProvider();
                }),
                tema: tema,
                titulo: "Editar factura",
                context: context),
            backgroundColor: tema.surface,
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
              child: ListView(
                children: [
                  TextParrafo(
                      fontWeight: FontWeight.bold,
                      colorTexto: tema.secondary,
                      texto: 'Cliente',
                      textAlign: TextAlign.left),
                  Row(
                    children: [
                      TextPrincipal(texto: widget.factura.nombreCliente!),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextParrafo(
                      fontWeight: FontWeight.bold,
                      colorTexto: tema.secondary,
                      texto: 'Numero de factura'),
                  TextField(
                    keyboardType: TextInputType.number,
                    controller: txtNumFactura,
                    onChanged: (String value) {},
                    style: TextStyle(color: tema.secondary),
                    decoration: InputDecoration(
                        labelStyle:
                            GoogleFonts.poppins(color: tema.onSurface),
                        hintStyle:
                            GoogleFonts.poppins(color: tema.primary),
                        border: const OutlineInputBorder(),
                        hintText: "ejp: 34"),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextParrafo(
                      fontWeight: FontWeight.bold,
                      colorTexto: tema.secondary,
                      texto: 'Fecha de facturación'),
                  TextField(
                    style: TextStyle(color: tema.secondary),
                    readOnly: true,
                    controller: txtFechaController,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        prefixIcon: Padding(
                          padding: EdgeInsets.only(
                              left: size.width * 0.02,
                              bottom: 4.5,
                              right: size.width * 0.02),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.date_range_outlined,
                                color: tema.primary,
                              ),
                            ],
                          ),
                        )),
                    onTap: () async{
                      final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: fechaFactura,
                              firstDate: DateTime(2020, 3, 5),
                              lastDate: DateTime(2050, 3, 5),
                              locale: const Locale('es', 'ES'),
                            );
                            if (picked != null && picked != fechaFactura) {
                              setState(() {
                                fechaFactura = picked;
                                txtFechaController.text =
                                    DateFormat.yMMMd('es-MX').format(picked);
                              });
                            }
                        
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextParrafo(
                      fontWeight: FontWeight.bold,
                      colorTexto: tema.secondary,
                      texto: 'Precio'),
                  TextField(
                    keyboardType: TextInputType.number,
                    controller: txtPrecio,
                    onChanged: (String value) {},
                    style: TextStyle(color: tema.secondary),
                    decoration: InputDecoration(
                        labelStyle:
                            GoogleFonts.poppins(color: tema.onSurface),
                        hintStyle:
                            GoogleFonts.poppins(color: tema.primary),
                        border: const OutlineInputBorder(),
                        hintText: "Ej: 1500"),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextParrafo(
                      fontWeight: FontWeight.bold,
                      colorTexto: tema.secondary,
                      texto: 'Descripción'),
                  TextField(
                    keyboardType: TextInputType.text,
                    controller: txtDescripcion,
                    onChanged: (String value) {},
                    style: TextStyle(color: tema.secondary),
                    decoration: InputDecoration(
                        labelStyle:
                            GoogleFonts.poppins(color: tema.onSurface),
                        hintStyle:
                            GoogleFonts.poppins(color: tema.primary),
                        border: const OutlineInputBorder(),
                        hintText: "Ej: Materiales pendientes"),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ButtonXXL(
                    funcion: () async {
                      if (txtPrecio.text.isEmpty ||
                          txtNumFactura.text.isEmpty ||
                          txtPrecio.text.isEmpty) {
                        alertError(context,
                            mensaje: "Debe de colocar todos los datos");
                        return;
                      } else {
                        num precio = num.parse(txtPrecio.text);
                        Factura factura = Factura(
                            idFactura: widget.factura.idFactura,
                            numeroFactura: txtNumFactura.text,
                            estado: 0,
                            fecha: fechaFactura,
                            idCliente: widget.factura.idCliente,
                            precio: precio,
                            descripcion: txtDescripcion.text);
                        FacturasLocalesController()
                            .actualizarFactura(factura, context)
                            .then((value) => Navigator.pop(context))
                            .then((value) => Navigator.pop(context));
                      }
                    },
                    texto: 'Actualizar factura',
                    sinMargen: true,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
          if (clientesProvider.loading)
            CargandoWidget(size: size, conColor: true)
        ],
      ),
    );
  }
}
