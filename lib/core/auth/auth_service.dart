import 'package:fortuneapp/core/models/user_model.dart';

abstract class IAuthService {
  Future<UserModel?> login();
  Future<void> logout();
}
