import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
                  Icons.blur_on,
                  color: Colors.purple,
                  size: 150,
                ),
                Form(
                  child: Column(
                    children: <Widget>[
                      FormFild(Icons.email, 'Email', TextInputType.emailAddress,
                          false),
                        SizedBox(height: 10),
                      FormFild(Icons.lock_outline, 'Senha',
                          TextInputType.visiblePassword, true),
                      SizedBox(height: 20),
                      RaisedButton(
                        disabledColor: Colors.grey,
                        padding: EdgeInsets.symmetric(horizontal: 100),
                        child: Text('Entrar',
                            style:
                                TextStyle(color: Colors.white, fontSize: 17)),
                        color: Colors.purple,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        onPressed: null,
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
  FormFild(this.icon, this.hint, this.type, this.obscure);
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscure,
      keyboardType: type,
      style: TextStyle(
        color: Colors.white
      ),
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
      ),
    );
  }
}
