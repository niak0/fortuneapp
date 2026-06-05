// El falı ekranının state'i — çekilen fotoğrafın yolu.
class FortuneHandState {
  final String? photoPath;

  const FortuneHandState({this.photoPath});

  bool get hasPhoto => photoPath != null;

  FortuneHandState copyWith({String? photoPath}) =>
      FortuneHandState(photoPath: photoPath ?? this.photoPath);
}
