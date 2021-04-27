import 'package:app/bloc/login/login_cubit.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:easy_localization/easy_localization.dart';

import 'signup_dialog.dart';

class LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          Fluttertoast.showToast(
              msg: "authentication_failure".tr(),
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
            _EmailInput(),
            const SizedBox(height: 8.0),
            _PasswordInput(),
            const SizedBox(height: 8.0),
            _LoginButton(),
            // const SizedBox(height: 8.0),
            // _GoogleLoginButton(),
            const SizedBox(height: 4.0),
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
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextField(
          key: const Key('loginForm_emailInput_textField'),
          onChanged: (email) => context.bloc<LoginCubit>().loginChanged(email),
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'email'.tr(),
            helperText: '',
            // errorText: state.email.invalid ? 'invalid email' : null,
          ),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
          key: const Key('loginForm_passwordInput_textField'),
          onChanged: (password) =>
              context.bloc<LoginCubit>().passwordChanged(password),
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'password'.tr(),
            helperText: '',
            // errorText: state.password.invalid ? 'invalid password' : null,
          ),
        );
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : RaisedButton(
                key: const Key('loginForm_continue_raisedButton'),
                child: AutoSizeText('login'.tr()),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                color: const Color(0xFFFFD600),
                onPressed: state.status.isValidated
                    ? () async {
                        context
                            .bloc<LoginCubit>()
                            .tokenLoaded(await _firebaseMessaging.getToken());
                        context.bloc<LoginCubit>().logIn();
                      }
                    : null,
              );
      },
    );
  }
}

// class _GoogleLoginButton extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     return RaisedButton.icon(
//       key: const Key('loginForm_googleLogin_raisedButton'),
//       label: const AutoSizeText(
//         'SIGN IN WITH GOOGLE',
//         style: TextStyle(color: Colors.white),
//       ),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
//       icon: const Icon(FontAwesomeIcons.google, color: Colors.white),
//       color: theme.accentColor,
//       onPressed: () => context.bloc<LoginCubit>().logInWithGoogle(),
//     );
//   }
// }

class _SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        final theme = Theme.of(context);
        return state.status.isSubmissionInProgress
            ? const SizedBox()
            : FlatButton(
                key: const Key('loginForm_createAccount_flatButton'),
                child: AutoSizeText(
                  'create_account'.tr(),
                  style: TextStyle(color: theme.primaryColor),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  showDialog(
                      context: context,
                      child: Dialog(
                        shape: BeveledRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: SignUpDialog(),
                      ));
                }
                // Navigator.of(context).push<void>(SignUpPage.route()),
                );
      },
    );
  }
}
