import 'package:fortuneapp/core/data/user_repository.dart';
import 'package:fortuneapp/core/models/user_model.dart';

// Test'lerde UserRepository yerine kullanılan in-memory fake.
class FakeUserRepository implements UserRepository {
  FakeUserRepository({UserModel? initial}) : _user = initial;
  UserModel? _user;
  int updateCallCount = 0;

  @override
  Future<UserModel?> fetchCurrent() async => _user;

  @override
  Future<void> update(UserModel user) async {
    _user = user;
    updateCallCount++;
  }
}
