import 'package:app/bloc/login/login_cubit.dart';
import 'package:app/repository/authentication_repository.dart';
import 'package:app/screens/components/hilia_scaffold.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/app_properties.dart';
import 'package:easy_localization/easy_localization.dart';

import 'login_form.dart';

class LoginPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => LoginPage());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: backgroundColor),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: HiliaAppBar(
          title: AutoSizeText(
            'login'.tr(),
            style: TextStyle(color: darkGrey),
          ),
        ),
        body: BlocProvider(
          create: (_) => LoginCubit(
            AuthenticationRepository.instance,
          ),
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.only(top: 32, left: 16, right: 16),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: LoginForm(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
