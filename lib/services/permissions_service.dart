import 'package:permission_handler/permission_handler.dart';

class PermissionsService {
  static Future<bool> getPermitions() async {
    return await Permission.camera.request().isGranted;
  }
}
