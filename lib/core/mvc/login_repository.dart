import './user_model.dart';

class LoginRepository {
  Future<bool> login(UserModel user) async {
    await Future.delayed(Duration(seconds: 2));
    return user.email == 'gabriel@mountech.com.br' && user.password == '123';
  }
}
