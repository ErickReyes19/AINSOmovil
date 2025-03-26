// ignore_for_file: library_private_types_in_public_api, avoid_print

import 'package:ainso/controllers/controller.dart';
import 'package:ainso/globals/widgets/widgets.dart';
import 'package:ainso/models/models.dart';
import 'package:ainso/providers/providers.dart';
import 'package:ainso/screens/crearfactura/components/buscarcliente.component.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CrearCotizacionScreen extends StatefulWidget {
  const CrearCotizacionScreen({super.key});

  @override
  _CrearCotizacionScreenState createState() => _CrearCotizacionScreenState();
}

class _CrearCotizacionScreenState extends State<CrearCotizacionScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _numeroCotizacionController = TextEditingController();
  final TextEditingController _subtotalController = TextEditingController();
  final TextEditingController _totalController = TextEditingController();
  final TextEditingController _isvController = TextEditingController();
  final List<Map<String, TextEditingController>> _itemsControllers = [];
  
  String tipoSeleccionado = 'Cliente';
  String _tipoPago = 'Contado';
  String _tipoCotizacion = 'Cotización'; // Valor inicial

  double _subtotal = 0.0;
  double _total = 0.0;
  double _isv = 0.0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _agregarItem(); // Agregar el primer ítem
  }

  void _agregarItem() {
    setState(() {
      _itemsControllers.add({
        "nombre": TextEditingController(),
        "precio": TextEditingController(),
        "cantidad": TextEditingController(),
        "unidad": TextEditingController(),
        "descripcion": TextEditingController(),
        "total": TextEditingController(),
      });
    });
  }

  void _calcularTotales() {
    double subtotalTemp = 0.0;
    // Recorremos cada ítem y calculamos su total
    for (var item in _itemsControllers) {
      double precio = double.tryParse(item["precio"]?.text ?? '') ?? 0.0;
      int cantidad = int.tryParse(item["cantidad"]?.text ?? '') ?? 0;
      double totalItem = cantidad * precio;
      item["total"]?.text = totalItem.toStringAsFixed(2);
      subtotalTemp += totalItem;
    }
    setState(() {
      _subtotal = subtotalTemp;
      // Si es Cotización se aplica el 15% de ISV, si es Proforma, ISV es 0
      _isv = _tipoCotizacion == 'Cotización' ? _subtotal * 0.15 : 0.0;
      _total = _subtotal + _isv;
      _subtotalController.text = _subtotal.toStringAsFixed(2);
      _isvController.text = _isv.toStringAsFixed(2);
      _totalController.text = _total.toStringAsFixed(2);
    });
  }

  Future<void> _guardarCotizacion() async {
            final clientesProvider = Provider.of<ClientesProvider>(context, listen: false);
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      // Crear el objeto Cotizacion
      Cotizacion cotizacion = Cotizacion(
        cotizacion: CotizacionClass(
          idCotizacion: 0, // Se generará en la BD
          idCliente: clientesProvider.idClienteSelected, // Aquí deberías obtener el ID real del cliente seleccionado
          fecha: DateTime.now(),
          total: _total,
          subtotal: _subtotal,
          isv: _isv,
          numeroCotizacion: _numeroCotizacionController.text,
          tipoPago: _tipoPago,
          tipoCotizacion: _tipoCotizacion,
        ),
        items: _itemsControllers.map((item) {
          return Item(
            idItem: 0, // Se genera en la BD
            idCotizacion: 0, // Se actualizará según la cotización insertada
            nombre: item["nombre"]?.text ?? '',
            precio: double.tryParse(item["precio"]?.text ?? '0') ?? 0.0,
            descripcion: item["descripcion"]?.text ?? '',
            cantidad: int.tryParse(item["cantidad"]?.text ?? '0') ?? 0,
            unidad: item["unidad"]?.text ?? '',
            total: double.tryParse(item["total"]?.text ?? '0') ?? 0.0,
          );
        }).toList(),
      );

      // Llamada al controlador para guardar la cotización
      bool success = await _insertarCotizacion(cotizacion, context);

      setState(() {
        _isLoading = false;
      });

      if (success) {
        sncackbarGlobal('Cotización agregada con éxito.', color: Colors.green);
        Navigator.pop(context);
      } else {
        sncackbarGlobal('Error al agregar la cotización.', color: Colors.red);
      }
    }
  }

  Future<bool> _insertarCotizacion(Cotizacion cotizacion, BuildContext context) async {
    final provider = Provider.of<CotizacionProvider>(context, listen: false);

    provider.loading = true;

    try {
      bool success = await CotizacionController().insertarCotizacion(cotizacion, context);
      return success;
    } catch (e) {
      print('Error en insertarCotizacion: $e');
      return false;
    } finally {
      provider.loading = false;
    }
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.blue),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.blue),
          ),
        ),
        validator: validator,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Cotización', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                onChanged: _calcularTotales,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tipo de Cliente/Proveedor
                    const Text(
                      'Tipo de Cliente/Proveedor',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    DropdownButton<String>(
                      value: tipoSeleccionado,
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            tipoSeleccionado = newValue;
                          });
                          // Lógica adicional según el tipo seleccionado
                        }
                      },
                      items: <String>['Cliente', 'Proveedor']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value, style: GoogleFonts.poppins(color: Colors.blue)),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 10),
                    // Buscador de cliente
                    const Text(
                      'Cliente',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                    ),
                    Row(
                      children: const [
                        Expanded(flex: 7, child: BuscadorClientes()),
                        SizedBox(width: 10),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Número de cotización
                    _buildInputField(
                      controller: _numeroCotizacionController,
                      label: 'Número de Cotización',
                      icon: Icons.receipt,
                      validator: (value) => value == null || value.isEmpty ? 'Ingrese el número de cotización' : null,
                    ),
                    // Tipo de Pago
                    DropdownButtonFormField<String>(
                      value: _tipoPago,
                      decoration: InputDecoration(
                        labelText: 'Tipo de Pago',
                        prefixIcon: Icon(Icons.payment, color: Colors.blue),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _tipoPago = newValue;
                          });
                        }
                      },
                      items: ['Contado', 'Crédito']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value, style: GoogleFonts.poppins()),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    // Tipo de Cotización (Cotización o Proforma)
                    DropdownButtonFormField<String>(
                      value: _tipoCotizacion,
                      decoration: InputDecoration(
                        labelText: 'Tipo de Cotización',
                        prefixIcon: Icon(Icons.description, color: Colors.blue),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _tipoCotizacion = newValue;
                          });
                          _calcularTotales(); // Recalcular totales al cambiar
                        }
                      },
                      items: ['Cotización', 'Proforma']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value, style: GoogleFonts.poppins()),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    // Lista de ítems con botón de eliminación y total individual
                    const Text('Items', style: TextStyle(fontWeight: FontWeight.bold)),
                    ..._itemsControllers.asMap().entries.map((entry) {
                      int index = entry.key;
                      Map<String, TextEditingController> item = entry.value;
                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Encabezado con título y botón de eliminar
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Item ${index + 1}", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      setState(() {
                                        _itemsControllers.removeAt(index);
                                        _calcularTotales();
                                      });
                                    },
                                  ),
                                ],
                              ),
                              _buildInputField(
                                controller: item["nombre"]!,
                                label: 'Nombre',
                                icon: Icons.title,
                              ),
                              _buildInputField(
                                controller: item["precio"]!,
                                label: 'Precio',
                                icon: Icons.monetization_on,
                                keyboardType: TextInputType.number,
                              ),
                              _buildInputField(
                                controller: item["cantidad"]!,
                                label: 'Cantidad',
                                icon: Icons.add_shopping_cart,
                                keyboardType: TextInputType.number,
                              ),
                              _buildInputField(
                                controller: item["unidad"]!,
                                label: 'Unidad',
                                icon: Icons.line_weight,
                              ),
                              _buildInputField(
                                controller: item["descripcion"]!,
                                label: 'Descripción',
                                icon: Icons.description,
                              ),
                              // Mostrar el total calculado para el ítem
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  "Total del item: ${item["total"]?.text ?? '0'}",
                                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                    ButtonXXL(
                      funcion: _agregarItem,
                      texto: 'Agregar Item',
                    ),
                    const SizedBox(height: 20),
                    // Totales generales
                    _buildInputField(
                      controller: _subtotalController,
                      label: 'Subtotal',
                      icon: Icons.account_balance_wallet,
                      validator: (value) => value == null || value.isEmpty ? 'Ingrese el subtotal' : null,
                    ),
                    // Mostrar ISV solo si es Cotización
                    if (_tipoCotizacion == 'Cotización')
                      _buildInputField(
                        controller: _isvController,
                        label: 'ISV',
                        icon: Icons.money,
                        validator: (value) => value == null || value.isEmpty ? 'Ingrese el ISV' : null,
                      ),
                    _buildInputField(
                      controller: _totalController,
                      label: 'Total',
                      icon: Icons.attach_money,
                      validator: (value) => value == null || value.isEmpty ? 'Ingrese el total' : null,
                    ),
                    const SizedBox(height: 20),
                    // Botón de guardar cotización
                    ButtonXXL(
                      funcion: () => _guardarCotizacion(),
                      texto: 'Guardar Cotización',
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
