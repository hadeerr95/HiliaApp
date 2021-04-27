import 'dart:async';

import 'package:app/graphql/graphql.dart';
import 'package:app/models/models.dart';
import 'package:meta/meta.dart';

import 'base_repository.dart';

/// Thrown if during the sign up process if a failure occurs.
class SignUpFailure implements Exception {}

/// Thrown during the login process if a failure occurs.
class LogInWithEmailAndPasswordFailure implements Exception {}

/// Thrown during the sign in with google process if a failure occurs.
class LogInWithGoogleFailure implements Exception {}

/// Thrown during the logout process if a failure occurs.
class LogOutFailure implements Exception {}

/// {@template authentication_repository}
/// Repository which manages user authentication.
/// {@endtemplate}
class AuthenticationRepository extends BaseRepository {
  static AuthenticationRepository _instance;

  static AuthenticationRepository get instance {
    if (_instance != null) {
      return _instance;
    } else {
      _instance = AuthenticationRepository();
      return _instance;
    }
  }

  /// Stream of [User] which will emit the current user when
  /// the authentication state changes.
  ///
  /// Emits [User.empty] if the user is not authenticated.
  Stream<User> get user {
    return AuthUtil.authStateChanges().map((User user) {
      // print(user?.toJson);
      return user;
    });
  }

  /// Creates a new user with the provided [email] and [password].
  ///
  /// Throws a [SignUpFailure] if an exception occurs.
  Future<void> signUp({
    @required String login,
    @required String name,
    @required String password,
    @required String confirmPassword,
    @required String token,
  }) async {
    assert(login != null &&
        name != null &&
        password != null &&
        confirmPassword != null &&
        token != null);
    try {
      await AuthUtil.signUp(
        login: login,
        name: name,
        password: password,
        confirmPassword: confirmPassword,
        token: token,
      );
    } on Exception {
      throw SignUpFailure();
    }
  }

  /// Signs in with the provided [email] and [password].
  ///
  /// Throws a [LogInWithEmailAndPasswordFailure] if an exception occurs.
  Future<void> logIn({
    @required String email,
    @required String password,
    @required String token,
  }) async {
    assert(email != null && password != null && token != null);
    try {
      await AuthUtil.signIn(
        login: email,
        password: password,
        token: token,
      );
    } on Exception {
      throw LogInWithEmailAndPasswordFailure();
    }
  }

  /// Signs out the current user which will emit
  /// [User.empty] from the [user] Stream.
  ///
  /// Throws a [LogOutFailure] if an exception occurs.
  Future<void> logOut() async {
    try {
      await Future.wait([AuthUtil.signOut()]);
    } on Exception {
      throw LogOutFailure();
    }
  }

  Future<void> refreshUser() async {
    await AuthUtil.loadUser();
  }

  // Stream<Map> orderStatus() async* {
  //   OrderStatusQuery query = OrderStatusQuery(orderStatusFragment);

  //   while (true) {
  //     try {
  //       Map status =
  //           (await fetchFileFromInternet(query))['viewer']['orderStatus'];
  //       yield status;
  //     } catch (e) {
  //       print(e);
  //     } finally {
  //       await Future.delayed(Duration(seconds: 2));
  //     }
  //   }
  // }
}
