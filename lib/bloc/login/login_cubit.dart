import 'package:app/models/login.dart';
import 'package:app/repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._authenticationRepository)
      : assert(_authenticationRepository != null),
        super(const LoginState());

  final AuthenticationRepository _authenticationRepository;

  void loginChanged(String value) {
    final email = RequiredField.dirty(value);
    emit(state.copyWith(
      email: email,
      status: Formz.validate([email, state.password]),
    ));
  }

  void passwordChanged(String value) {
    final password = RequiredField.dirty(value);
    emit(state.copyWith(
      password: password,
      status: Formz.validate([state.email, password]),
    ));
  }

  void tokenLoaded(String token) {
    emit(state.copyWith(
      token: token,
    ));
  }

  Future<void> logIn() async {
    if (!state.status.isValidated) return;
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      await _authenticationRepository.logIn(
        email: state.email.value,
        password: state.password.value,
        token: state.token,
      );
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } on Exception {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }

  // Future<void> logInWithGoogle() async {
  //   emit(state.copyWith(status: FormzStatus.submissionInProgress));
  //   try {
  //     await _authenticationRepository.logInWithGoogle();
  //     emit(state.copyWith(status: FormzStatus.submissionSuccess));
  //   } on Exception {
  //     emit(state.copyWith(status: FormzStatus.submissionFailure));
  //   } on NoSuchMethodError {
  //     emit(state.copyWith(status: FormzStatus.pure));
  //   }
  // }
}
