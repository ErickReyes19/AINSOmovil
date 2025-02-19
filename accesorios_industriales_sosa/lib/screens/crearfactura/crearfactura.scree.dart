// ignore_for_file: use_build_context_synchronously

import 'package:accesorios_industriales_sosa/controllers/facturas.controller.dart';
import 'package:accesorios_industriales_sosa/controllers/clientes.controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../globals/widgets/widgets.dart';
import '../../models/factura.model.dart';
import '../../providers/providers.dart';
import 'components/buscarcliente.component.dart';

class CrearFacturaScreen extends StatefulWidget {
  const CrearFacturaScreen({super.key});

  @override
  State<CrearFacturaScreen> createState() => _CrearFacturaScreenState();
}

class _CrearFacturaScreenState extends State<CrearFacturaScreen>
    with WidgetsBindingObserver {
  late TextEditingController txtNombreCliente = TextEditingController();
  late TextEditingController txtNumFactura = TextEditingController();
  TextEditingController txtFechaController = TextEditingController();
  TextEditingController txtPrecio = TextEditingController();
  TextEditingController txtDescripcion = TextEditingController();

  String tipoSeleccionado = 'Cliente'; // Selector para Cliente/Proveedor

  @override
  void initState() {
    initializeDateFormatting('es_MX', null);
    txtFechaController.text = DateFormat.yMMMd('es-MX').format(DateTime.now());
    super.initState();
  }

  DateTime fechaCobertura = DateTime.now();

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
              funcionAtras: () {
                clientesProvider.resetProvider();
              },
              tema: tema,
              titulo: "Crear factura",
              context: context,
            ),
            backgroundColor: tema.surface,
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
              child: ListView(
                children: [
                  // Selector de tipo de cliente/proveedor
                  const TextParrafo(
                    texto: 'Tipo de Cliente/Proveedor',
                    fontWeight: FontWeight.bold,
                  ),
                  DropdownButton<String>(
                    value: tipoSeleccionado,
                    onChanged: (String? newValue) async {
                      if (newValue != null) {
                        setState(() {
                          tipoSeleccionado = newValue;
                        });
                        // Llamar al controlador según el tipo seleccionado
                        if (tipoSeleccionado == 'Cliente') {
                          await ClientesLocalesController()
                              .traerClientesActivosLocalesCliente(context);
                        } else {
                          await ClientesLocalesController()
                              .traerClientesActivosLocalesProveedor(context);
                        }
                      }
                    },
                    items: <String>['Cliente', 'Proveedor']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: GoogleFonts.poppins(color: tema.primary),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 10),
                  // Buscador de cliente (se actualiza según el tipo seleccionado)
                  TextParrafo(
                      fontWeight: FontWeight.bold,
                      colorTexto: tema.secondary,
                      texto: 'Cliente',
                      textAlign: TextAlign.left),
                  Row(
                    children: const [
                      Expanded(flex: 7, child: BuscadorClientes()),
                      SizedBox(width: 10),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextParrafo(
                      fontWeight: FontWeight.bold,
                      colorTexto: tema.secondary,
                      texto: 'Numero de factura'),
                  TextField(
                    keyboardType: TextInputType.number,
                    controller: txtNumFactura,
                    style: TextStyle(color: tema.secondary),
                    decoration: InputDecoration(
                        labelStyle: GoogleFonts.poppins(color: tema.onSurface),
                        hintStyle: GoogleFonts.poppins(color: tema.primary),
                        border: const OutlineInputBorder(),
                        hintText: "Ej.: 34"),
                  ),
                  const SizedBox(height: 10),
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
                            Icon(Icons.date_range_outlined, color: tema.primary),
                          ],
                        ),
                      ),
                    ),
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: fechaCobertura,
                        firstDate: DateTime(2020, 3, 5),
                        lastDate: DateTime(2050, 3, 5),
                        locale: const Locale('es', 'ES'),
                      );
                      if (picked != null && picked != fechaCobertura) {
                        setState(() {
                          fechaCobertura = picked;
                          txtFechaController.text =
                              DateFormat.yMMMd('es-MX').format(picked);
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  TextParrafo(
                      fontWeight: FontWeight.bold,
                      colorTexto: tema.secondary,
                      texto: 'Precio'),
                  TextField(
                    keyboardType: TextInputType.number,
                    controller: txtPrecio,
                    style: TextStyle(color: tema.secondary),
                    decoration: InputDecoration(
                        labelStyle: GoogleFonts.poppins(color: tema.onSurface),
                        hintStyle: GoogleFonts.poppins(color: tema.primary),
                        border: const OutlineInputBorder(),
                        hintText: "Ej. 1500"),
                  ),
                  const SizedBox(height: 10),
                  TextParrafo(
                      fontWeight: FontWeight.bold,
                      colorTexto: tema.secondary,
                      texto: 'Descripción'),
                  TextField(
                    keyboardType: TextInputType.text,
                    controller: txtDescripcion,
                    style: TextStyle(color: tema.secondary),
                    decoration: InputDecoration(
                        labelStyle: GoogleFonts.poppins(color: tema.onSurface),
                        hintStyle: GoogleFonts.poppins(color: tema.primary),
                        border: const OutlineInputBorder(),
                        hintText: "Ej. Materiales pendientes"),
                  ),
                  const SizedBox(height: 10),
                  ButtonXXL(
                    funcion: () async {
                      if (txtPrecio.text.isEmpty ||
                          txtNumFactura.text.isEmpty ||
                          clientesProvider.idClienteSelected == 0) {
                        alertError(context,
                            mensaje: "Debe de colocar todos los datos");
                        return;
                      } else {
                        num precio = num.parse(txtPrecio.text);
                        Factura factura = Factura(
                            numeroFactura: txtNumFactura.text,
                            estado: 0,
                            fecha: fechaCobertura,
                            idCliente: clientesProvider.idClienteSelected,
                            precio: precio,
                            descripcion: txtDescripcion.text);
                        await FacturasLocalesController()
                            .insertarFactura(factura, context)
                            .then((value) => clientesProvider.resetProvider())
                            .then((value) => Navigator.pop(context));
                      }
                    },
                    texto: 'Crear factura',
                    sinMargen: true,
                  ),
                  const SizedBox(height: 10),
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
