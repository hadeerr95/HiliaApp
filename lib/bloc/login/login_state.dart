part of 'login_cubit.dart';

class LoginState extends Equatable {
  const LoginState({
    this.email = const RequiredField.pure(),
    this.password = const RequiredField.pure(),
    this.token,
    this.status = FormzStatus.pure,
  });

  final RequiredField email;
  final RequiredField password;
  final String token;
  final FormzStatus status;

  @override
  List<Object> get props => [email, password, token, status];

  LoginState copyWith({
    RequiredField email,
    RequiredField password,
    String token,
    FormzStatus status,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      token: token ?? this.token,
      status: status ?? this.status,
    );
  }
}
