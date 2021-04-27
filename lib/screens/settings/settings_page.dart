import 'package:app/app_properties.dart';
import 'package:app/bloc/authentication/authentication_bloc.dart';
import 'package:app/custom_background.dart';
import 'package:app/screens/settings/change_password_page.dart';
import 'package:app/screens/settings/notifications_settings_page.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import 'change_language_page.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: MainBackground(),
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          brightness: Brightness.light,
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: AutoSizeText(
            'settings'.tr(),
            style: TextStyle(color: darkGrey),
          ),
        ),
        body: SafeArea(
          bottom: true,
          child: LayoutBuilder(
              builder: (builder, constraints) => SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints:
                          BoxConstraints(minHeight: constraints.maxHeight),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 24.0, left: 24.0, right: 24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: AutoSizeText(
                                'general'.tr(),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0),
                              ),
                            ),
                            ListTile(
                              title:
                                  AutoSizeText('language'.tr(args: ['A / ع'])),
                              leading: Image.asset('assets/icons/language.png'),
                              onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (_) => ChangeLanguagePage())),
                            ),
                            // ListTile(
                            //   title: AutoSizeText('Change Country'),
                            //   leading: Image.asset('assets/icons/country.png'),
                            //   onTap: () => Navigator.of(context).push(
                            //       MaterialPageRoute(
                            //           builder: (_) => ChangeCountryPage())),
                            // ),
                            ListTile(
                              title: AutoSizeText('notifications'.tr()),
                              leading:
                                  Image.asset('assets/icons/notifications.png'),
                              onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          NotificationSettingsPage())),
                            ),
                            // ListTile(
                            //   title: AutoSizeText('legal_about'.tr()),
                            //   leading: Image.asset('assets/icons/legal.png'),
                            //   onTap: () => Navigator.of(context).push(
                            //       MaterialPageRoute(
                            //           builder: (_) => LegalAboutPage())),
                            // ),
                            ListTile(
                              title: AutoSizeText('about_us'.tr()),
                              leading: Image.asset('assets/icons/about_us.png'),
                              onTap: () {},
                            ),
                            BlocBuilder<AuthenticationBloc,
                                AuthenticationState>(builder: (contaxt, state) {
                              if (state.status ==
                                  AuthenticationStatus.authenticated) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8.0, bottom: 8.0),
                                      child: AutoSizeText(
                                        'account'.tr(),
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.0),
                                      ),
                                    ),
                                    ListTile(
                                      title:
                                          AutoSizeText('change_password'.tr()),
                                      leading: Image.asset(
                                          'assets/icons/change_pass.png'),
                                      onTap: () => Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  ChangePasswordPage())),
                                    ),
                                    ListTile(
                                      title: AutoSizeText('sign_out'.tr()),
                                      leading: Image.asset(
                                          'assets/icons/sign_out.png'),
                                      onTap: () => BlocProvider.of<
                                              AuthenticationBloc>(context)
                                          .add(AuthenticationLogoutRequested()),
                                    ),
                                  ],
                                );
                              }
                              return SizedBox();
                            }),
                          ],
                        ),
                      ),
                    ),
                  )),
        ),
      ),
    );
  }
}
