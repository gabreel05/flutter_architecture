import 'package:flutter/material.dart';

import '../../home_page.dart';
import './login_viewmodel.dart';
import './login_repository.dart';
import './user_model.dart';

class LoginPageMVP extends StatefulWidget {
  @override
  _LoginPageMVPState createState() => _LoginPageMVPState();
}

class _LoginPageMVPState extends State<LoginPageMVP> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final user = UserModel();

  LoginViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = LoginViewModel(LoginRepository());
    viewModel.isLoginOut.listen((isLogin) {
      if (isLogin) {
        loginSuccess();
      } else {
        loginError();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    viewModel.dispose();
  }

  void loginSuccess() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) {
          return HomePage();
        },
      ),
    );
  }

  void loginError() {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text('Login Error'),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'E-mail',
                ),
                onSaved: (value) => user.email = value,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Campo não pode ser nulo';
                  } else if (!value.contains('@')) {
                    return 'E-mail inválido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Senha',
                ),
                onSaved: (value) => user.password = value,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Campo não pode ser nulo';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10.0),
              StreamBuilder<bool>(
                stream: viewModel.isLoadingOut,
                initialData: false,
                builder: (context, snapshot) {
                  bool isLoading = snapshot.data;

                  return RaisedButton(
                    padding: const EdgeInsets.symmetric(horizontal: 80.0),
                    textColor: Colors.white,
                    color: Colors.blue,
                    child: Text('Entrar'),
                    onPressed: isLoading
                        ? null
                        : () {
                            if (!_formKey.currentState.validate()) {
                              return;
                            }
                            _formKey.currentState.save();
                            viewModel.isLoginIn.add(user);
                          },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
