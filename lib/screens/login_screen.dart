import 'package:flutter/material.dart';
import 'package:gerenciadorlojavirtual/blocs/login_bloc.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginBloc = LoginBloc();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Center(
        heightFactor: 1.5,
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 18),
            child: Column(
              children: <Widget>[
                Icon(
                  Icons.lightbulb_outline,
                  color: Colors.purple,
                  size: 150,
                ),
                Form(
                  child: Column(
                    children: <Widget>[
                      FormFild(
                        Icons.email,
                        'Email',
                        TextInputType.emailAddress,
                        false,
                        _loginBloc.outEmail,
                        _loginBloc.changeEmail,
                      ),
                      SizedBox(height: 10),
                      FormFild(
                        Icons.lock_outline,
                        'Senha',
                        TextInputType.visiblePassword,
                        true,
                        _loginBloc.ouPassword,
                        _loginBloc.changePass,
                      ),
                      SizedBox(height: 20),
                      StreamBuilder(
                        stream: _loginBloc.outSubmitValid,
                        builder: (context, snapshot) {
                          return RaisedButton(
                            disabledColor: Colors.grey,
                            padding: EdgeInsets.symmetric(horizontal: 100),
                            child: Text(
                              'Entrar',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 17),
                            ),
                            color: Colors.purple,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            onPressed: snapshot.hasData ? () {} : null,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FormFild extends StatelessWidget {
  final IconData icon;
  final String hint;
  final TextInputType type;
  final bool obscure;
  final Stream<String> stream;
  final Function(String) onChanged;
  FormFild(this.icon, this.hint, this.type, this.obscure, this.stream,
      this.onChanged);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
        stream: stream,
        builder: (context, snapshot) {
          return TextField(
            onChanged: onChanged,
            obscureText: obscure,
            keyboardType: type,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.white,
                ),
              ),
              icon: Icon(
                icon,
                color: Colors.white,
              ),
              hintText: hint,
              hintStyle: TextStyle(color: Colors.white, fontSize: 14),
              errorText: snapshot.hasError ? snapshot.error : null,
            ),
          );
        });
  }
}
