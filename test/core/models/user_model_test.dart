import 'package:flutter_test/flutter_test.dart';
import 'package:fortuneapp/core/models/user_model.dart';

void main() {
  group('UserModel.fromJson geriye dönük uyum', () {
    test('eski relationShipState anahtarını okur', () {
      final json = {
        'name': 'Ada',
        'birthDate': '1990-01-01T00:00:00.000',
        'location': 'İstanbul',
        'zodiacSign': 'capricorn',
        'gender': 'man',
        'workState': 'employed',
        'relationShipState': 'married', // eski yazım
        'coin': 10,
      };

      final user = UserModel.fromJson(json);

      expect(user.relationshipState, 'married');
    });

    test('coin eksikse 3 varsayılır', () {
      final json = {
        'name': 'Ada',
        'birthDate': '1990-01-01T00:00:00.000',
        'location': '',
        'zodiacSign': '',
        'gender': '',
        'workState': '',
        'relationshipState': 'single',
      };

      final user = UserModel.fromJson(json);

      expect(user.coin, 3);
    });

    test('eski Türkçe cinsiyet değeri .name biçimine normalize edilir', () {
      final json = {
        'name': 'Ada',
        'birthDate': '1990-01-01T00:00:00.000',
        'location': '',
        'zodiacSign': '',
        'gender': 'Erkek', // eski displayName
        'workState': '',
        'relationshipState': 'single',
      };

      final user = UserModel.fromJson(json);

      expect(user.gender, 'man');
    });
  });
}
