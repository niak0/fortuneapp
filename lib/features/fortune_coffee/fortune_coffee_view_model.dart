import 'package:flutter/foundation.dart';
import 'package:fortuneapp/enums/fortune_topic.dart';
import 'package:fortuneapp/enums/relationship_status.dart';
import 'package:fortuneapp/enums/work_status.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/models/user_model.dart';

class FortuneCoffeeViewModel extends ChangeNotifier {
  final List<String> _photos = ["", "", ""];

  FortuneTopic? _selectedFortuneTopic;

  List<String> get photos => List.unmodifiable(_photos);
  FortuneTopic? get selectedFortuneTopic => _selectedFortuneTopic;

  bool handleFortuneCreation() {
    if (_photos.any((photo) => photo.isEmpty) || _selectedFortuneTopic == null) {
      return false;
    }
    return true;
  }

  Future<void> getFortuneAndSaveFirebase(UserModel currentUser) async {
    final newFortuneMessage = "Fal konusu: ${_selectedFortuneTopic!.displayName}, isim: ${currentUser.name}, cinsiyet: ${currentUser.gender}, burç: "
        "${currentUser.age}, ilişki durumu: ${RelationshipStatus.values.firstWhere((r) => r.name == currentUser.relationShipState).turkishName}, "
        "çalışma durumu: ${WorkStatus.values.firstWhere((w) => w.name == currentUser.workState).turkishName}";
  }

  Future<void> pickPhoto(int index) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      _photos[index] = image.path;
      notifyListeners();
    }
  }

  void deletePhoto(int index) {
    _photos[index] = "";
    notifyListeners();
  }

  void selectFortuneTopic(FortuneTopic topic) {
    _selectedFortuneTopic = topic;
    notifyListeners();
  }
}
