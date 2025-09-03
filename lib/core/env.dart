import 'package:flutter_dotenv/flutter_dotenv.dart';

String? getCoincapApiKey() {
  final key = dotenv.env['COINCAP_API_KEY'];
  return (key == null || key.isEmpty) ? null : key;
}