import 'package:toptodo_data/toptodo_data.dart';

typedef Fetcher = Future<TdModel> Function(String id);

class TdModelCache<T extends TdModel> {
  final Map<String, Future<T>> _cache = <String, Future<T>>{};

  Future<T> get(String id, Fetcher fetcher) {
    if (_cache.containsKey(id)) {
      return _cache[id];
    }

    return _cache[id] = fetcher(id);
  }
}
