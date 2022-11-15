import 'dart:convert' show json;

class Mensajero {
  int? idMensajero;
  String? nombre;

  Mensajero({
    this.idMensajero,
    this.nombre,
  });

  factory Mensajero.fromJson(String str) => Mensajero.fromMap(json.decode(str));

  factory Mensajero.fromMap(Map<String, dynamic> json) => Mensajero(
        idMensajero: json["id_mensajero"] != null
            ? int.parse(json["id_mensajero"].toString())
            : 0,
        nombre: json["nombre"],
      );
}
