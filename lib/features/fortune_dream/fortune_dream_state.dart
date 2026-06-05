// Rüya tabiri ekranının state'i — yazılan rüya metni.
class FortuneDreamState {
  final String dreamText;

  const FortuneDreamState({this.dreamText = ''});

  bool get isValid => dreamText.trim().isNotEmpty;

  FortuneDreamState copyWith({String? dreamText}) =>
      FortuneDreamState(dreamText: dreamText ?? this.dreamText);
}
