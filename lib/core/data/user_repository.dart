import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/user_model.dart';
import '../network/mock_service.dart';

part 'user_repository.g.dart';

// Kullanıcı veri erişimi için abstract interface — testte override edilebilir.
abstract class UserRepository {
  Future<UserModel?> fetchCurrent();
  Future<void> update(UserModel user);
}

// MockService üzerinden çalışan UserRepository implementasyonu.
class MockUserRepository implements UserRepository {
  @override
  Future<UserModel?> fetchCurrent() async {
    await MockService.initializeData();
    return MockService.mockUser;
  }

  @override
  Future<void> update(UserModel user) async {
    await MockService.updateUserProfile(user.toJson());
  }
}

// UserRepository DI provider'ı.
@Riverpod(keepAlive: true)
UserRepository userRepository(Ref ref) => MockUserRepository();
