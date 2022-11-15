import 'package:qrscan/qrscan.dart' as scanner;

class Scanner {
  static String? _result = '';

  static Future<String?> scanBarcode() async {
    try {
      _result = await scanner.scan();
      return _result;
    } catch (e) {
      return '';
    }
  }
}
