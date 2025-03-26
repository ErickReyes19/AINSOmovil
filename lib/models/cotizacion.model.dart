// To parse this JSON data, do
//
//     final cotizacion = cotizacionFromJson(jsonString);

import 'dart:convert';

Cotizacion cotizacionFromJson(String str) => Cotizacion.fromJson(json.decode(str));

String cotizacionToJson(Cotizacion data) => json.encode(data.toJson());

class Cotizacion {
    CotizacionClass cotizacion;
    List<Item> items;

    Cotizacion({
        required this.cotizacion,
        required this.items,
    });

    factory Cotizacion.fromJson(Map<String, dynamic> json) => Cotizacion(
        cotizacion: CotizacionClass.fromJson(json["cotizacion"]),
        items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "cotizacion": cotizacion.toJson(),
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
    };
}

class CotizacionClass {
    int idCotizacion;
    int idCliente;
    DateTime fecha;
    double total;
    double subtotal;
    double isv;
    String numeroCotizacion;
    String tipoPago;
    String tipoCotizacion;

    CotizacionClass({
        required this.idCotizacion,
        required this.idCliente,
        required this.fecha,
        required this.total,
        required this.subtotal,
        required this.isv,
        required this.numeroCotizacion,
        required this.tipoPago,
        required this.tipoCotizacion,
    });

    factory CotizacionClass.fromJson(Map<String, dynamic> json) => CotizacionClass(
        idCotizacion: json["idCotizacion"],
        idCliente: json["idCliente"],
        fecha: DateTime.parse(json["fecha"]),
        total: json["total"],
        subtotal: json["subtotal"],
        isv: json["isv"],
        numeroCotizacion: json["numeroCotizacion"],
        tipoPago: json["tipoPago"],
        tipoCotizacion: json["tipoCotizacion"],
    );

    Map<String, dynamic> toJson() => {
        "idCotizacion": idCotizacion,
        "idCliente": idCliente,
        "fecha": "${fecha.year.toString().padLeft(4, '0')}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}",
        "total": total,
        "subtotal": subtotal,
        "isv": isv,
        "numeroCotizacion": numeroCotizacion,
        "tipoPago": tipoPago,
        "tipoCotizacion": tipoCotizacion,
    };
}

class Item {
    int idItem;
    int idCotizacion;
    String nombre;
    double precio;
    String descripcion;
    int cantidad;
    String unidad;
    double total;

    Item({
        required this.idItem,
        required this.idCotizacion,
        required this.nombre,
        required this.precio,
        required this.descripcion,
        required this.cantidad,
        required this.unidad,
        required this.total,
    });

    factory Item.fromJson(Map<String, dynamic> json) => Item(
        idItem: json["idItem"],
        idCotizacion: json["idCotizacion"],
        nombre: json["nombre"],
        precio: json["precio"],
        descripcion: json["descripcion"],
        cantidad: json["cantidad"],
        unidad: json["unidad"],
        total: json["total"],
    );

    Map<String, dynamic> toJson() => {
        "idItem": idItem,
        "idCotizacion": idCotizacion,
        "nombre": nombre,
        "precio": precio,
        "descripcion": descripcion,
        "cantidad": cantidad,
        "unidad": unidad,
        "total": total,
    };
}
