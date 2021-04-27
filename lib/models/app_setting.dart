part of 'models.dart';

class AppSetting extends Equatable {
  final double minimumAmountForFreeShipping;
  final Currency defCurrency;
  final List<Brand> brands;
  final List<Product> shippingServices;
  final List<Country> countries;
  final List<PaymentAcquirer> acquirers;

  const AppSetting({
    this.defCurrency,
    this.minimumAmountForFreeShipping = 0.0,
    this.brands,
    this.shippingServices,
    this.countries,
    this.acquirers,
  });

  factory AppSetting.fromJson(Map<String, dynamic> json) {
    return AppSetting(
      defCurrency: json['defCurrency'] != null
          ? Currency.fromJson(json['defCurrency'])
          : null,
      minimumAmountForFreeShipping: json["minimumAmountForFreeShipping"],
      countries: ((json["countries"] ?? []) as List)
          .map((e) => Country.fromJson(e))
          .toList(),
      brands: ((json["brands"] ?? []) as List)
          .map((e) => Brand.fromJson(e))
          .toList(),
      shippingServices: ((json["shippingServices"] ?? []) as List)
          .map((e) => Product.fromJson(e))
          .toList(),
      acquirers: ((json["acquirers"] ?? []) as List)
          .map((e) => PaymentAcquirer.fromJson(e))
          .toList(),
    );
  }

  String priceWithCurrency(price) => "$price ${defCurrency?.symbol ?? '\$'}";

  AppSetting copyWith(AppSetting item) => AppSetting(
        defCurrency:
            this.defCurrency.copyWith(item.defCurrency ?? this.defCurrency),
        minimumAmountForFreeShipping: item.minimumAmountForFreeShipping ??
            this.minimumAmountForFreeShipping,
        brands: item.brands ?? this.brands,
        countries: item.countries ?? this.countries,
        acquirers: item.acquirers ?? this.acquirers,
        shippingServices: item.shippingServices ?? this.shippingServices,
      );

  @override
  List<Object> get props => [
        defCurrency,
        minimumAmountForFreeShipping,
        brands,
        shippingServices,
        countries,
        acquirers,
      ];
}

class Brand extends Equatable {
  final int id;
  final String name;
  final String description;
  final ImageProvider logoProvider;
  final Partner partner;

  const Brand({
    this.id,
    this.name,
    this.description,
    this.logoProvider,
    this.partner,
  });

  factory Brand.fromJson(Map<String, dynamic> json) => Brand(
        id: json[FieldId],
        name: json[FieldName],
        description: json[FieldDesc],
        logoProvider: ImageBites.imageFromString(json["logo"]),
        partner:
            json['partner'] != null ? Partner.fromJson(json['partner']) : null,
      );

  Brand copyWith(Brand brand) => Brand(
        id: this.id,
        name: brand.name ?? this.name,
        description: brand.description ?? this.description,
        logoProvider: brand.logoProvider ?? this.logoProvider,
        partner: this.partner.copyWith(brand.partner ?? this.partner),
      );

  @override
  List<Object> get props => [];
}

class Currency {
  final int id;
  final String name;
  final String symbol;

  Currency({this.id, this.name, this.symbol});

  factory Currency.fromJson(Map json) => Currency(
        id: json.containsKey(FieldId) ? json[FieldId] : null,
        name: json.containsKey(FieldName) ? json[FieldName] : null,
        symbol: json.containsKey('symbol') ? json['symbol'] : null,
      );

  Map get toJson => Map.from({FieldId: id, FieldName: name, FieldType: symbol});

  Currency copyWith(Currency item) => Currency(
        id: this.id,
        name: item.name ?? this.name,
        symbol: item.symbol ?? this.symbol,
      );
}
