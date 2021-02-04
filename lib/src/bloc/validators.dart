import 'dart:async';

class Validators {
  // final validarEmail =
  //     StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
  //   Pattern pattern =
  //       r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  //   RegExp regExp = new RegExp(pattern);

  //   if (regExp.hasMatch(email)) {
  //     sink.add(email);
  //   } else {
  //     sink.addError('Email no es correcto');
  //   }
  // });

  final validarPassword = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
    if (password.length >= 0) {
      sink.add(password);
    } else {
      sink.addError('El campo passWord no debe estar vacio');
    }
  });

  final validarname =
      StreamTransformer<String, String>.fromHandlers(handleData: (name, sink) {
    if (name.length >= 0) {
      sink.add(name);
    } else {
      sink.addError('Este campo no debe estar vacio');
    }
  });

  final validarsurname = StreamTransformer<String, String>.fromHandlers(
      handleData: (surname, sink) {
    if (surname.length >= 0) {
      sink.add(surname);
    } else {
      sink.addError('Este campo no debe estar vacio');
    }
  });

  final validarcel =
      StreamTransformer<String, String>.fromHandlers(handleData: (cel, sink) {
    Pattern pattern = '^(\[[0-9]{9}\)';
    RegExp regExp = new RegExp(pattern);

    if (regExp.hasMatch(cel)) {
      sink.add(cel);
    } else {
      sink.addError('Solo numeros');
    }
  });

  //-----Update Negocio------------------

  final validarRuc =
      StreamTransformer<String, String>.fromHandlers(handleData: (ruc, sink) {
    Pattern pattern = '^(\[[0-9]{11}\)';
    RegExp regExp = new RegExp(pattern);

    if (regExp.hasMatch(ruc)) {
      sink.add(ruc);
    } else {
      sink.addError('Solo numeros');
    }
  }
  );

  
}
