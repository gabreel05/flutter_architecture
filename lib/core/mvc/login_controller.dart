import 'package:flutter/material.dart';

import './login_repository.dart';
import './user_model.dart';

class LoginController {
  LoginController(this.loginRepository);

  final LoginRepository loginRepository;

  final formKey = GlobalKey<FormState>();

  UserModel user = UserModel();

  userEmail(String value) => user.email = value;
  userPassword(String value) => user.password = value;

  Future<bool> login() async {
    if (!formKey.currentState.validate()) {
      return false;
    }
    formKey.currentState.save();

    try {
      return await loginRepository.login(user);
    } catch (e) {
      return false;
    }
  }
}
