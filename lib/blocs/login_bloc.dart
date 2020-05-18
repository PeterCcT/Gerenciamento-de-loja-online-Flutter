import 'dart:async';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gerenciadorlojavirtual/validators/login_validator.dart';
import 'package:rxdart/rxdart.dart';

enum LoginState { IDLE, LOADING, SUCCESS, FAIL }

class LoginBloc extends BlocBase with LoginValidator {
  final _emailController = StreamController<String>.broadcast();
  final _passController = StreamController<String>.broadcast();
  final _stateController = BehaviorSubject<LoginState>();

  Stream<String> get outEmail =>
      _emailController.stream.transform(validateEmail);
  Stream<String> get outPassword =>
      _passController.stream.transform(validateSenha);

  Stream<bool> get outSubmitValid =>
      Observable.combineLatest2(outEmail, outPassword, (email, pass) => true);

  Stream<LoginState> get outState => _stateController.stream;

  StreamSubscription _subscription;

  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePass => _passController.sink.add;

  LoginBloc() {
    _subscription =
        FirebaseAuth.instance.onAuthStateChanged.listen((user) async {
      if (user != null) {
        if (await verifyAdm(user)) {
          _stateController.add(LoginState.SUCCESS);
        } else {
          FirebaseAuth.instance.signOut();
          _stateController.add(LoginState.FAIL);
        }
      } else {
        _stateController.add(LoginState.IDLE);
      }
    });
  }

  @override
  void dispose() {
    _emailController.close();
    _passController.close();
    _stateController.close();
    _subscription.cancel();
  }

  void submit() {
    final email = outEmail.toString();
    final senha = outPassword.toString();
    _stateController.add(LoginState.LOADING);
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: senha)
        .catchError(
      (_) {
        _stateController.add(LoginState.FAIL);
      },
    );
  }

  Future<bool> verifyAdm(FirebaseUser user) async {
    return await Firestore.instance
        .collection('admin')
        .document(user.uid)
        .get()
        .then(
      (doc) {
        if (doc.data != null) {
          return true;
        } else {
          return false;
        }
      },
    ).catchError((error) {
      return false;
    });
  }
}
