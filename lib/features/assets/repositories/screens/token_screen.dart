import 'package:flutter/material.dart';

import '../../../../core/env.dart';
import '../../presentation/token_repository.dart';
import '../../data/coincap_api.dart';
import '../../data/models/token.dart';
import '../widgets/token_item.dart';

class TokenScreen extends StatefulWidget {
  const TokenScreen({super.key});

  @override
  State<TokenScreen> createState() => _TokenScreenState();
}

class _TokenScreenState extends State<TokenScreen> {
  static const _pageSize = 15;
  static const _preloadThreshold = 200.0;

  late final TokenRepository _repo;
  final ScrollController _controller = ScrollController();

  final List<Token> _items = <Token>[];
  int _page = 0;
  bool _loading = false;
  bool _hasMore = true;
  String? _lastError;

  @override
  void initState() {
    super.initState();
    _repo = TokenRepository(CoinCapApi(apiKey: getCoincapApiKey()));
    _controller.addListener(_onScroll);
    _loadNext();
  }

  @override
  void dispose() {
    _controller.removeListener(_onScroll);
    _controller.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_hasMore || _loading) return;
    final ScrollPosition position = _controller.position;
    final bool isNearBottom =
        position.maxScrollExtent - position.pixels <= _preloadThreshold;
    if (isNearBottom) _loadNext();
  }

  Future<void> _loadNext() async {
    _setLoading(true);
    try {
      final data = await _repo.fetchPage(_page);
      if (!mounted) return;
      setState(() {
        _items.addAll(data);
        _page += 1;
        _hasMore = data.length == _pageSize;
        _lastError = null;
      });
    } catch (e) {
      _lastError = e.toString();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Something went wrong: $_lastError')),
        );
      }
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _refresh() async {
    setState(() {
      _items.clear();
      _page = 0;
      _hasMore = true;
      _lastError = null;
    });
    await _loadNext();
  }

  void _setLoading(bool v) {
    if (!mounted) return;
    setState(() => _loading = v);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refresh,
          child: ListView.builder(
            controller: _controller,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: _items.length + (_loading ? 1 : 0),
            itemBuilder: (context, index) {
              if (index >= _items.length) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              final token = _items[index];
              return TokenItem(token: token, index: index);
            },
          ),
        ),
      ),
    );
  }
}
