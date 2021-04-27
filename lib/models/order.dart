part of 'models.dart';

class OrderStatus {
  static const String QuotationSent = 'sent';
  static const String SalesOrder = 'sale';
  static const String LockedOrder = 'done';
  static const String CancelledOrder = 'cancel';
}

class PaymentAcquirer extends Equatable {
  final int id;
  final String name;
  final ImageProvider imageMediumProvider;
  final int sequence;

  PaymentAcquirer({
    this.id,
    this.name,
    this.imageMediumProvider,
    this.sequence,
  });

  factory PaymentAcquirer.fromJson(Map<String, dynamic> json) {
    return PaymentAcquirer(
      id: json[FieldId],
      name: json['name'],
      sequence: json['sequence'],
      imageMediumProvider: ImageBites.imageFromString(json["imageMedium"]),
    );
  }

  Map get toJson => {'id': id};

  Image imageWidget({BoxFit fit, double width, double height}) {
    try {
      return Image(
        image: imageMediumProvider,
        fit: fit,
        width: width,
        height: height,
      );
    } catch (e) {
      return Image.asset('assets/icons/icon_hilia_3_1.png');
    }
  }

  @override
  List<Object> get props => [id, name, imageMediumProvider, sequence];
}

class PaymentTransaction extends Equatable {
  final int id;
  final String state;

  PaymentTransaction({this.id, this.state});

  factory PaymentTransaction.fromJson(Map<String, dynamic> json) {
    return PaymentTransaction(
      id: json[FieldId],
      state: json['state'],
    );
  }

  Map get toJson => {};

  @override
  List<Object> get props => [id, state];
}

class SaleOrder extends Equatable {
  final int id;
  final String name;
  final String orderStatus;
  final String dateOrder;
  final Variant shippingService;
  final Partner partner;
  final Partner partnerShipping;
  final Partner partnerInvoice;
  final PaymentAcquirer paymentAcquirer;
  final PaymentTransaction paymentTx;
  final List<SaleOrderLine> orderLines;
  final String acquirerPaymentUrl;

  // var cartTaxes;
  // Payment payment;

  SaleOrder({
    this.id,
    this.name,
    this.shippingService,
    this.partner,
    this.partnerShipping,
    this.partnerInvoice,
    this.orderStatus,
    this.acquirerPaymentUrl,
    this.dateOrder,
    this.paymentAcquirer,
    this.paymentTx,
    List<SaleOrderLine> orderLines,
  }) : this.orderLines = orderLines ?? [];

  factory SaleOrder.empty() => SaleOrder();

  factory SaleOrder.fromJson(Map<String, dynamic> json) {
    return SaleOrder(
      id: json[FieldId],
      name: json[FieldName],
      orderStatus: json[FieldState],
      dateOrder: json["dateOrder"],
      acquirerPaymentUrl: json["acquirerPaymentUrl"],
      partner:
          json['partner'] != null ? Partner.fromJson(json['partner']) : null,
      partnerShipping: json['partnerShipping'] != null
          ? Partner.fromJson(json['partnerShipping'])
          : null,
      partnerInvoice: json['partnerInvoice'] != null
          ? Partner.fromJson(json['partnerInvoice'])
          : null,
      paymentAcquirer: json['paymentAcquirer'] != null
          ? PaymentAcquirer.fromJson(json['paymentAcquirer'])
          : null,
      paymentTx: json['paymentTx'] != null
          ? PaymentTransaction.fromJson(json['paymentTx'])
          : null,
      orderLines: ((json["orderLines"] ?? []) as List)
          .map((e) => SaleOrderLine.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> get toJson {
    return Map.from({
      "partnerInvoiceId": partnerInvoice?.id,
      "partnerShippingId": partnerShipping?.id,
      "shippingServiceId": shippingService?.id,
      "paymentAcquirerId": paymentAcquirer?.id,
      "lines": orderLines.map<Map>((e) => e.toJson).toList(),
    });
  }

  double get totalPrice => orderLines
      .map<double>((e) => e.totalPrice)
      .toList()
      .fold<double>(0.0, (v, e) => v + e);

  @override
  List<Object> get props => [
        id,
        name,
        shippingService,
        partner,
        partnerShipping,
        partnerInvoice,
        orderStatus,
        acquirerPaymentUrl,
        dateOrder,
        paymentAcquirer,
        paymentTx,
        orderLines,
      ];

  get isGoodPartners => partner?.id != null
      ? partnerInvoice?.id != null
          ? partnerShipping?.id != null
          : true
      : false;

  SaleOrder copyWith(
    SaleOrder item,
  ) =>
      SaleOrder(
        id: this.id,
        name: item.name ?? this.name,
        dateOrder: item.dateOrder ?? this.dateOrder,
        orderStatus: item.orderStatus ?? this.orderStatus,
        acquirerPaymentUrl: item.acquirerPaymentUrl ?? this.acquirerPaymentUrl,
        paymentAcquirer: item.paymentAcquirer ?? this.paymentAcquirer,
        paymentTx: item.paymentTx ?? this.paymentTx,
        shippingService: item.shippingService ?? this.shippingService,
        partner: item.partner ?? this.partner,
        partnerInvoice: item.partnerInvoice ?? this.partnerInvoice,
        partnerShipping: item.partnerShipping ?? this.partnerShipping,
        orderLines:
            item.orderLines.isNotEmpty ? item.orderLines : this.orderLines,
      );
}

class SaleOrderLine extends Equatable {
  final int id;
  final SaleOrder order;
  final Variant variant;
  final double priceUnit;
  final int productsQty;

  SaleOrderLine(
      {this.id, this.order, this.variant, this.priceUnit, this.productsQty});

  double get totalPrice {
    return priceUnit != null ? priceUnit * productsQty : null;
  }

  factory SaleOrderLine.fromJson(Map<String, dynamic> json) {
    return SaleOrderLine(
      id: json[FieldId],
      productsQty: json['productUomQty'] != null
          ? (json['productUomQty'] as double).round()
          : 0,
      priceUnit: json["priceUnit"],
      variant:
          json['variant'] != null ? Variant.fromJson(json['variant']) : null,
      order: json['order'] != null ? SaleOrder.fromJson(json['order']) : null,
    );
  }

  Map get toJson => {
        "variantId": variant?.id,
        "qty": productsQty,
        "priceUnit": priceUnit,
      };

  @override
  List<Object> get props => [id, order, variant, priceUnit, productsQty];
}
