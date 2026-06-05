import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/user_model.dart';
import 'firestore_user_repository.dart';

part 'user_repository.g.dart';

// Kullanıcı veri erişimi için abstract interface — testte override edilebilir.
abstract class UserRepository {
  Future<UserModel?> fetchCurrent();

  // Profil varsa döner; yoksa (yeni anon kullanıcı) [createDefault] ile
  // oluşturup Firestore'a yazar. Aktif kullanıcı yoksa null döner.
  Future<UserModel?> fetchOrCreate(UserModel Function() createDefault);

  Future<void> update(UserModel user);
}

// UserRepository DI provider'ı (production = FirestoreUserRepository).
@Riverpod(keepAlive: true)
UserRepository userRepository(Ref ref) => FirestoreUserRepository();
