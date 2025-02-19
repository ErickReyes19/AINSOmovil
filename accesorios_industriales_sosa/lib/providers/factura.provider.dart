import 'package:accesorios_industriales_sosa/models/factura.model.dart';
import 'package:flutter/material.dart';

class FacturaProvider with ChangeNotifier {
  List<Factura> _listFactura = [];
  List<Factura> _listFacturaOrdenadaFecha = [];
  bool _loading = false;




  bool get loading => _loading;

  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  List<Factura> get listFactura => _listFactura;

  set listFactura(List<Factura> value) {
    _listFactura = value;
    notifyListeners();
  }

  List<Factura> get listFacturaOrdenadaFecha => _listFacturaOrdenadaFecha;

  set listFacturaOrdenadaFecha(List<Factura> value) {
    _listFacturaOrdenadaFecha = value;
    notifyListeners();
  }

  List<Factura> ordenarFacturasPorFecha(List<Factura> listaFacturas) {
  listaFacturas.sort((a, b) => a.fecha.compareTo(b.fecha));
  _listFacturaOrdenadaFecha = listaFacturas;
  return _listFacturaOrdenadaFecha;
}




  resetProvider() {
    _listFactura = [];
    _loading = false;
  }
}
