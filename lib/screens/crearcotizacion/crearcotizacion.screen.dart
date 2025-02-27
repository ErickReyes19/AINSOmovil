import 'package:ainso/controllers/controller.dart';
import 'package:ainso/globals/widgets/snackbarglobal.helper.global.dart';
import 'package:ainso/models/models.dart';
import 'package:ainso/providers/providers.dart';
import 'package:ainso/screens/crearfactura/components/buscarcliente.component.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CrearCotizacionScreen extends StatefulWidget {
  const CrearCotizacionScreen({Key? key}) : super(key: key);

  @override
  _CrearCotizacionScreenState createState() => _CrearCotizacionScreenState();
}

class _CrearCotizacionScreenState extends State<CrearCotizacionScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _numeroCotizacionController = TextEditingController();
  TextEditingController _subtotalController = TextEditingController();
  TextEditingController _totalController = TextEditingController();
  TextEditingController _isvController = TextEditingController();
  List<Map<String, TextEditingController>> _itemsControllers = [];
  String tipoSeleccionado = 'Cliente';
  String _tipoPago = 'Contado';
  String _tipoCotizacion = 'Cotización';
  double _subtotal = 0.0;
  double _total = 0.0;
  double _isv = 0.0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _agregarItem();  // Agregar el primer ítem
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
    for (var item in _itemsControllers) {
      double precio = double.tryParse(item["precio"]?.text ?? '') ?? 0.0;
      int cantidad = int.tryParse(item["cantidad"]?.text ?? '') ?? 0;
      double totalItem = cantidad * precio;
      item["total"]?.text = totalItem.toStringAsFixed(2);
      subtotalTemp += totalItem;
    }
    setState(() {
      _subtotal = subtotalTemp;
      _total = _subtotal;
      _isv = _tipoCotizacion == 'Cotización' ? _subtotal * 0.15 : 0.0;
      _total = _subtotal + _isv;
      _subtotalController.text = _subtotal.toStringAsFixed(2);
      _isvController.text = _isv.toStringAsFixed(2);
      _totalController.text = _total.toStringAsFixed(2);
    });
  }

  Future<void> _guardarCotizacion() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      // Crear el objeto Cotizacion
      Cotizacion cotizacion = Cotizacion(
        cotizacion: CotizacionClass(
          idCotizacion: 0, // El ID será generado por la base de datos
          idCliente: 1, // Aquí deberías obtener el ID del cliente de la base de datos o el controlador
          fecha: DateTime.now(),
          total: _total.toInt(),
          subtotal: _subtotal.toInt(),
          isv: _isv.toInt(),
          numeroCotizacion: _numeroCotizacionController.text,
          tipoPago: _tipoPago,
          tipoCotizacion: _tipoCotizacion,
        ),
        items: _itemsControllers.map((item) {
          return Item(
            idItem: 0, // El ID será generado por la base de datos
            idCotizacion: 0, // Este será el ID de la cotización generada
            nombre: item["nombre"]?.text ?? '',
            precio: double.tryParse(item["precio"]?.text ?? '') ?? 0.0,
            descripcion: item["descripcion"]?.text ?? '',
            cantidad: int.tryParse(item["cantidad"]?.text ?? '') ?? 0,
            unidad: item["unidad"]?.text ?? '',
            total: double.tryParse(item["total"]?.text ?? '') ?? 0.0,
          );
        }).toList(),
      );

      // Llamada al controlador para guardar la cotización
      bool success = await insertarCotizacion(cotizacion, context);

      if (success) {
        setState(() {
          _isLoading = false;
        });
        Navigator.pop(context);
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<bool> insertarCotizacion(Cotizacion cotizacion, BuildContext context) async {
    final provider = Provider.of<CotizacionProvider>(context, listen: false);
    try {
      provider.loading = true;
      bool idCotizacion = await CotizacionController().insertarCotizacion(cotizacion, context);

      if (idCotizacion != -1) {
        provider.cotizaciones.add(cotizacion); // Agregar la nueva cotización al provider
        provider.loading = false;
        sncackbarGlobal('Cotización agregada con éxito.', color: Colors.green);
        return true;
      } else {
        provider.loading = false;
        sncackbarGlobal('Error al agregar la cotización.', color: Colors.red);
        return false;
      }
    } catch (e) {
      provider.loading = false;
      sncackbarGlobal('Error al agregar la cotización.', color: Colors.red);
      return false;
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
                      onChanged: (String? newValue) async {
                        if (newValue != null) {
                          setState(() {
                            tipoSeleccionado = newValue;
                          });
                          // Llamar al controlador según el tipo seleccionado
                          if (tipoSeleccionado == 'Cliente') {
                            // Aquí se llamaría al controlador de clientes activos
                          } else {
                            // Aquí se llamaría al controlador de proveedores activos
                          }
                        }
                      },
                      items: <String>['Cliente', 'Proveedor']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: GoogleFonts.poppins(color: Colors.blue),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 10),
                    // Buscador de cliente (se actualiza según el tipo seleccionado)
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
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          _tipoPago = newValue!;
                        });
                      },
                      items: ['Contado', 'Crédito'].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value, style: GoogleFonts.poppins()),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    // Agregar ítems
                    const Text('Items', style: TextStyle(fontWeight: FontWeight.bold)),
                    ..._itemsControllers.map((item) {
                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                    ElevatedButton(
                      onPressed: _agregarItem,
                      child: Text('Agregar Item'),
                    ),
                    const SizedBox(height: 20),
                    // Totales
                    _buildInputField(
                      controller: _subtotalController,
                      label: 'Subtotal',
                      icon: Icons.account_balance_wallet,
                      validator: (value) => value == null || value.isEmpty ? 'Ingrese el subtotal' : null,
                    ),
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
                    // Botón de guardar
                    ElevatedButton(
                      onPressed: _guardarCotizacion,
                      child: Text('Guardar Cotización', style: GoogleFonts.poppins()),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
