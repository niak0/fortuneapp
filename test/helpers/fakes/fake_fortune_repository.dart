import 'dart:async';

import 'package:fortuneapp/core/data/fortune_repository.dart';
import 'package:fortuneapp/core/models/fortune_model.dart';
import 'package:fortuneapp/enums/fortune_topic.dart';
import 'package:fortuneapp/enums/gpt_content_type.dart';

// Test'lerde FortuneRepository yerine kullanılan in-memory fake.
class FakeFortuneRepository implements FortuneRepository {
  FakeFortuneRepository({List<FortuneModel>? initial})
    : _items = List.of(initial ?? const []);

  final List<FortuneModel> _items;
  final _controller = StreamController<List<FortuneModel>>.broadcast();

  // Oluşturulan pending falları test'te doğrulamak için kayıt tutar.
  final List<
    ({
      ContentType contentType,
      FortuneTopic? fortuneTopic,
      Map<String, dynamic> request,
    })
  >
  createCalls = [];

  @override
  Stream<List<FortuneModel>> watchAll() {
    Future.microtask(() => _controller.add(List.of(_items)));
    return _controller.stream;
  }

  @override
  Future<List<FortuneModel>> fetchAll() async => List.of(_items);

  @override
  Future<bool> create({
    required ContentType contentType,
    required Map<String, dynamic> request,
    FortuneTopic? fortuneTopic,
  }) async {
    createCalls.add((
      contentType: contentType,
      fortuneTopic: fortuneTopic,
      request: request,
    ));
    _items.insert(
      0,
      FortuneModel(
        id: 'fake-${_items.length}',
        status: 'pending',
        fortuneType: contentType,
        fortuneTopic: fortuneTopic,
        isAccessible: false,
      ),
    );
    _controller.add(List.of(_items));
    return true;
  }

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
