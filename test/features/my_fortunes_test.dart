import 'package:flutter_test/flutter_test.dart';
import 'package:fortuneapp/core/data/fortune_repository.dart';
import 'package:fortuneapp/core/models/fortune_model.dart';
import 'package:fortuneapp/enums/gpt_content_type.dart';

import '../helpers/fakes/fake_fortune_repository.dart';
import '../helpers/provider_container_helper.dart';

void main() {
  group('FortuneRepository (override pattern örneği)', () {
    test('FakeFortuneRepository fetchAll() ile veri döner', () async {
      final fortune = FortuneModel(
        id: 'f1',
        createdTime: DateTime.now(),
        fortune: 'test',
        fortuneType: ContentType.coffee,
        isRead: false,
        isAccessible: true,
      );
      final fake = FakeFortuneRepository(initial: [fortune]);
      final container = makeContainer(
        overrides: [fortuneRepositoryProvider.overrideWithValue(fake)],
      );

      final repo = container.read(fortuneRepositoryProvider);
      final all = await repo.fetchAll();

      expect(all.length, 1);
      expect(all.first.id, 'f1');
    });

    test('delete() çağrısı listeden kaldırır', () async {
      final fortune = FortuneModel(
        id: 'f1',
        createdTime: DateTime.now(),
        fortune: 'x',
        fortuneType: ContentType.coffee,
      );
      final container = makeContainer(
        overrides: [
          fortuneRepositoryProvider.overrideWithValue(
            FakeFortuneRepository(initial: [fortune]),
          ),
        ],
      );

      final repo = container.read(fortuneRepositoryProvider);
      await repo.delete('f1');

      expect((await repo.fetchAll()).isEmpty, true);
    });
  });
}
