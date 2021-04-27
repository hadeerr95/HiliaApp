import 'package:app/bloc/singup/sign_up_cubit.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:formz/formz.dart';
import 'package:easy_localization/easy_localization.dart';

class SignUpForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpCubit, SignUpState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          Fluttertoast.showToast(
              msg: "signup_failure".tr(),
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      },
      child: Align(
        alignment: const Alignment(0, -1 / 3),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/mobile-header.png',
            ),
            const SizedBox(height: 16.0),
            _NameInput(),
            const SizedBox(height: 8.0),
            _EmailInput(),
            const SizedBox(height: 8.0),
            _PasswordInput(),
            const SizedBox(height: 8.0),
            _ConfirmPasswordInput(),
            const SizedBox(height: 8.0),
            _SignUpButton(),
          ],
        ),
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.login != current.login,
      builder: (context, state) {
        return TextField(
          key: const Key('signUpForm_loginInput_textField'),
          onChanged: (email) => context.bloc<SignUpCubit>().emailChanged(email),
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'email'.tr() + '*',
            helperText: '',
            errorText: state.login.invalid ? 'invalid_email'.tr() : null,
          ),
        );
      },
    );
  }
}

class _NameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.name != current.name,
      builder: (context, state) {
        return TextField(
          key: const Key('signUpForm_nameInput_textField'),
          onChanged: (name) => context.bloc<SignUpCubit>().nameChanged(name),
          decoration: InputDecoration(
            labelText: 'name'.tr() + '*',
            helperText: '',
            errorText: state.login.invalid ? 'invalid_name'.tr() : null,
          ),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
          key: const Key('signUpForm_passwordInput_textField'),
          onChanged: (password) =>
              context.bloc<SignUpCubit>().passwordChanged(password),
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'password'.tr() + '*',
            helperText: '',
            errorText: state.password.invalid
                ? 'invalid_password'.tr(namedArgs: {'len': '8'})
                : null,
          ),
        );
      },
    );
  }
}

class _ConfirmPasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) =>
          previous.confirmPassword != current.confirmPassword,
      builder: (context, state) {
        return TextField(
          key: const Key('signUpForm_confirmPasswordInput_textField'),
          onChanged: (password) =>
              context.bloc<SignUpCubit>().confirmPasswordChanged(password),
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'confirm_password'.tr() + '*',
            helperText: '',
            errorText: state.confirmPassword.invalid
                ? 'invalid_password'.tr(namedArgs: {'len': '8'})
                : state.confirmPassword.value != state.password.value
                    ? 'password_does_not_match'.tr()
                    : null,
          ),
        );
      },
    );
  }
}

class _SignUpButton extends StatelessWidget {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : RaisedButton(
                key: const Key('signUpForm_continue_raisedButton'),
                child: AutoSizeText('create_account'.tr()),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                color: Colors.orangeAccent,
                onPressed: state.status.isValidated
                    ? () async {
                        context
                            .bloc<SignUpCubit>()
                            .tokenLoaded(await _firebaseMessaging.getToken());
                        context.bloc<SignUpCubit>().signUpFormSubmitted();
                      }
                    : null,
              );
      },
    );
  }
}
