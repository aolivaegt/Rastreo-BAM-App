import 'dart:convert' show json;
import 'package:rastreo_bam/models/models.dart'
    show ManifiestoDetalle, Mensajero;

class Manifiesto {
  int? codigo;
  int? idManifiesto;
  String? nManifiesto;
  String? fecha;
  String? idMensajero;
  String? mensajero;
  String? estado;
  String? estatusApp;
  String? ccostoCodigo;
  String? ccostoNombre;
  String? destinatario;
  String? cantidad;
  List<ManifiestoDetalle>? detalle;
  String? total;
  // ManifiestoDatos? datos;
  List<Mensajero>? mensajeros;

  Manifiesto({
    this.codigo,
    this.idManifiesto,
    this.nManifiesto,
    this.fecha,
    this.idMensajero,
    this.mensajero,
    this.estado,
    this.estatusApp,
    this.ccostoCodigo,
    this.ccostoNombre,
    this.destinatario,
    this.cantidad,
    this.detalle,
    this.total,
    // this.datos,
    this.mensajeros,
  });

  factory Manifiesto.fromJson(String str) =>
      Manifiesto.fromMap(json.decode(str));

  factory Manifiesto.fromMap(Map<String, dynamic> json) => Manifiesto(
        codigo: json["codigo"] ?? 0,
        idManifiesto: json["id_manifiesto"] != null
            ? int.parse(json["id_manifiesto"])
            : 0,
        nManifiesto: json["n_manifiesto"],
        fecha: json["fecha"],
        idMensajero: json["id_mensajero"],
        mensajero: json["mensajero"],
        estado: json["estado"],
        estatusApp: json["estatus_app"],
        ccostoCodigo: json["ccosto_codigo"],
        ccostoNombre: json["ccosto_nombre"],
        destinatario: json["destinatario"],
        cantidad: json["cantidad"],
        detalle: json["detalle"] != null
            ? List<ManifiestoDetalle>.from(
                json["detalle"].map((x) => ManifiestoDetalle.fromMap(x)))
            : [],
        total: json["total"].toString(),
        // datos: ManifiestoDatos.fromMap(json["datos"]),
        mensajeros: json["mensajeros"] != null
            ? List<Mensajero>.from(
                json["mensajeros"].map((x) => Mensajero.fromMap(x)))
            : [],
      );
}

// class ManifiestoDatos {
//   int? idManifiesto;
//   String? nManifiesto;
//   String? fecha;
//   String? idMensajero;
//   String? mensajero;
//   String? estado;
//   String? estatusApp;
//   String? ccostoCodigo;
//   String? ccostoNombre;
//   String? destinatario;

//   ManifiestoDatos({
//     this.idManifiesto,
//     this.nManifiesto,
//     this.fecha,
//     this.idMensajero,
//     this.mensajero,
//     this.estado,
//     this.estatusApp,
//     this.ccostoCodigo,
//     this.ccostoNombre,
//     this.destinatario,
//   });

//   factory ManifiestoDatos.fromJson(String str) =>
//       ManifiestoDatos.fromMap(json.decode(str));

//   factory ManifiestoDatos.fromMap(Map<String, dynamic> json) => ManifiestoDatos(
//         idManifiesto: json["id_manifiesto"] == null
//             ? int.parse(json["id_manifiesto"].toString())
//             : 0,
//         nManifiesto: json["n_manifiesto"],
//         fecha: json["fecha"],
//         idMensajero: json["id_mensajero"],
//         mensajero: json["mensajero"],
//         estado: json["estado"],
//         estatusApp: json["estatus_app"],
//         ccostoCodigo: json["ccosto_codigo"],
//         ccostoNombre: json["ccosto_nombre"],
//         destinatario: json["destinatario"],
//       );
// }
