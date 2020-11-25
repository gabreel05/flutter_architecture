import 'package:flutter/material.dart';

import 'login_repository.dart';
import 'user_model.dart';

abstract class LoginPageContract {
  void loginSuccess();
  void loginError();
  void loginManager();
}

class LoginPresenter {
  LoginPresenter(this.loginPageContract, {this.loginRepository});

  final LoginRepository loginRepository;
  final LoginPageContract loginPageContract;
  bool isLoading = false;

  final formKey = GlobalKey<FormState>();

  UserModel user = UserModel();

  userEmail(String value) => user.email = value;
  userPassword(String value) => user.password = value;

  login() async {
    bool isLogin;

    isLoading = true;
    loginPageContract.loginManager();

    if (!formKey.currentState.validate()) {
      isLogin = false;
    } else {
      formKey.currentState.save();

      try {
        isLogin = await loginRepository.login(user);
      } catch (e) {
        isLogin = false;
      }
    }

    isLoading = false;
    loginPageContract.loginManager();

    if (isLogin) {
      loginPageContract.loginSuccess();
    } else {
      loginPageContract.loginError();
    }
  }
}
