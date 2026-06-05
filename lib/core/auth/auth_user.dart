// Firebase User'ı saran küçük domain modeli (repository sınırı için).
class AuthUser {
  final String uid;
  final String? displayName;
  final String? email;
  final bool isAnonymous;
  final List<String> providerIds;

  const AuthUser({
    required this.uid,
    required this.isAnonymous,
    this.displayName,
    this.email,
    this.providerIds = const [],
  });
}
