import 'dart:convert';

import 'package:rastreo_bam/models/models.dart' show Mensajero;

class Mensajeros {
  int codigo;
  List<Mensajero> datos;
  int total;

  Mensajeros({
    required this.codigo,
    required this.datos,
    required this.total,
  });

  factory Mensajeros.fromJson(String str) =>
      Mensajeros.fromMap(json.decode(str));

  factory Mensajeros.fromMap(Map<String, dynamic> json) => Mensajeros(
        codigo: json["codigo"],
        datos: List<Mensajero>.from(
            json["datos"].map((x) => Mensajero.fromMap(x))),
        total: int.parse(json["total"].toString()),
      );
}
