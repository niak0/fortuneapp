import 'package:fortuneapp/core/data/user_repository.dart';
import 'package:fortuneapp/core/models/user_model.dart';

// Test'lerde UserRepository yerine kullanılan in-memory fake.
class FakeUserRepository implements UserRepository {
  FakeUserRepository({UserModel? initial, this.failOnUpdate = false})
    : _user = initial;
  UserModel? _user;
  int updateCallCount = 0;

  // true ise update() hata fırlatır (rollback senaryosu testi için).
  final bool failOnUpdate;

  @override
  Future<UserModel?> fetchCurrent() async => _user;

  @override
  Future<UserModel?> fetchOrCreate(UserModel Function() createDefault) async {
    _user ??= createDefault();
    return _user;
  }

  @override
  Future<void> update(UserModel user) async {
    if (failOnUpdate) throw Exception('update failed');
    _user = user;
    updateCallCount++;
  }
}
