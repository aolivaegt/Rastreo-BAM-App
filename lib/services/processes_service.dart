import 'dart:convert';
import 'dart:math' show Random;
import 'package:flutter/material.dart' show ChangeNotifier;
import 'package:rastreo_bam/models/models.dart';
import 'package:rastreo_bam/services/services.dart'
    show AuthService, HttpService;

class ProcessesService with ChangeNotifier {
  static List<Mensajero> mensajeros = [];
  static bool isPendiente = false;

  static Future<ProcesarLD> procesarLD(idMensajero, String barra,
      [String manifiesto = '']) async {
    final unico = Random().nextInt(1000);
    // ignore: avoid_print
    print('procesarLD $unico');
    try {
      Map<String, dynamic> args = {
        'id_usr': await AuthService.getStorageKey('usr_id'),
        'token_usr': await AuthService.getStorageKey('usr_token'),
        'id_mensajero': idMensajero,
        'barra': barra,
        'n_manifiesto': manifiesto
      };

      final res =
          await HttpService.postData('public/api/v2/procesarLD.php', args);

      if (res == null) {
        return ProcesarLD(codigo: 500, mensaje: 'Ha ocurrido un error');
      }

      final data = ProcesarLD.fromJson(res.body);
      return data;
    } catch (e) {
      return ProcesarLD(codigo: 500, mensaje: 'Ha ocurrido un error');
    }
  }

  static Future<Respuesta> updateManifiesto(String manifiesto) async {
    final unico = Random().nextInt(1000);
    final response = Respuesta();
    // ignore: avoid_print
    print('updateManifiesto $unico');
    try {
      Map<String, dynamic> args = {
        'id_usr': await AuthService.getStorageKey('usr_id'),
        'token_usr': await AuthService.getStorageKey('usr_token'),
        'n_manifiesto': manifiesto
      };

      final res = await HttpService.putData(
          'public/api/v2/update_manifiesto.php', args);
      if (res == null) return response;

      print(res.body);

      return Respuesta.fromJson(res.body);
    } catch (e) {
      print(e);
      return Respuesta(codigo: 500, mensaje: 'Ha ocurrido un error 2');
    }
  }

  getMensajeros() async {
    final unico = Random().nextInt(1000);
    // ignore: avoid_print
    print('getMensajeros $unico');
    try {
      final res = await HttpService.getData('public/api/v2/mensajeros.php', {});
      if (res == null) return 'error';
      final data = Mensajeros.fromJson(res.body);
      mensajeros = data.datos;
    } catch (e) {
      //
    }
  }

  static Future<List<Manifiesto>> getManifiestos() async {
    final unico = Random().nextInt(1000);
    // ignore: avoid_print
    print('getManifiestos $unico');
    final List<Manifiesto> manifiestos = [];
    try {
      final Map<String, dynamic> args = {
        'id_usr': await AuthService.getStorageKey('usr_id'),
        'token': await AuthService.getStorageKey('usr_token'),
      };
      final res =
          await HttpService.getData('public/api/v2/manifiestos.php', args);
      if (res == null) return manifiestos;
      final data = Manifiestos.fromJson(res.body);
      manifiestos.addAll(data.datos!);
      return manifiestos;
    } catch (e) {
      return manifiestos;
    }
  }

  static Future<Manifiesto> getManifiestoPendiente() async {
    // ignore: unused_local_variable
    final unico = Random().nextInt(1000);
    print('getManifiestos $unico');
    final Manifiesto manifiesto = Manifiesto();
    final int cantidadMensajeros = mensajeros.length;
    final String solicitar = (cantidadMensajeros > 0) ? '0' : '1';
    try {
      final Map<String, dynamic> args = {
        'id_usr': await AuthService.getStorageKey('usr_id'),
        'token': await AuthService.getStorageKey('usr_token'),
        'mensajeros': solicitar,
      };
      final res = await HttpService.getData(
          'public/api/v2/manifiesto_pendiente.php', args);
      // print(soliciarMensajeros);

      if (res?.body == null) return manifiesto;
      final data = Manifiesto.fromJson(res!.body);

      print(res.body);
      final resMensajeros = data.mensajeros ?? [];

      if (resMensajeros.isNotEmpty) {
        mensajeros.clear();
        mensajeros.addAll(resMensajeros);
      } else {
        data.mensajeros?.addAll(mensajeros);
      }
      return data;
    } catch (e) {
      print(e);
      return manifiesto;
    }
  }

  static Future<Manifiesto> getDetalleManifiesto(String nManifiesto) async {
    final unico = Random().nextInt(1000);
    // ignore: avoid_print
    print('getDetalleManifiesto $unico');
    final Manifiesto manifiesto = Manifiesto();
    try {
      final Map<String, dynamic> args = {
        'id_usr': await AuthService.getStorageKey('usr_id'),
        'token': await AuthService.getStorageKey('usr_token'),
        'n_manifiesto': nManifiesto,
      };
      final res = await HttpService.getData(
          'public/api/v2/detalle_manifiesto.php', args);
      if (res == null) return manifiesto;

      return Manifiesto.fromJson(res.body);
    } catch (e) {
      print(e);
      return manifiesto;
    }
  }
}
