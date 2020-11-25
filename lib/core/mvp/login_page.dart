import 'package:flutter/material.dart';

import '../../home_page.dart';
import './login_presenter.dart';
import './login_repository.dart';

class LoginPageMVP extends StatefulWidget {
  @override
  _LoginPageMVPState createState() => _LoginPageMVPState();
}

class _LoginPageMVPState extends State<LoginPageMVP>
    implements LoginPageContract {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  LoginPresenter presenter;

  @override
  void initState() {
    super.initState();
    presenter = LoginPresenter(this, loginRepository: LoginRepository());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
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

  @override
  void loginError() {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text('Login Error'),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  void loginManager() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Form(
        key: presenter.formKey,
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
                onSaved: presenter.userEmail,
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
                onSaved: presenter.userPassword,
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
                onPressed: presenter.isLoading ? null : presenter.login,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
