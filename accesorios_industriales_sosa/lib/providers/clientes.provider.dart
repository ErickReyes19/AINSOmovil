import 'package:flutter/material.dart';

import '../models/models.dart';

class ClientesProvider with ChangeNotifier {
  List<Cliente> _listCliente = [];
  List<Cliente> _listFiltrado = [];
  bool _filtrandoCliente = false;
  bool _loading = false;
  int _idClienteSelected = 0;
  String _nombreClienteSelected = 'Seleccione un cliente';
  bool _mostrandoClienteCreado = false;
  String _nombreClienteSeleccionado = '';
  TextEditingController nombreClienteController = TextEditingController();

  String get nombreClienteSelected => _nombreClienteSelected;
  
  bool get mostrandoClienteCreado => _mostrandoClienteCreado;

  set mostrandoClienteCreado(bool value) {
    _mostrandoClienteCreado = value;
    notifyListeners();
  }
    set cambiarNombreClienteController(String value) {
    nombreClienteController.text = value;
    notifyListeners();
  }

    String get nombreClienteSeleccionado => _nombreClienteSeleccionado;

  set nombreClienteSeleccionado(String value) {
    _nombreClienteSeleccionado = value;
    notifyListeners();
  }



  

  set nombreClienteSelected(String value) {
    _nombreClienteSelected = value;
    notifyListeners();
  }

  int get idClienteSelected => _idClienteSelected;

  set idClienteSelected(int value) {
    _idClienteSelected = value;
    notifyListeners();
  }

  bool get loading => _loading;

  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  List<Cliente> get listCliente => _listCliente;

  set listCliente(List<Cliente> value) {
    _listCliente = value;
    notifyListeners();
  }

  bool get filtrandoCliente => _filtrandoCliente;

  set filtrandoCliente(bool value) {
    _filtrandoCliente = value;
    notifyListeners();
  }

  List<Cliente> get listFiltrado => _listFiltrado;

  set listFiltrado(List<Cliente> value) {
    _listFiltrado = value;
    notifyListeners();
  }

  resetProvider() {
    _listCliente = [];
    _listFiltrado = [];
    _loading = false;
    _idClienteSelected = 0;
    _filtrandoCliente = false;
  }
}
