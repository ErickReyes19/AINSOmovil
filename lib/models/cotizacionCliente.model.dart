// To parse this JSON data, do
//
//     final cotizacionCliente = cotizacionClienteFromJson(jsonString);

import 'dart:convert';
import 'package:ainso/models/models.dart';

CotizacionCliente cotizacionClienteFromJson(String str) => CotizacionCliente.fromJson(json.decode(str));

String cotizacionClienteToJson(CotizacionCliente data) => json.encode(data.toJson());

class CotizacionCliente {
    Cotizacion cotizacion;
    Cliente cliente;

    CotizacionCliente({
        required this.cotizacion,
        required this.cliente,
    });

    factory CotizacionCliente.fromJson(Map<String, dynamic> json) => CotizacionCliente(
        cotizacion: Cotizacion.fromJson(json["cotizacion"]),
        cliente: Cliente.fromJson(json["cliente"]),
    );

    Map<String, dynamic> toJson() => {
        "cotizacion": cotizacion.toJson(),
        "cliente": cliente.toJson(),
    };
}
