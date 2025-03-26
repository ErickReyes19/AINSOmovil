import 'package:ainso/models/cotizacionCliente.model.dart';
import 'package:ainso/models/cotizacionClienteReporte.model.dart';
import 'package:flutter/material.dart';
import '../models/models.dart';

class CotizacionProvider with ChangeNotifier {
  List<CotizacionCliente> _cotizaciones = [];
  Cotizacion? _cotizacion;
  CotizacionCliente? _cotizacionCliente;
  CotizacionClienteReporte? _cotizacionClienteReporte;
  bool _loading = false;

  List<CotizacionCliente> get cotizaciones => _cotizaciones;

  Cotizacion? get cotizacion => _cotizacion;

  CotizacionCliente? get cotizacionCliente => _cotizacionCliente;
  CotizacionClienteReporte? get cotizacionClienteReporte => _cotizacionClienteReporte;

  bool get loading => _loading;

  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  set cotizaciones(List<CotizacionCliente> value) {
    _cotizaciones = value;
    notifyListeners();
  }

  set cotizacion(Cotizacion? value) {
    _cotizacion = value;
    notifyListeners();
  }
  set cotizacionCliente(CotizacionCliente? value) {
    _cotizacionCliente = value;
    notifyListeners();
  }
  set cotizacionClienteReporte(CotizacionClienteReporte? value) {
    _cotizacionClienteReporte = value;
    notifyListeners();
  }

  resetProvider() {
    _cotizaciones = [];
    _cotizacion = null;
    _loading = false;
    notifyListeners();
  }
}
