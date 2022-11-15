import 'package:flutter/material.dart'
    show BuildContext, ChangeNotifier, Navigator;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:rastreo_bam/config/app_config.dart';
import 'package:rastreo_bam/models/models.dart' show User;
import 'package:rastreo_bam/services/services.dart' show HttpService;
import 'package:rastreo_bam/widgets/alert.dart';

class AuthService extends ChangeNotifier {
  static const _storage = FlutterSecureStorage();
  static String userName = '';

  static Future<User> login(String username, String password) async {
    try {
      Map<String, dynamic> args = {
        'usr_cod': username,
        'pass': password,
        'version': AppConfig.appVersion
      };

      final res = await HttpService.postData('public/api/v2/login.php', args);

      if (res == null) User(codigo: 500, mensaje: 'Ha ocurrido un error');
      if (res?.body == null) User(codigo: 500, mensaje: 'Ha ocurrido un error');

      final data = User.fromJson(res!.body);

      if (data.codigo != null) {
        if (data.codigo == 200 && (data.token ?? '').isNotEmpty) {
          await _storage.write(key: 'usr_token', value: data.token);
          await _storage.write(key: 'usr_id', value: data.idUsr.toString());
          await _storage.write(key: 'usr_cod', value: data.usrCod);
          await _storage.write(key: 'usr_nombre', value: data.usrNombre);
          userName = data.usrNombre!;
        }
        return data;
      } else {
        return User(codigo: 500, mensaje: 'Ha ocurrido un error');
      }
    } catch (e) {
      return User(codigo: 500, mensaje: 'Ha ocurrido un error');
    }
  }

  static Future<User> autoLogin() async {
    try {
      Map<String, dynamic> args = {
        'id_usr': await getStorageKey('usr_id'),
        'usr_cod': await getStorageKey('usr_cod'),
        'token': await getStorageKey('usr_token'),
        'version': AppConfig.appVersion
      };

      final res =
          await HttpService.postData('public/api/v2/autologin.php', args);

      if (res == null) User(codigo: 500, mensaje: 'Ha ocurrido un error');
      if (res?.body == null) User(codigo: 500, mensaje: 'Ha ocurrido un error');

      final data = User.fromJson(res!.body);

      if (data.codigo != null) {
        userName = data.usrNombre!;
        return data;
      } else {
        return User(codigo: 500, mensaje: 'Ha ocurrido un error');
      }
    } catch (e) {
      return User(codigo: 500, mensaje: 'Ha ocurrido un error');
    }
  }

  static void logout(BuildContext context, [bool expired = false]) {
    Navigator.pushReplacementNamed(context, 'login');
  }

  static Future<Map<String, String>> readUserInfo() async {
    Map<String, String> userInfo = {
      'usr_cod': await _storage.read(key: 'usr_cod') ?? '',
      'usr_nombre': await _storage.read(key: 'usr_nombre') ?? '',
    };
    return userInfo;
  }

  static Future<dynamic> getStorageKey(String key) async {
    return await _storage.read(key: key) ?? '';
  }

  static Future<dynamic> changeValueKey(String key, value) async {
    await _storage.write(key: key, value: value);
  }
}
