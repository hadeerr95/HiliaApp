part of 'models.dart';

class User extends Equatable {
  final int id;
  final String login;
  final String lang;
  final String sessionId;
  final AppSetting setting;
  final Partner partner;
  final SaleOrder saleOrder;
  final List<SaleOrder> orders;

  User(
      {this.id,
      this.login,
      this.lang,
      this.sessionId,
      this.setting,
      this.partner,
      this.saleOrder,
      List<SaleOrder> orders})
      : this.orders = orders ?? [];

  factory User.empty() => User();

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json[FieldId],
      login: json['login'],
      lang: json['lang'],
      sessionId: json['sessionId'],
      saleOrder: json['saleOrder'] != null
          ? SaleOrder.fromJson(json['saleOrder'])
          : null,
      setting:
          json['setting'] != null ? AppSetting.fromJson(json['setting']) : null,
      partner:
          json['partner'] != null ? Partner.fromJson(json['partner']) : null,
      orders: ((json["orders"] ?? []) as List)
          .map((e) => SaleOrder.fromJson(e))
          .toList(),
    );
  }

  String get name => partner?.name ?? 'guest';

  Map<String, dynamic> get toJson => {
        FieldId: id,
        'login': login,
      };

  User copyWith(
    User item,
  ) =>
      User(
        id: this.id,
        login: item.login ?? this.login,
        lang: item.lang ?? this.lang,
        sessionId: item.sessionId ?? this.sessionId,
        saleOrder: item.saleOrder ?? this.saleOrder,
        setting: item.setting ?? this.setting,
        partner: item.partner ?? this.partner,
        orders: item.orders ?? this.orders,
      );

  @override
  List<Object> get props =>
      [id, login, lang, sessionId, saleOrder, setting, partner, orders];
}

//-------------------------------------------------------------------
class Partner extends Equatable {
  final int id;
  final String name;
  final ImageProvider imageProvider;
  final String email;
  final String phone;
  final String street;
  final String city;
  final String zip;
  final String type;
  final Country country;
  final CountryState state;
  final Partner parent;
  final List<Partner> contacts;

  Partner(
      {this.id,
      this.name,
      this.imageProvider,
      this.email,
      this.phone,
      this.street,
      this.city,
      this.zip,
      this.type,
      this.country,
      this.state,
      this.parent,
      contacts})
      : contacts = contacts ?? [];

  factory Partner.fromJson(Map<String, dynamic> json) => Partner(
        id: json[FieldId],
        street: json[FieldStreet],
        city: json[FieldCity],
        email: json[FieldEmail],
        phone: json[FieldPhone],
        name: json[FieldName],
        imageProvider: ImageBites.imageFromString(json[FieldImage]),
        type: json[FieldType],
        zip: json[FieldZip],
        country:
            json['country'] != null ? Country.fromJson(json['country']) : null,
        state:
            json['state'] != null ? CountryState.fromJson(json['state']) : null,
        parent:
            json['parent'] != null ? Partner.fromJson(json['parent']) : null,
        contacts: ((json["contacts"] ?? []) as List)
            .map((e) => Partner.fromJson(e))
            .toList(),
      );

  Map<String, dynamic> get toJson => {
        "name": name,
        "street": street,
        // "street2": street2,
        "city": city,
        "zip": zip,
        "email": email,
        "phone": phone,
        "type": type,
        "parentId": parent?.id,
        "countryId": country?.id,
        "stateId": state?.id,
      };

  @override
  List<Object> get props => [
        id,
        name,
        imageProvider,
        email,
        phone,
        street,
        city,
        zip,
        type,
        country,
        state,
        parent,
        contacts,
      ];

  bool get isGood => id != null && email != null && country != null;

  Partner copyWith(
    Partner partner,
  ) =>
      Partner(
        id: this.id,
        imageProvider: partner.imageProvider ?? this.imageProvider,
        street: partner.street ?? this.street,
        city: partner.city ?? this.city,
        email: partner.email ?? this.email,
        name: partner.name ?? this.name,
        phone: partner.phone ?? this.phone,
        type: partner.type ?? this.type,
        zip: partner.zip ?? this.zip,
        state: partner.state ?? this.state,
        country: partner.country ?? this.country,
        parent: partner.parent ?? this.parent,
        contacts: partner.contacts ?? this.contacts,
      );

  Image imageWidget({BoxFit fit, double width, double height}) {
    try {
      return Image(
        image: imageProvider,
        fit: fit,
        width: width,
        height: height,
      );
    } catch (e) {
      return Image.asset('assets/icons/icon_hilia_3_1.png');
    }
  }
}

class UserNotification extends Equatable {
  final String title;
  final String body;
  final Map data;

  UserNotification({this.title, this.body, this.data});

  factory UserNotification.fromJson(Map<String, dynamic> json) =>
      UserNotification(
          title: json["title"], body: json["body"], data: json["data"]);

  Map<String, dynamic> get toJson {
    return Map.from({
      FieldTitle: title,
      FieldBody: body,
      FieldData: data,
    });
  }

  @override
  List<Object> get props => [title, body, data];
}

class Country extends Equatable {
  final int id;
  final String name;
  final String code;
  final List<CountryState> states;

  Country({this.id, this.name, this.code, this.states});

  factory Country.fromJson(Map<String, dynamic> json) => Country(
        id: json["id"],
        name: json["name"],
        code: json["code"],
        states: ((json["states"] ?? []) as List)
            .map((e) => CountryState.fromJson(e))
            .toList(),
      );

  Country copyWith(Country country) => Country(
        id: this.id,
        name: country.name ?? this.name,
        code: country.code ?? this.code,
        states: country.states ?? this.states,
      );

  @override
  List<Object> get props => [id, name, code, states];
}

class CountryState extends Equatable {
  final int id;
  final String name;
  final String code;
  final Country country;

  const CountryState({this.id, this.name, this.code, this.country});

  factory CountryState.fromJson(Map<String, dynamic> json) => CountryState(
        id: json["id"],
        name: json["name"],
        code: json["code"],
        country:
            json['country'] != null ? Country.fromJson(json['country']) : null,
      );

  CountryState copyWith(CountryState countryState) => CountryState(
        id: this.id,
        name: countryState.name ?? this.name,
        code: countryState.code ?? this.code,
        country: countryState.country ?? this.country,
      );

  @override
  List<Object> get props => [id, name, code, country];
}

class Payment {}
