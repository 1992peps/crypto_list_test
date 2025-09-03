import '../../../../core/utils/currency.dart';

class Token {
  final String id;
  final String symbol;

  final double? priceUsd;

  const Token({required this.id, required this.symbol, this.priceUsd});

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(
      id: json['id'] as String,
      symbol: json['symbol'] as String,
      priceUsd: tryParseDouble(json['priceUsd']),
    );
  }
}
