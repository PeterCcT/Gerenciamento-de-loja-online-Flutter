import 'dart:async';

class LoginValidator {
  final validateEmail = StreamTransformer<String, String>.fromHandlers(
    handleData: (email, sink) {
      if (email.contains('@')) {
        sink.add(email);
      } else {
        sink.add('');
        sink.addError('Insira um email válido');
      }
    },
  );

  final validateSenha =
      StreamTransformer<String, String>.fromHandlers(handleData: (senha, sink) {
    if (senha.length >= 6) {
      sink.add(senha);
    } else {
      sink.add('');
      sink.addError('Insira uma senha válida');
    }
  });
}
