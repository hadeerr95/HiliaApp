import 'package:app/app_properties.dart';
import 'package:app/bloc/authentication/authentication_bloc.dart';
import 'package:app/bloc/catalog/catalog_bloc.dart';
import 'package:app/constant.dart' show languages;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangeLanguagePage extends StatefulWidget {
  @override
  _ChangeCountryPageState createState() => _ChangeCountryPageState();
}

class _ChangeCountryPageState extends State<ChangeLanguagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        brightness: Brightness.light,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: Colors.transparent,
        title: AutoSizeText(
          'settings'.tr(),
          style: TextStyle(color: darkGrey),
        ),
        elevation: 0,
      ),
      body: SafeArea(
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.only(top: 24.0, left: 24.0, right: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: AutoSizeText(
                  'language'.tr(args: ['A / ع']),
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0),
                ),
              ),
              Flexible(
                child: ListView(
                  children: languages
                      .map((l) => ListTile(
                            onTap: () async {
                              if (l[1] != context.locale.languageCode) {
                                context.locale = Locale(l[1], l[2]);
                                await Future.delayed(
                                    Duration(milliseconds: 500));
                                BlocProvider.of<CatalogCubit>(context)
                                    .reloadCatalog();
                                BlocProvider.of<AuthenticationBloc>(context)
                                    .add(AuthenticationReload());
                              }
                            },
                            title: AutoSizeText(
                              l[0],
                              style: TextStyle(fontSize: 14),
                            ),
                            trailing: Locale(l[1], l[2]).toString() ==
                                    context.locale.toString()
                                ? Icon(
                                    Icons.check_circle,
                                    color: yellow,
                                    size: 16,
                                  )
                                : SizedBox(),
                          ))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
