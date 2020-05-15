import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:gerenciadorlojavirtual/validators/login_validator.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc extends BlocBase with LoginValidator {
  final _emailController = BehaviorSubject<String>();
  final _passController = BehaviorSubject<String>();

  Stream<String> get outEmail =>
      _emailController.stream.transform(validateEmail);
  Stream<String> get ouPassword =>
      _passController.stream.transform(validateSenha);

  Stream<bool> get outSubmitValid =>
      Observable.combineLatest2(outEmail, ouPassword, (email, pass) => true);

  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePass => _passController.sink.add;
  @override
  void dispose() {
    _emailController.close();
    _passController.close();
  }
}
