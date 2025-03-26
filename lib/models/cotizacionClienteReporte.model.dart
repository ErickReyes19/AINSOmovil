// To parse this JSON data, do
//
//     final cotizacionClienteReporte = cotizacionClienteReporteFromJson(jsonString);

import 'dart:convert';

import 'package:ainso/models/models.dart';

CotizacionClienteReporte cotizacionClienteReporteFromJson(String str) => CotizacionClienteReporte.fromJson(json.decode(str));

String cotizacionClienteReporteToJson(CotizacionClienteReporte data) => json.encode(data.toJson());

class CotizacionClienteReporte {
    Cliente cliente;
    List<Cotizacion> cotizaciones;

    CotizacionClienteReporte({
        required this.cliente,
        required this.cotizaciones,
    });

    factory CotizacionClienteReporte.fromJson(Map<String, dynamic> json) => CotizacionClienteReporte(
        cliente: Cliente.fromJson(json["cliente"]),
        cotizaciones: List<Cotizacion>.from(json["cotizaciones"].map((x) => Cotizacion.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "cliente": cliente.toJson(),
        "cotizaciones": List<dynamic>.from(cotizaciones.map((x) => x.toJson())),
    };
}


