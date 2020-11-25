import 'dart:async';

import './login_repository.dart';
import './user_model.dart';

class LoginViewModel {
  LoginViewModel(this.loginRepository);

  final LoginRepository loginRepository;

  final _isLoading$ = StreamController<bool>();
  final _isLogin$ = StreamController<UserModel>();

  Sink<bool> get isLoadingIn => _isLoading$.sink;
  Sink<UserModel> get isLoginIn => _isLogin$.sink;

  Stream<bool> get isLoadingOut => _isLoading$.stream;
  Stream<bool> get isLoginOut => _isLogin$.stream.asyncMap(login);

  Future<bool> login(UserModel user) async {
    bool isLogin;

    isLoadingIn.add(true);

    try {
      isLogin = await loginRepository.login(user);
    } catch (e) {
      isLogin = false;
    }

    isLoadingIn.add(false);

    return isLogin;
  }

  dispose() {
    _isLoading$.close();
    _isLogin$.close();
  }
}
