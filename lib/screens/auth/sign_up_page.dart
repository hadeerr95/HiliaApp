import 'package:app/bloc/singup/sign_up_cubit.dart';
import 'package:app/repository/authentication_repository.dart';
import 'package:app/screens/auth/sign_up_form.dart';
import 'package:app/screens/components/hilia_scaffold.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/app_properties.dart';
import 'package:easy_localization/easy_localization.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const SignUpPage());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.amber,
      decoration: BoxDecoration(gradient: backgroundColor),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: HiliaAppBar(
          title: AutoSizeText(
            'create_account'.tr(),
            style: TextStyle(color: darkGrey),
          ),
        ),
        body: BlocProvider<SignUpCubit>(
          create: (_) => SignUpCubit(
            AuthenticationRepository.instance,
          ),
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.only(top: 32, left: 16, right: 16),
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
    );
    // return Scaffold(
    //   appBar: AppBar(title: const AutoSizeText('Sign Up')),
    //   body: Padding(
    //     padding: const EdgeInsets.all(8.0),
    //     child: BlocProvider<SignUpCubit>(
    //       create: (_) => SignUpCubit(
    //         context.repository<AuthenticationRepository>(),
    //       ),
    //       child: SignUpForm(),
    //     ),
    //   ),
    // );
  }
}
