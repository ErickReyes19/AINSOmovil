// To parse this JSON data, do
//
//     final clientes = clientesFromJson(jsonString);

import 'dart:convert';

Clientes clientesFromJson(String str) => Clientes.fromJson(json.decode(str));

String clientesToJson(Clientes data) => json.encode(data.toJson());

class Clientes {
  Clientes({
    required this.clientes,
  });

  List<Cliente> clientes;

  factory Clientes.fromJson(Map<String, dynamic> json) => Clientes(
        clientes: List<Cliente>.from(
            json["Clientes"].map((x) => Cliente.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Clientes": List<dynamic>.from(clientes.map((x) => x.toJson())),
      };
}

class Cliente {
  Cliente({
    this.idCliente,
    required this.nombre,
    required this.estado,
    required this.tipo
  });

  int? idCliente;
  String nombre;
  int estado;
  String tipo;

  factory Cliente.fromJson(Map<String, dynamic> json) => Cliente(
      idCliente: json["idCliente"],
      nombre: json["nombreCliente"],
      estado: json["estado"],
      tipo: json["tipo"]);

  Map<String, dynamic> toJson() =>
      {"idCliente": idCliente, "nombreCliente": nombre, "estado": estado, "tipo": tipo};
}
