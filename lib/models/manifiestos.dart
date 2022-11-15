import 'dart:convert' show json;
import 'package:rastreo_bam/models/models.dart' show Manifiesto;

class Manifiestos {
  int? codigo;
  List<Manifiesto>? datos;
  int? total;

  Manifiestos({
    this.codigo,
    this.datos,
    this.total,
  });

  factory Manifiestos.fromJson(String str) =>
      Manifiestos.fromMap(json.decode(str));

  factory Manifiestos.fromMap(Map<String, dynamic> json) => Manifiestos(
        codigo: json["codigo"],
        datos: json["datos"] == null
            ? []
            : List<Manifiesto>.from(
                json["datos"].map((x) => Manifiesto.fromMap(x))),
        total: json["total"],
      );
}
