part of 'sign_up_cubit.dart';

class SignUpState extends Equatable {
  const SignUpState({
    this.login = const Login.pure(),
    this.name = const RequiredField.pure(),
    this.password = const Password.pure(),
    this.confirmPassword = const Password.pure(),
    this.token,
    this.status = FormzStatus.pure,
  });

  final Login login;
  final RequiredField name;
  final Password password;
  final Password confirmPassword;
  final String token;
  final FormzStatus status;

  @override
  List<Object> get props =>
      [login, name, password, confirmPassword, token, status];

  SignUpState copyWith({
    Login login,
    RequiredField name,
    Password password,
    Password confirmPassword,
    String token,
    FormzStatus status,
  }) {
    return SignUpState(
      login: login ?? this.login,
      name: name ?? this.name,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      token: token ?? this.token,
      status: status ?? this.status,
    );
  }
}
