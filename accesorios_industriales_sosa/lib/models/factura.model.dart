// To parse this JSON data, do
//
//     final facturas = facturasFromJson(jsonString);

import 'dart:convert';

Facturas facturasFromJson(String str) => Facturas.fromJson(json.decode(str));

String facturasToJson(Facturas data) => json.encode(data.toJson());

class Facturas {
    List<Factura> facturas;

    Facturas({
        required this.facturas,
    });

    factory Facturas.fromJson(Map<String, dynamic> json) => Facturas(
        facturas: List<Factura>.from(json["facturas"].map((x) => Factura.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "facturas": List<dynamic>.from(facturas.map((x) => x.toJson())),
    };
}

class Factura {
    int? idFactura;
    int idCliente;
    String numeroFactura;
    num precio;
    DateTime fecha;
    int estado;
    String? nombreCliente;
    String? descripcion;


    Factura({
        this.idFactura,
        required this.idCliente,
        required this.numeroFactura,
        required this.precio,
        required this.fecha,
        required this.estado,
        this.nombreCliente,
        this.descripcion
    });

    factory Factura.fromJson(Map<String, dynamic> json) => Factura(
        idFactura: json["idFactura"],
        idCliente: json["idCliente"],
        numeroFactura: json["numeroFactura"],
        fecha: DateTime.parse(json["fecha"]),
        precio: json["precio"],
        estado: json["estado"],
        nombreCliente: json["nombreCliente"],
        descripcion: json["descripcion"],
    );

    Map<String, dynamic> toJson() => {
        "idFactura": idFactura,
        "idCliente": idCliente,
        "numeroFactura": numeroFactura,
        "fecha": fecha.toIso8601String(),
        "precio": precio,
        "estado": estado,
        "descripcion": descripcion,
    };
}
