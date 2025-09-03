import '../data/coincap_api.dart';
import '../data/models/token.dart';

class TokenRepository {
  TokenRepository(this._api);

  final CoinCapApi _api;

  static const int pageSize = 15;

  Future<List<Token>> fetchPage(int page) async {
    final res = await _api.getAssets(limit: pageSize, offset: page * pageSize);
    return res.data;
  }
}
