import '../../enums/fortune_topic.dart';

// Kahve falı ekranının state'i — 3 foto + seçili konu.
class FortuneCoffeeState {
  final List<String> photos;
  final FortuneTopic? selectedFortuneTopic;

  const FortuneCoffeeState({
    required this.photos,
    required this.selectedFortuneTopic,
  });

  factory FortuneCoffeeState.initial() => const FortuneCoffeeState(
        photos: ['', '', ''],
        selectedFortuneTopic: null,
      );

  bool get isValid =>
      !photos.any((p) => p.isEmpty) && selectedFortuneTopic != null;

  FortuneCoffeeState copyWith({
    List<String>? photos,
    FortuneTopic? selectedFortuneTopic,
    bool clearTopic = false,
  }) =>
      FortuneCoffeeState(
        photos: photos ?? this.photos,
        selectedFortuneTopic: clearTopic
            ? null
            : (selectedFortuneTopic ?? this.selectedFortuneTopic),
      );
}
