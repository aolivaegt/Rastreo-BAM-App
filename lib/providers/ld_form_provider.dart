import 'package:flutter/material.dart'
    show ChangeNotifier, FormState, GlobalKey, TextEditingController;

class LDFromProvider extends ChangeNotifier {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final barraController = TextEditingController();

  int idMensajero = 0;
  String mensajero = '';
  String barra = '';
  bool _cambio = false;

  bool get cambio => _cambio;

  set cambio(bool value) {
    _cambio = value;
    notifyListeners();
  }
}
