import 'package:app/bloc/authentication/authentication_bloc.dart';
import 'package:app/bloc/catalog/catalog_bloc.dart';
import 'package:app/constant.dart' show languages;
import 'package:app/hilia_app.dart';
import 'package:app/repository/repository.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:app/simple_bloc_observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/graphql/graphql.dart';

import 'models/models.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final AuthenticationBloc _authenticationBloc = AuthenticationBloc(
      authenticationRepository: AuthenticationRepository.instance);
  final CatalogCubit _catalogCubit =
      CatalogCubit(catalogRepository: CatalogRepository.instance);

  @override
  void initState() {
    BaseQuery.getLang =
        () => "${context.locale.languageCode}_${context.locale.countryCode}";
    _catalogCubit.catalogStarted();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        try {
          _catalogCubit.addNotification(UserNotification.fromJson({
            "title": message["notification"]["title"],
            "body": message["notification"]["body"],
            "data": message.containsKey("data") ? message["data"] : null,
          }));
        } catch (e) {
          print(e);
        }
        _catalogCubit.addNotification(UserNotification.fromJson({
          "title": message["notification"]["title"],
          "body": message["notification"]["body"],
          "data": message.containsKey("data") ? message["data"] : null,
        }));
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        _catalogCubit.addNotification(UserNotification.fromJson({
          "title": message["notification"]["title"],
          "body": message["notification"]["body"],
          "data": message.containsKey("data") ? message["data"] : null,
        }));
        // _navigateToItemDetail(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        _catalogCubit.addNotification(UserNotification.fromJson({
          "title": message["notification"]["title"],
          "body": message["notification"]["body"],
          "data": message.containsKey("data") ? message["data"] : null,
        }));
        // _navigateToItemDetail(message);
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: true, badge: true, alert: true, provisional: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _authenticationBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(
          create: (_) => _authenticationBloc,
        ),
        BlocProvider<CatalogCubit>(
          create: (_) => _catalogCubit,
        ),
      ],
      child: HiliaApp(),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = SimpleBlocObserver();

  runApp(
    EasyLocalization(
      supportedLocales: languages.map((e) => Locale(e[1], e[2])).toList(),
      path: 'assets/translations',
      useOnlyLangCode: true,
      startLocale: Locale(languages.first[1], languages.first[2]),
      fallbackLocale: Locale(languages.first[1], languages.first[2]),
      child: App(),
    ),
  );
}
