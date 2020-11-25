import 'package:flutter/material.dart';

import '../../home_page.dart';
import './login_controller.dart';
import './login_repository.dart';

class LoginPageMVC extends StatefulWidget {
  @override
  _LoginPageMVCState createState() => _LoginPageMVCState();
}

class _LoginPageMVCState extends State<LoginPageMVC> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  LoginController loginController;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loginController = LoginController(LoginRepository());
  }

  @override
  void dispose() {
    super.dispose();
  }

  _loginSuccess() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) {
          return HomePage();
        },
      ),
    );
  }

  _loginError() {
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
        key: loginController.formKey,
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
                onSaved: loginController.userEmail,
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
                onSaved: loginController.userPassword,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Campo não pode ser nulo';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10.0),
              RaisedButton(
                padding: const EdgeInsets.symmetric(horizontal: 80.0),
                textColor: Colors.white,
                color: Colors.blue,
                child: Text('Entrar'),
                onPressed: isLoading
                    ? null
                    : () async {
                        setState(() {
                          isLoading = true;
                        });

                        if (await loginController.login()) {
                          _loginSuccess();
                        } else {
                          _loginError();
                        }

                        setState(() {
                          isLoading = false;
                        });
                      },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
