import 'dart:convert' show json;

class ManifiestoDetalle {
  String? idLinea;
  String? idEnvio;
  String? barra;

  ManifiestoDetalle({
    this.idLinea,
    this.idEnvio,
    this.barra,
  });

  factory ManifiestoDetalle.fromJson(String str) =>
      ManifiestoDetalle.fromMap(json.decode(str));

  factory ManifiestoDetalle.fromMap(Map<String, dynamic> json) =>
      ManifiestoDetalle(
        idLinea: json["id_linea"] != null ? json["id_linea"].toString() : '',
        idEnvio: json["id_envio"] != null ? json["id_envio"].toString() : '',
        barra: json["barra"] != null ? json["barra"].toString() : '',
      );
}
