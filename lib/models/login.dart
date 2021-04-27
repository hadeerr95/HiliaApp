import 'package:formz/formz.dart';

enum EmailValidationError { invalid }

class Login extends FormzInput<String, EmailValidationError> {
  const Login.pure() : super.pure('');
  const Login.dirty([String value = '']) : super.dirty(value);

  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );

  @override
  EmailValidationError validator(String value) {
    // return value.isNotEmpty ? null : EmailValidationError.invalid;
    return _emailRegExp.hasMatch(value) ? null : EmailValidationError.invalid;
  }
}

enum PasswordValidationError { invalid }

class Password extends FormzInput<String, PasswordValidationError> {
  const Password.pure() : super.pure('');
  const Password.dirty([String value = '']) : super.dirty(value);

  // static final _passwordRegExp =
  //     RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');

  @override
  PasswordValidationError validator(String value) {
    // return value.isNotEmpty ? null : PasswordValidationError.invalid;
    return value.length >= 8 ? null : PasswordValidationError.invalid;
  }
}

enum ConfirmPasswordValidationError { invalid }

class ConfirmPassword extends FormzInput<bool, ConfirmPasswordValidationError> {
  const ConfirmPassword.pure() : super.pure(false);
  const ConfirmPassword.dirty([bool value = false]) : super.dirty(value);

  @override
  ConfirmPasswordValidationError validator(bool value) {
    // return value.isNotEmpty ? null : PasswordValidationError.invalid;
    return value ? null : ConfirmPasswordValidationError.invalid;
  }
}

enum RequiredFieldValidationError { invalid }

class RequiredField extends FormzInput<String, RequiredFieldValidationError> {
  const RequiredField.pure() : super.pure('');
  const RequiredField.dirty([String value = '']) : super.dirty(value);

  @override
  RequiredFieldValidationError validator(String value) {
    return value.isNotEmpty ? null : RequiredFieldValidationError.invalid;
  }
}
