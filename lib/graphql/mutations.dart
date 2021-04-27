import 'dart:convert';

import 'package:app/models/models.dart';

import 'fragments.dart';

abstract class BaseMutation {
  String get mutation;
  Map<String, dynamic> get variables;

  @override
  String toString() {
    return json.encode({"mutation": mutation, "variables": variables});
  }
}

class LoginMutation extends BaseMutation {
  final Fragment fragment;
  final String login;
  final String password;
  final String db;
  final String token;

  LoginMutation(this.fragment,
      {this.login, this.password, this.db, this.token});

  @override
  String get mutation => '''
  mutation Login(\$login: String!, \$password: String!, \$db: String!, \$token: String) {
    user: login(login: \$login, password: \$password, db: \$db, token: \$token) {
      ...${fragment.name}
    }
  }
  $fragment
  ''';

  @override
  Map<String, dynamic> get variables => {
        "login": login,
        "password": password,
        "db": db,
        "token": token,
      };
}

class ChangePasswordMutation extends BaseMutation {
  final Fragment fragment;
  final String password;

  ChangePasswordMutation(this.fragment, this.password);

  @override
  String get mutation => '''
  mutation UpdateUser(\$password: String!) {
    partner: updateUser(password: \$password) {
      ...${fragment.name}
    }
  }
  $fragment
  ''';

  @override
  Map<String, dynamic> get variables => {'password': password};
}

class SignupMutation extends BaseMutation {
  final Fragment fragment;
  final String name;
  final String login;
  final String password;
  final String confirmPassword;
  final String db;
  final String token;

  SignupMutation(this.fragment,
      {this.name,
      this.password,
      this.login,
      this.confirmPassword,
      this.db,
      this.token});

  @override
  String get mutation => '''
  mutation Signup(\$name: String!, \$login: String!, \$confirmPassword: String!, \$password: String!, \$db: String!, \$token: String, \$fromApp: Boolean) {
    user: signup(name: \$name, login: \$login, password: \$password, confirmPassword: \$confirmPassword, db: \$db, token: \$token, fromApp: \$fromApp) {
      ...${fragment.name}
    }
  }
  $fragment
  ''';

  @override
  Map<String, dynamic> get variables => {
        "name": name,
        "login": login,
        "password": password,
        "confirmPassword": confirmPassword,
        "db": db,
        "token": token,
        "fromApp": true,
      };
}

class CheckoutMutation extends BaseMutation {
  final Fragment fragment;
  final SaleOrder input;
  CheckoutMutation(this.fragment, this.input);

  @override
  String get mutation => '''
  mutation Checkout(\$input: OrderInput!) {
    order: checkout(input: \$input) {
      ...${fragment.name}
    }
  }
  $fragment
  ''';

  @override
  Map<String, dynamic> get variables => {'input': input.toJson};
}

class CreatePartnerMutation extends BaseMutation {
  final Fragment fragment;
  final Partner input;

  CreatePartnerMutation(this.fragment, this.input);

  @override
  String get mutation => '''
  mutation CreatePartner(\$input: PartnerInput!) {
    partner: createPartner(input: \$input) {
      ...${fragment.name}
    }
  }
  $fragment
  ''';

  @override
  Map<String, dynamic> get variables => {'input': input.toJson};
}

class UpdatePartnerMutation extends BaseMutation {
  final Fragment fragment;
  final int id;
  final Partner input;
  UpdatePartnerMutation(this.fragment, this.id, this.input);

  @override
  String get mutation => '''
  mutation UpdatePartner(\$id: Int!, \$input: PartnerInput!) {
    partner: updatePartner(id: \$id, input: \$input) {
      ...${fragment.name}
    }
  }
  $fragment
  ''';

  @override
  Map<String, dynamic> get variables => {'id': id, 'input': input.toJson};
}
