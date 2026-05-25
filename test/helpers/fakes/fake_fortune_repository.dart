import 'dart:async';

import 'package:fortuneapp/core/data/fortune_repository.dart';
import 'package:fortuneapp/core/models/fortune_model.dart';

// Test'lerde FortuneRepository yerine kullanılan in-memory fake.
class FakeFortuneRepository implements FortuneRepository {
  FakeFortuneRepository({List<ContentModel>? initial})
      : _items = List.of(initial ?? const []);

  final List<ContentModel> _items;
  final _controller = StreamController<List<ContentModel>>.broadcast();

  @override
  Stream<List<ContentModel>> watchAll() {
    Future.microtask(() => _controller.add(List.of(_items)));
    return _controller.stream;
  }

  @override
  Future<List<ContentModel>> fetchAll() async => List.of(_items);

  @override
  Future<bool> add({
    required String content,
    required String contentType,
    required String? fortuneTopic,
  }) async =>
      true;

  @override
  Future<void> setAccess(String fortuneId) async {}

  @override
  Future<void> markAsRead(String fortuneId) async {}

  @override
  Future<void> delete(String documentId) async {
    _items.removeWhere((f) => f.id == documentId);
    _controller.add(List.of(_items));
  }
}
