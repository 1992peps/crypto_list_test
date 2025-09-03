import 'package:dio/dio.dart';
import '../../../core/network/dio_client.dart';
import 'models/paginated.dart';
import 'models/token.dart';

class CoinCapApi {
  CoinCapApi({Dio? dio, String? apiKey})
    : _dio = dio ?? DioClient.create(apiKey: apiKey);

  final Dio _dio;

  Future<Paginated<Token>> getAssets({
    int limit = 15,
    int offset = 0,
    String? search,
    List<String>? ids,
  }) async {
    final resp = await _dio.get<Map<String, dynamic>>(
      '/assets',
      queryParameters: {
        'limit': limit,
        'offset': offset,
        if (search != null && search.isNotEmpty) 'search': search,
        if (ids != null && ids.isNotEmpty) 'ids': ids.join(','),
      },
    );

    final body = resp.data ?? const {};
    final list = (body['data'] as List?) ?? const [];
    final ts = (body['timestamp'] as int?) ?? 0;

    final items = list
        .whereType<Map<String, dynamic>>()
        .map(Token.fromJson)
        .toList(growable: false);

    return Paginated<Token>(data: items, timestamp: ts);
  }
}
