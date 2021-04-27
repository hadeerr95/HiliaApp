part of 'models.dart';

class ProductType {
  static const String Consumable = 'consu';
  static const String Service = 'service';
}

class Product extends Equatable {
  final int id;
  final ImageProvider imageProvider;
  final ImageProvider imageMediumProvider;
  final String name;
  final String defaultCode;
  final String description;
  final String websiteDesc;
  final String type;
  final double listPrice;
  final Currency currency;
  final double ratingLastValue;
  final int ratingCount;
  final int salesCount;

  final List<Variant> variants;
  final List<ImageBites> images;
  final List<AttributeLine> attributeLines;

  Product({
    this.id,
    this.name,
    this.defaultCode,
    this.imageProvider,
    this.imageMediumProvider,
    this.description,
    this.websiteDesc,
    this.listPrice = 0,
    this.currency,
    this.ratingLastValue = 0,
    this.ratingCount = 0,
    this.salesCount = 0,
    this.type,
    List<Variant> variants,
    List<ImageBites> images,
    List<AttributeLine> attributeLines,
  })  : this.variants = variants ?? [],
        this.images = images ?? [],
        this.attributeLines = attributeLines ?? [];

  factory Product.fromJson(Map<String, dynamic> json) {
    // json.forEach((k, v) => print("k: $k, v: $v"));
    return Product(
      id: json[FieldId],
      name: json[FieldName],
      websiteDesc: json["websiteDescription"],
      description: json[FieldDesc],
      imageMediumProvider: json["imageMedium"] != null
          ? ImageBites.imageFromString(json["imageMedium"])
          : null,
      imageProvider: json[FieldImage] != null
          ? ImageBites.imageFromString(json[FieldImage])
          : null,
      listPrice: json["listPrice"],
      type: json[FieldType],
      ratingLastValue: json["ratingLastValue"],
      ratingCount: json["ratingCount"],
      salesCount: json["salesCount"],
      currency: json['defCurrency'] != null
          ? Currency.fromJson(json['defCurrency'])
          : null,
      variants: ((json["variants"] ?? []) as List)
          .map((e) => Variant.fromJson(e))
          .toList(),
      attributeLines: ((json["attributeLines"] ?? []) as List)
          .map((e) => AttributeLine.fromJson(e))
          .toList(),
      images: ((json["images"] ?? []) as List)
          .map((e) => ImageBites.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> get toJson => Map.from({
        FieldId: id,
        FieldName: name,
        FieldDefaultCode: defaultCode,
        FieldWebsiteDesc: websiteDesc,
        // "imageMedium": imageMedium ?? "",
        // FieldImage: image ?? "",
        FieldDesc: description ?? "",
        FieldType: type ?? "",
        FieldLstPrice: listPrice ?? 0.0,
        "variants": variants.map((e) => e.toJson).toList(),
        "images": images.map((e) => e.toJson).toList(),
        "attributeLines": attributeLines.map((e) => e.toJson).toList(),
      });

  double get ratingValue => ratingLastValue >= 1 ? ratingLastValue : 1.0;

  String get priceWithCurrency => "$listPrice ${currency?.symbol ?? '\$'}";

  Product copyWith(
    Product product,
  ) =>
      Product(
        id: this.id,
        imageProvider: product.imageProvider ?? this.imageProvider,
        imageMediumProvider:
            product.imageMediumProvider ?? this.imageMediumProvider,
        name: product.name ?? this.name,
        description: product.description ?? this.description,
        websiteDesc: product.websiteDesc ?? this.websiteDesc,
        type: product.type ?? this.type,
        listPrice: product.listPrice ?? this.listPrice,
        currency: product.currency ?? this.currency,
        ratingLastValue: product.ratingLastValue ?? this.ratingLastValue,
        ratingCount: product.ratingCount ?? this.ratingCount,
        salesCount: product.salesCount ?? this.salesCount,
        variants:
            product.variants.isNotEmpty ? product.variants : this.variants,
        images: product.images.isNotEmpty ? product.images : this.images,
        attributeLines: product.attributeLines.isNotEmpty
            ? product.attributeLines
            : this.attributeLines,
      );

  Image imageWidget({BoxFit fit, double width, double height}) {
    try {
      return Image(
        image: imageProvider ?? imageMediumProvider,
        fit: fit,
        width: width,
        height: height,
      );
    } catch (e) {
      return Image.asset('assets/icons/icon_hilia_3_1.png');
    }
  }

  @override
  List<Object> get props => [
        id,
        name,
        imageMediumProvider,
        description,
        listPrice,
        currency,
        type,
        ratingLastValue,
        ratingCount,
        salesCount,
        defaultCode,
        imageProvider,
        websiteDesc,
        variants,
        images,
        attributeLines,
      ];
}

class HiliaCategory extends Equatable {
  final int id;
  final String name;
  final String description;
  final int sequence;
  final int parentId;
  final bool suggestedProducts;
  final HiliaCategory parent;
  final ImageProvider imageProvider;
  final ImageProvider imageMediumProvider;
  final Widget def;
  final List<HiliaCategory> children;
  final List<Product> products;

  HiliaCategory({
    this.id,
    this.name,
    this.imageProvider,
    this.imageMediumProvider,
    this.description,
    this.sequence,
    this.suggestedProducts,
    this.parentId,
    this.parent,
    List<HiliaCategory> children,
    List<Product> products,
    this.def,
  })  : this.children = children ?? [],
        this.products = products ?? [];

  factory HiliaCategory.fromJson(Map<String, dynamic> json) {
    // print();
    return HiliaCategory(
      id: json[FieldId],
      name: json[FieldName],
      suggestedProducts: json["suggestedProducts"],
      imageMediumProvider: json["imageMedium"] != null
          ? ImageBites.imageFromString(json["imageMedium"])
          : null,
      imageProvider: json[FieldImage] != null
          ? ImageBites.imageFromString(json[FieldImage])
          : null,
      sequence: json[FieldSequence],
      description: json[FieldDesc],
      parent: json['parent'] != null
          ? HiliaCategory.fromJson(json['parent'])
          : null,
      children: ((json["children"] ?? []) as List)
          .map((e) => HiliaCategory.fromJson(e))
          .toList(),
      products: ((json["products"] ?? []) as List)
          .map((e) => Product.fromJson(e))
          .toList(),
    );
  }

  List<Product> get allProducts => [
        ...this?.products ?? [],
        ...this
                ?.children
                ?.map((e) => e.products)
                ?.toList()
                ?.fold<List<Product>>([], (pv, e) => pv..addAll(e)) ??
            [],
      ];

  List<Variant> get allVariants => allProducts
      .map((e) => e.variants)
      .toList()
      .fold<List<Variant>>([], (pv, e) => pv..addAll(e));

  Map<String, dynamic> get toJson => Map.from({
        FieldId: id,
        FieldName: name,
        FieldDesc: description,
        FieldSequence: sequence,
        "parent": parent?.toJson,
        "children": children.map((e) => e.toJson).toList(),
        "products": products.map((e) => e.toJson).toList()
      });

  Image imageWidget({BoxFit fit, double width, double height}) {
    try {
      return Image(
        image: imageProvider ?? imageMediumProvider,
        fit: fit,
        width: width,
        height: height,
      );
    } catch (e) {
      return Image.asset('assets/icons/icon_hilia_3_1.png');
    }
  }

  @override
  List<Object> get props => [
        id,
        name,
        description,
        sequence,
        parentId,
      ];
}

class ImageBites extends Equatable {
  final int id;
  final String name;
  final ImageProvider imageProvider;
  final ImageProvider imageMediumProvider;

  ImageBites({
    this.id,
    this.name,
    this.imageProvider,
    this.imageMediumProvider,
  });

  factory ImageBites.fromJson(Map<String, dynamic> json) {
    return ImageBites(
      id: json[FieldId],
      name: json[FieldName],
      imageMediumProvider: ImageBites.imageFromString(json["imageMedium"]),
      imageProvider: ImageBites.imageFromString(json[FieldImage]),
    );
  }

  Map<String, dynamic> get toJson => Map.from({
        FieldId: id,
        FieldName: name,
      });

  Image imageWidget({BoxFit fit, double width, double height}) {
    try {
      return Image(
        image: imageProvider ?? imageMediumProvider,
        fit: fit,
        width: width,
        height: height,
      );
    } catch (e) {
      return Image.asset('assets/icons/icon_hilia_3_1.png');
    }
  }

  static ImageProvider imageFromString(String src) {
    try {
      var base64Image = base64.decode(src.replaceAll("\n", ""));
      return MemoryImage(base64Image);
    } catch (e) {
      return null;
    }
  }

  @override
  List<Object> get props => [id, name, imageProvider, imageMediumProvider];

  ImageBites copyWith(ImageBites productImage) => ImageBites(
        id: this.id,
        name: productImage.name ?? this.name,
        imageProvider: productImage.imageProvider ?? this.imageProvider,
        imageMediumProvider:
            productImage.imageMediumProvider ?? this.imageMediumProvider,
      );
}

class Variant extends Equatable {
  final int id;
  final int productId;
  final String name;
  final String defaultCode;
  final String type;
  final double lstPrice;
  final Currency currency;
  final List attributeValueIds;
  final List<AttributeValue> attributeValues;

  Variant(
      {this.id,
      this.productId,
      this.attributeValueIds,
      this.name,
      this.defaultCode,
      this.type,
      this.lstPrice,
      this.currency,
      List<AttributeValue> attributeValues})
      : this.attributeValues = attributeValues;

  factory Variant.fromJson(Map json) => Variant(
        id: json[FieldId],
        name: json[FieldName],
        lstPrice: json["lstPrice"],
        currency: json['defCurrency'] != null
            ? Currency.fromJson(json['defCurrency'])
            : null,
        attributeValues: ((json["attributeValues"] ?? []) as List)
            .map((e) => AttributeValue.fromJson(e))
            .toList(),
      );

  Map get toJson => Map.from({
        FieldId: id,
        FieldProductTemplateId: productId,
        FieldAttributeValueIds: attributeValueIds,
        FieldName: name,
        FieldDefaultCode: defaultCode,
        FieldType: type,
        FieldLstPrice: lstPrice,
        "attributeValues": attributeValues.map((e) => e.toJson).toList(),
      });

  String get priceWithCurrency => "$lstPrice ${currency?.symbol ?? '\$'}";

  Variant copyWith(Variant variant) => Variant(
        id: this.id,
        name: variant.name ?? this.name,
        lstPrice: variant.lstPrice ?? this.lstPrice,
        currency: variant.currency ?? this.currency,
        attributeValues: variant.attributeValues.isNotEmpty
            ? variant.attributeValues
            : this.attributeValues,
      );

  @override
  List<Object> get props => [
        id,
        productId,
        attributeValueIds,
        name,
        defaultCode,
        type,
        lstPrice,
        currency,
        attributeValues
      ];
}

class AttributeType {
  static const String Radio = 'radio';
  static const String Select = 'Select';
  static const String Color = 'color';
  static const String Hidden = 'hidden';
}

class Attribute {
  final int id;
  final String name;
  final String type;

  Attribute({this.id, this.name, this.type});

  factory Attribute.fromJson(Map json) => Attribute(
        id: json.containsKey(FieldId) ? json[FieldId] : null,
        name: json.containsKey(FieldName) ? json[FieldName] : null,
        type: json.containsKey(FieldType) ? json[FieldType] : null,
      );

  Map get toJson => Map.from({FieldId: id, FieldName: name, FieldType: type});

  Attribute copyWith(Attribute attributeLine) => Attribute(
        id: this.id,
        name: attributeLine.name ?? this.name,
        type: attributeLine.type ?? this.type,
      );
}

class AttributeValue {
  final int id;
  final Attribute attribute;
  final String name;
  final String htmlColor;

  AttributeValue({this.id, this.name, this.htmlColor, this.attribute});

  factory AttributeValue.fromJson(Map json) => AttributeValue(
        id: json[FieldId],
        name: json[FieldName],
        htmlColor: json["htmlColor"],
        attribute: json['attribute'] != null
            ? Attribute.fromJson(json['attribute'])
            : null,
      );

  Map get toJson => Map.from({
        FieldId: id,
        FieldName: name,
        "htmlColor": htmlColor,
        "attribute": attribute?.toJson,
      });

  AttributeValue copyWith(AttributeValue attributeValue) => AttributeValue(
        id: this.id,
        name: attributeValue.name ?? this.name,
        htmlColor: attributeValue.htmlColor ?? this.htmlColor,
        attribute:
            this.attribute.copyWith(attributeValue.attribute ?? this.attribute),
      );
}

class AttributeLine {
  final int id;
  final List attributeValueIds;
  final List<AttributeValue> values;
  final Attribute attribute;

  AttributeLine(
      {this.id,
      this.attributeValueIds,
      this.attribute,
      List<AttributeValue> values})
      : this.values = values ?? [];

  factory AttributeLine.fromJson(Map json) => AttributeLine(
        id: json.containsKey(FieldId) ? json[FieldId] : null,
        attributeValueIds:
            json.containsKey(FieldValueIds) ? json[FieldValueIds] : null,
        attribute: json['attribute'] != null
            ? Attribute.fromJson(json['attribute'])
            : null,
        values: ((json["values"] ?? []) as List)
            .map((e) => AttributeValue.fromJson(e))
            .toList(),
      );

  Map get toJson => Map.from({
        FieldId: id,
        FieldValueIds: attributeValueIds,
        "attribute": attribute?.toJson,
        "values": values.map((e) => e.toJson).toList(),
      });

  AttributeLine copyWith(AttributeLine attributeLine) => AttributeLine(
        id: this.id,
        attribute:
            this.attribute.copyWith(attributeLine.attribute ?? this.attribute),
        values: attributeLine.values.isNotEmpty
            ? attributeLine.values
            : this.values,
      );
}

class UnitOfMeasureCategories {
  final int id;
  final String name;

  UnitOfMeasureCategories({this.id, this.name});

  factory UnitOfMeasureCategories.fromJson(Map json) => UnitOfMeasureCategories(
        id: json.containsKey(FieldId) ? json[FieldId] : null,
        name: json.containsKey(FieldName) ? json[FieldName] : null,
      );

  Map get toJson => Map.from({FieldId: id, FieldName: name});
}
