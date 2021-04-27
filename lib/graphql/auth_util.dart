import 'dart:async';
import 'dart:convert';

import 'package:app/config.dart';
import 'package:app/models/models.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'fragments.dart';
import 'graphql.dart';
import 'mutations.dart';

class SessionAuthLink extends Link {
  SessionAuthLink()
      : super(
          request: (Operation operation, [NextLink forward]) {
            StreamController<FetchResult> controller;

            Future<void> onListen() async {
              try {
                var sessionId = await AuthUtil.getSessionId();
                operation.setContext(<String, Map<String, String>>{
                  'headers': <String, String>{
                    'Cookie': '''session_id=$sessionId'''
                  },
                });
              } catch (error) {
                controller.addError(error);
              }

              await controller.addStream(forward(operation));
              await controller.close();
            }

            controller = StreamController<FetchResult>(onListen: onListen);

            return controller.stream;
          },
        );
}

class AuthUtil {
  static final _controller = StreamController<User>();

  static Future<String> getSessionId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('sessionId');
  }

  static Future setSessionId(value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString('sessionId', value);
  }

  static Future<bool> removeSessionId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.remove('sessionId');
  }

  static clear() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.clear();
  }

  static Future<void> signIn({
    String login,
    String password,
    String token,
  }) async {
    LoginMutation loginMutation = LoginMutation(
      muteUserFragment,
      login: login,
      password: password,
      db: ServerDB,
      token: token,
    );
    MutationOptions queryOptions = MutationOptions(
        documentNode: gql(loginMutation.mutation),
        variables: loginMutation.variables);
    QueryResult result = await GraphQL.instance.mutate(queryOptions);
    await auth(result);
  }

  static Future<void> signOut() async {
    try {
      CacheManager _cacheManager = GraphQLCacheManager.instance;
      removeSessionId();
      // _cacheManager.emptyCache();
      _cacheManager.removeFile("user");
      loadUser();
    } catch (e) {
      throw e;
    }
  }

  static Future<void> signUp({
    String name,
    String login,
    String password,
    String confirmPassword,
    String token,
  }) async {
    SignupMutation signupMutation = SignupMutation(
      muteUserFragment,
      name: name,
      login: login,
      password: password,
      confirmPassword: confirmPassword,
      db: ServerDB,
      token: token,
    );
    MutationOptions queryOptions = MutationOptions(
        documentNode: gql(signupMutation.mutation),
        variables: signupMutation.variables);

    QueryResult result = await GraphQL.instance.mutate(queryOptions);
    await auth(result);
  }

  static Future<void> loadUser() async {
    try {
      CacheManager _cacheManager = GraphQLCacheManager.instance;
      MeQuery me = MeQuery(userFragment);
      var fileInfo =
          await _cacheManager.downloadFile(me.toString(), key: 'user');
      if ((await fileInfo.file?.exists()) ?? false) {
        _controller.add(await currentUser);
      }
    } catch (e) {}
  }

  static Stream<User> authStateChanges() async* {
    await Future<void>.delayed(const Duration(seconds: 1));
    yield await currentUser;
    await loadUser();
    yield* _controller.stream;
  }

  static Future<void> auth(QueryResult result) async {
    if (!result.hasException) {
      // print(result.data);
      String sessionId = result.data['user']['sessionId'];
      await AuthUtil.setSessionId(sessionId);
      loadUser();
    } else {
      print(result.exception);
      throw result.exception;
    }
  }

  static Future<User> get currentUser async {
    try {
      CacheManager _cacheManager = GraphQLCacheManager.instance;
      MeQuery me = MeQuery(userFragment);
      var file = await _cacheManager.getSingleFile(me.toString(), key: 'user');
      if ((await file?.exists()) ?? false) {
        Map result = json.decode(await file.readAsString());
        Map<String, dynamic> me = result['viewer']['me'];
        // print(me['sessionId']);
        // print(me['saleOrder']);
        await AuthUtil.setSessionId(me['sessionId']);
        return User.fromJson(me);
      } else
        throw Exception("file not exists");
    } catch (e) {
      print(e);
      await signOut();
      return e;
    }
  }

  static void dispose() => _controller.close();
}
