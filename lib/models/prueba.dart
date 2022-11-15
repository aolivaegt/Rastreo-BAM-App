import 'dart:convert';

class Manifiestos {
  Manifiestos({
    required this.codigo,
    required this.datos,
    required this.total,
  });

  int codigo;
  // List<Manifiesto> datos;
  dynamic datos;
  int total;

  factory Manifiestos.fromJson(String str) =>
      Manifiestos.fromMap(json.decode(str));

  factory Manifiestos.fromMap(Map<String, dynamic> json) => Manifiestos(
        codigo: json["codigo"],
        datos: json["datos"],
        // datos: List<Manifiesto>.from(
        //     json["datos"].map((x) => Manifiesto.fromMap(x))),
        total: json["total"],
      );
}

class Manifiesto {
  Manifiesto({
    this.idManifiesto,
    this.nManifiesto,
    this.mensajero,
    required this.fecha,
    this.cantidad,
  });

  String? idManifiesto;
  String? nManifiesto;
  String? mensajero;
  DateTime fecha;
  String? cantidad;

  factory Manifiesto.fromJson(String str) =>
      Manifiesto.fromMap(json.decode(str));

  factory Manifiesto.fromMap(Map<String, dynamic> json) => Manifiesto(
        idManifiesto: json["id_manifiesto"],
        nManifiesto: json["n_manifiesto"],
        mensajero: json["mensajero"],
        fecha: DateTime.parse(json["fecha"]),
        cantidad: json["cantidad"],
      );
}
