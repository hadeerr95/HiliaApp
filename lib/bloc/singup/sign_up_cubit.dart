import 'package:app/models/login.dart';
import 'package:app/repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit(this._authenticationRepository)
      : assert(_authenticationRepository != null),
        super(const SignUpState());

  final AuthenticationRepository _authenticationRepository;

  void emailChanged(String value) {
    final login = Login.dirty(value);
    emit(state.copyWith(
      login: login,
      status: Formz.validate(
          [login, state.name, state.password, state.confirmPassword]),
    ));
  }

  void nameChanged(String value) {
    final name = RequiredField.dirty(value);
    emit(state.copyWith(
      name: name,
      status: Formz.validate(
          [state.login, name, state.password, state.confirmPassword]),
    ));
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);
    emit(state.copyWith(
      password: password,
      status: Formz.validate([
        state.login,
        state.name,
        password,
        state.confirmPassword,
        ConfirmPassword.dirty(password == state.confirmPassword),
      ]),
    ));
  }

  void confirmPasswordChanged(String value) {
    final confirmPassword = Password.dirty(value);
    emit(state.copyWith(
      confirmPassword: confirmPassword,
      status: Formz.validate([
        state.login,
        state.name,
        state.password,
        confirmPassword,
        ConfirmPassword.dirty(state.password == confirmPassword),
      ]),
    ));
  }

  void tokenLoaded(String token) {
    emit(state.copyWith(
      token: token,
    ));
  }

  Future<void> signUpFormSubmitted() async {
    if (!state.status.isValidated) return;
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      await _authenticationRepository.signUp(
        login: state.login.value,
        name: state.name.value,
        password: state.password.value,
        confirmPassword: state.confirmPassword.value,
        token: state.token,
      );
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } on Exception {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }
}
