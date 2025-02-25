import 'package:ainso/cosntans.dart';
import 'package:flutter/material.dart';





globalSnackBar(String texto, {Color? color = Colors.red}) {
  final snackBar = SnackBar(
    content: Text(texto),
    backgroundColor: color,
  );
  snackbarKey.currentState?.showSnackBar(snackBar);
}