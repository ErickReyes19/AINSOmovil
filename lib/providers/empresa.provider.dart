import 'package:ainso/models/models.dart';
import 'package:flutter/material.dart';

class EmpresaProvider with ChangeNotifier {
  Empresa? _empresa;
  bool _loading = false;

  bool get loading => _loading;
  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Empresa? get empresa => _empresa;
  set empresa(Empresa? value) {
    _empresa = value;
    notifyListeners();
  }

  // Resetear el provider
  void resetProvider() {
    _empresa = null;
    _loading = false;
    notifyListeners();
  }
}
