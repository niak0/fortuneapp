import 'package:fortuneapp/enums/fortune_topic.dart';
import 'package:fortuneapp/enums/relationship_status.dart';
import 'package:fortuneapp/enums/work_status.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/models/user_model.dart';
import 'fortune_coffee_state.dart';

export 'fortune_coffee_state.dart';

part 'fortune_coffee_providers.g.dart';

// Kahve falı için fotoğraf seçimi ve konu seçimi Notifier'ı.
@riverpod
class FortuneCoffeeViewModel extends _$FortuneCoffeeViewModel {
  @override
  FortuneCoffeeState build() => FortuneCoffeeState.initial();

  bool handleFortuneCreation() => state.isValid;

  // GPT'ye fal isteği gönderir (şu an mock, prompt oluşturuluyor).
  Future<void> getFortuneAndSaveFirebase(UserModel currentUser) async {
    final topic = state.selectedFortuneTopic;
    if (topic == null) return;
    final _ = 'Fal konusu: ${topic.displayName}, isim: ${currentUser.name}, '
        'cinsiyet: ${currentUser.gender}, burç: ${currentUser.age}, '
        'ilişki durumu: ${RelationshipStatus.values.firstWhere((r) => r.name == currentUser.relationShipState).turkishName}, '
        'çalışma durumu: ${WorkStatus.values.firstWhere((w) => w.name == currentUser.workState).turkishName}';
  }

  // Galeriden foto seçer ve slot'u günceller.
  Future<void> pickPhoto(int index) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    final newPhotos = List<String>.from(state.photos);
    newPhotos[index] = image.path;
    state = state.copyWith(photos: newPhotos);
  }

  // Slot'taki fotoğrafı temizler.
  void deletePhoto(int index) {
    final newPhotos = List<String>.from(state.photos);
    newPhotos[index] = '';
    state = state.copyWith(photos: newPhotos);
  }

  // Fal konusunu seçer.
  void selectFortuneTopic(FortuneTopic topic) {
    state = state.copyWith(selectedFortuneTopic: topic);
  }
}
