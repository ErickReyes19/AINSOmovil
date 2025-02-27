import 'package:flutter/material.dart';
import '../models/models.dart';

class CotizacionProvider with ChangeNotifier {
  List<Cotizacion> _cotizaciones = [];
  Cotizacion? _cotizacion;
  bool _loading = false;

  List<Cotizacion> get cotizaciones => _cotizaciones;

  Cotizacion? get cotizacion => _cotizacion;

  bool get loading => _loading;

  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  set cotizaciones(List<Cotizacion> value) {
    _cotizaciones = value;
    notifyListeners();
  }

  set cotizacion(Cotizacion? value) {
    _cotizacion = value;
    notifyListeners();
  }

  resetProvider() {
    _cotizaciones = [];
    _cotizacion = null;
    _loading = false;
    notifyListeners();
  }
}
