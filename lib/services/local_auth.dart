import 'package:flutter/cupertino.dart';
import 'package:local_auth/local_auth.dart';

class LocalAuth extends ChangeNotifier {
  static final LocalAuthentication _auth = LocalAuthentication();

  bool _isAuthenticating = false;
  bool _isSupported = false;

  bool get isSupported => _isSupported;

  set isSupported(bool value) {
    _isSupported = value;
    notifyListeners();
  }

  bool get isAuthenticating => _isAuthenticating;

  set isAuthenticating(bool value) {
    _isAuthenticating = value;
    notifyListeners();
  }

  // Método para verificar si el dipositivo soporta la autenticación
  Future<bool> isDeviceSupported() async {
    isSupported = await _auth.isDeviceSupported();
    return isSupported;
  }

  // Método para verifcar que tenga onfigurado los biometricos
  Future<bool> checkBiometrics() async {
    try {
      return await _auth.canCheckBiometrics;
    } catch (e) {
      return false;
    }
  }

  // método para obtener los tipos de biometricos disponibles
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _auth.getAvailableBiometrics();
    } catch (e) {
      return <BiometricType>[];
    }
  }

  // Método para autenticar
  Future<bool> authenticateWithBiometrics() async {
    bool authenticated = false;
    try {
      _isAuthenticating = true;

      authenticated = await _auth.authenticate(
        localizedReason: 'Escanee su huella digital',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );

      _isAuthenticating = false;
      return authenticated;
    } catch (e) {
      _isAuthenticating = false;
      return false;
    }
  }

  // método para cancelar la autenticación
  Future<bool> cancelAuthentication() async {
    return await _auth.stopAuthentication();
  }
}
