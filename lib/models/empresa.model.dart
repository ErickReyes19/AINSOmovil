// To parse this JSON data, do
//
//     final cierre = cierreFromJson(jsonString);

import 'dart:convert';

EmpresaInformacion cierreFromJson(String str) => EmpresaInformacion.fromJson(json.decode(str));

String cierreToJson(EmpresaInformacion data) => json.encode(data.toJson());

class EmpresaInformacion {
    Empresa empresa;

    EmpresaInformacion({
        required this.empresa,
    });

    factory EmpresaInformacion.fromJson(Map<String, dynamic> json) => EmpresaInformacion(
        empresa: Empresa.fromJson(json["empresa"]),
    );

    Map<String, dynamic> toJson() => {
        "empresa": empresa.toJson(),
    };
}

class Empresa {
    int idEmpresa;
    String nombre;
    String direccion;
    String email;
    String rtn;
    List<Banco> bancos;
    List<Telefono> telefonos;

    Empresa({
        required this.idEmpresa,
        required this.nombre,
        required this.direccion,
        required this.email,
        required this.rtn,
        required this.bancos,
        required this.telefonos,
    });

    factory Empresa.fromJson(Map<String, dynamic> json) => Empresa(
        idEmpresa: json["idEmpresa"],
        nombre: json["nombre"],
        direccion: json["direccion"],
        email: json["email"],
        rtn: json["rtn"],
        bancos: List<Banco>.from(json["bancos"].map((x) => Banco.fromJson(x))),
        telefonos: List<Telefono>.from(json["telefonos"].map((x) => Telefono.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "idEmpresa": idEmpresa,
        "nombre": nombre,
        "direccion": direccion,
        "email": email,
        "rtn": rtn,
        "bancos": List<dynamic>.from(bancos.map((x) => x.toJson())),
        "telefonos": List<dynamic>.from(telefonos.map((x) => x.toJson())),
    };
}

class Banco {
    int idBanco;
    String banco;
    String nombre;
    String cuenta;
    int idEmpresa;

    Banco({
        required this.idBanco,
        required this.banco,
        required this.nombre,
        required this.cuenta,
        required this.idEmpresa,
    });

    factory Banco.fromJson(Map<String, dynamic> json) => Banco(
        idBanco: json["idBanco"],
        banco: json["banco"],
        nombre: json["nombre"],
        cuenta: json["cuenta"],
        idEmpresa: json["idEmpresa"],
    );

    Map<String, dynamic> toJson() => {
        "idBanco": idBanco,
        "banco": banco,
        "nombre": nombre,
        "cuenta": cuenta,
        "idEmpresa": idEmpresa,
    };
}

class Telefono {
    int idTelefono;
    String telefono;
    int idEmpresa;

    Telefono({
        required this.idTelefono,
        required this.telefono,
        required this.idEmpresa,
    });

    factory Telefono.fromJson(Map<String, dynamic> json) => Telefono(
        idTelefono: json["idTelefono"],
        telefono: json["telefono"],
        idEmpresa: json["idEmpresa"],
    );

    Map<String, dynamic> toJson() => {
        "idTelefono": idTelefono,
        "telefono": telefono,
        "idEmpresa": idEmpresa,
    };
}
