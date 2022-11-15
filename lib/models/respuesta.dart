import 'dart:convert' show json;

class Respuesta {
  int? codigo;
  String? mensaje;

  Respuesta({
    this.codigo,
    this.mensaje,
  });

  factory Respuesta.fromJson(String str) => Respuesta.fromMap(json.decode(str));

  factory Respuesta.fromMap(Map<String, dynamic> json) => Respuesta(
        codigo:
            json["codigo"] != null ? int.parse(json["codigo"].toString()) : 400,
        mensaje: json["mensaje"] ?? '',
      );
}
