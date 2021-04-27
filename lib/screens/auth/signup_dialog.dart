import 'package:app/bloc/authentication/authentication_bloc.dart';
import 'package:app/bloc/singup/sign_up_cubit.dart';
import 'package:app/repository/repository.dart';
import 'package:app/screens/auth/sign_up_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpDialog extends StatelessWidget {
  const SignUpDialog({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) async {
        switch (state.status) {
          case AuthenticationStatus.authenticated:
            Navigator.of(context).pop();
            break;
          case AuthenticationStatus.unauthenticated:
            break;
          default:
            break;
        }
      },
      child: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Colors.grey[50]),
          // padding: EdgeInsets.all(24.0),
          child: BlocProvider<SignUpCubit>(
            create: (_) => SignUpCubit(
              AuthenticationRepository.instance,
            ),
            child: SingleChildScrollView(
              child: Container(
                // margin: EdgeInsets.only(top: 32, left: 16, right: 16),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: SignUpForm(),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
