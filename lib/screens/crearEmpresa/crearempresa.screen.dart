// ignore_for_file: library_private_types_in_public_api, unused_local_variable

import 'package:ainso/controllers/empresa.controller.dart';
import 'package:ainso/globals/widgets/widgets.dart';
import 'package:ainso/models/models.dart';
import 'package:flutter/material.dart';

class CrearEmpresaScreen extends StatefulWidget {
  final String titulo;
  final Empresa? empresa; // Parámetro opcional para edición

  const CrearEmpresaScreen({super.key, required this.titulo, this.empresa});

  @override
  _CrearEmpresaScreenState createState() => _CrearEmpresaScreenState();
}

class _CrearEmpresaScreenState extends State<CrearEmpresaScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controladores para datos de la empresa
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _direccionController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _rtnController = TextEditingController();

  // Listas para los campos dinámicos de bancos y teléfonos
  final List<Map<String, TextEditingController>> _banksControllers = [];
  final List<TextEditingController> _phoneControllers = [];

  bool _isLoading = false; // Controlador de carga

  @override
  void initState() {
    super.initState();
    // Si se pasó una empresa, prellenamos los campos y listas
    if (widget.empresa != null) {
      _nombreController.text = widget.empresa!.nombre;
      _direccionController.text = widget.empresa!.direccion;
      _emailController.text = widget.empresa!.email;
      _rtnController.text = widget.empresa!.rtn;

      // Prellenar bancos
      if (widget.empresa!.bancos.isNotEmpty) {
        for (var banco in widget.empresa!.bancos) {
          _banksControllers.add({
            "banco": TextEditingController(text: banco.banco),
            "nombre": TextEditingController(text: banco.nombre),
            "cuenta": TextEditingController(text: banco.cuenta),
          });
        }
      } else {
        _addBank();
      }

      // Prellenar teléfonos
      if (widget.empresa!.telefonos.isNotEmpty) {
        for (var telefono in widget.empresa!.telefonos) {
          _phoneControllers.add(TextEditingController(text: telefono.telefono));
        }
      } else {
        _addPhone();
      }
    } else {
      // Si es creación, agregamos un banco y un teléfono por defecto
      _addBank();
      _addPhone();
    }
  }

  void _addBank() {
    setState(() {
      _banksControllers.add({
        "banco": TextEditingController(),
        "nombre": TextEditingController(),
        "cuenta": TextEditingController(),
      });
    });
  }

  void _removeBank(int index) {
    setState(() {
      _banksControllers.removeAt(index);
    });
  }

  void _addPhone() {
    setState(() {
      _phoneControllers.add(TextEditingController());
    });
  }

  void _removePhone(int index) {
    setState(() {
      _phoneControllers.removeAt(index);
    });
  }

  Future<void> _guardarEmpresa(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      // Construir lista de bancos
      List<Banco> bancos =
          _banksControllers.map((bankMap) {
            return Banco(
              idBanco: 0,
              banco: bankMap["banco"]!.text,
              nombre: bankMap["nombre"]!.text,
              cuenta: bankMap["cuenta"]!.text,
              idEmpresa: 0,
            );
          }).toList();

      // Construir lista de teléfonos
      List<Telefono> telefonos =
          _phoneControllers.map((controller) {
            return Telefono(
              idTelefono: 0,
              telefono: controller.text,
              idEmpresa: 0,
            );
          }).toList();

      // Construir el modelo Empresa
      Empresa nuevaEmpresa = Empresa(
        idEmpresa: widget.empresa?.idEmpresa ?? 0,
        nombre: _nombreController.text,
        direccion: _direccionController.text,
        email: _emailController.text,
        rtn: _rtnController.text,
        bancos: bancos,
        telefonos: telefonos,
      );

      bool result;
      // Si la empresa existe, llamamos al controlador de editar; de lo contrario, al de insertar.
      if (widget.empresa != null) {
        result = await EmpresaController().editarEmpresa(nuevaEmpresa, context);
      } else {
        result = await EmpresaController().insertarEmpresa(
          nuevaEmpresa,
          context,
        );
      }

      setState(() {
        _isLoading = false;
      });
        Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.titulo),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Datos de la empresa
              _buildInputField(
                controller: _nombreController,
                label: 'Nombre de la Empresa',
                icon: Icons.business,
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Ingrese el nombre'
                            : null,
              ),
              _buildInputField(
                controller: _direccionController,
                label: 'Dirección',
                icon: Icons.location_on,
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Ingrese la dirección'
                            : null,
              ),
              _buildInputField(
                controller: _emailController,
                label: 'Email',
                icon: Icons.email,
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Ingrese el email'
                            : null,
              ),
              _buildInputField(
                controller: _rtnController,
                label: 'RTN',
                icon: Icons.business,
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Ingrese el RTN'
                            : null,
              ),
              const SizedBox(height: 20),

              // Sección de Bancos
              Text(
                "Bancos",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _banksControllers.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Banco ${index + 1}",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          _buildInputField(
                            controller: _banksControllers[index]["banco"]!,
                            label: 'Banco',
                            icon: Icons.account_balance,
                            validator:
                                (value) =>
                                    value == null || value.isEmpty
                                        ? 'Ingrese el nombre del banco'
                                        : null,
                          ),
                          _buildInputField(
                            controller: _banksControllers[index]["nombre"]!,
                            label: 'Nombre de la cuenta',
                            icon: Icons.account_circle,
                            validator:
                                (value) =>
                                    value == null || value.isEmpty
                                        ? 'Ingrese el nombre de la cuenta'
                                        : null,
                          ),
                          _buildInputField(
                            controller: _banksControllers[index]["cuenta"]!,
                            label: 'Número de cuenta',
                            icon: Icons.credit_card,
                            validator:
                                (value) =>
                                    value == null || value.isEmpty
                                        ? 'Ingrese el número de cuenta'
                                        : null,
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _removeBank(index),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              TextButton.icon(
                onPressed: _addBank,
                icon: Icon(Icons.add),
                label: Text("Agregar nuevo banco"),
              ),
              const SizedBox(height: 20),

              // Sección de Teléfonos
              Text(
                "Teléfonos",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _phoneControllers.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildInputField(
                              controller: _phoneControllers[index],
                              label: 'Teléfono',
                              icon: Icons.phone,
                              validator:
                                  (value) =>
                                      value == null || value.isEmpty
                                          ? 'Ingrese el teléfono'
                                          : null,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _removePhone(index),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              TextButton.icon(
                onPressed: _addPhone,
                icon: Icon(Icons.add),
                label: Text("Agregar nuevo teléfono"),
              ),
              const SizedBox(height: 30),
              Center(
                child:
                    _isLoading
                        ? CircularProgressIndicator()
                        : ButtonXXL(
                          funcion: () => _guardarEmpresa(context),
                          texto:
                              widget.empresa != null
                                  ? "Actualizar Empresa"
                                  : "Guardar Empresa",
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget para el campo de entrada
  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String? Function(String?) validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.blueAccent),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: validator,
      ),
    );
  }
}
