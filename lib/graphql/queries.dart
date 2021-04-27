import 'dart:convert';

import 'fragments.dart';

abstract class BaseQuery {
  String get query;
  Map<String, dynamic> get variables;
  static String Function() getLang;

  String get lang => getLang != null ? getLang() : null;

  @override
  String toString() {
    return json.encode({"query": query, "variables": variables});
  }
}

class MeQuery extends BaseQuery {
  final Fragment fragment;
  final int orderLimit;
  final int orderOffset;
  final String orderState;

  MeQuery(this.fragment, {this.orderLimit, this.orderOffset, this.orderState});

  @override
  String get query => '''
  query Me(\$orderLimit: Int, \$orderOffset: Int, \$orderState: String, \$lang: String) {
    viewer(lang: \$lang) {
      me {
        ...${fragment.name}
      }
    }
  }
  $fragment
  ''';

  @override
  Map<String, dynamic> get variables => {
        "orderLimit": orderLimit,
        "orderOffset": orderOffset,
        "orderState": orderState,
        "lang": lang,
      };
}

// class AppSettingQuery extends BaseQuery {
//   final Fragment fragment;

//   AppSettingQuery(this.fragment);

//   @override
//   String get query => '''
//   query AppSetting(\$lang: String) {
//     viewer(lang: \$lang) {
//       appSetting {
//         ...${fragment.name}
//       }
//     }
//   }
//   $fragment
//   ''';

//   @override
//   Map<String, dynamic> get variables => {"lang": lang};
// }

class AdsQuery extends BaseQuery {
  final Fragment fragment;
  final int limit;
  final int offset;

  AdsQuery(this.fragment, {this.limit, this.offset});

  @override
  String get query => '''
  query Ads(\$limit: Int, \$offset: Int, \$lang: String) {
    viewer(lang: \$lang) {
      ads(limit: \$limit, offset: \$offset) {
        ...${fragment.name}
      }
    }
  }
  $fragment
  ''';

  @override
  Map<String, dynamic> get variables =>
      {"limit": limit, "offset": offset, "lang": lang};
}

class ProductsQuery extends BaseQuery {
  final Fragment fragment;
  final int limit;
  final int offset;
  final bool onlyShippingService;
  final int categId;

  ProductsQuery(this.fragment,
      {this.limit, this.offset, this.onlyShippingService, this.categId});

  @override
  String get query => '''
  query Products(\$limit: Int, \$offset: Int, \$onlyShippingService: Boolean, \$categId: Int, \$lang: String) {
    viewer(lang: \$lang) {
      products(limit: \$limit, offset: \$offset, onlyShippingService: \$onlyShippingService, categId: \$categId) {
        ...${fragment.name}
      }
    }
  }
  $fragment
  ''';

  @override
  Map<String, dynamic> get variables => {
        "limit": limit,
        "offset": offset,
        "onlyShippingService": onlyShippingService,
        "categId": categId,
        "lang": lang
      };
}

class OrderQuery extends BaseQuery {
  final Fragment fragment;
  final int id;

  OrderQuery(this.fragment, this.id);

  @override
  String get query => '''
  query OrderQuery(\$id: Int, \$lang: String) {
    viewer(lang: \$lang) {
      order(id: \$id) {
        ...${fragment.name}
      }
    }
  }
  $fragment
  ''';

  @override
  Map<String, dynamic> get variables => {"id": id, "lang": lang};
}

class ProductQuery extends BaseQuery {
  final Fragment fragment;
  final int id;

  ProductQuery(this.fragment, this.id);

  @override
  String get query => '''
  query Product(\$id: Int, \$lang: String) {
    viewer(lang: \$lang) {
      product(id: \$id) {
        ...${fragment.name}
      }
    }
  }
  $fragment
  ''';

  @override
  Map<String, dynamic> get variables => {"id": id, "lang": lang};
}

class CategoriesQuery extends BaseQuery {
  final Fragment fragment;
  final int limit;
  final int offset;
  final bool rootOnly;
  final bool showOnApp;
  final int productsLimit;
  final int productsOffset;

  CategoriesQuery(this.fragment,
      {this.limit,
      this.offset,
      this.rootOnly,
      this.showOnApp,
      this.productsOffset,
      this.productsLimit});

  @override
  String get query => '''
  query Categories(\$limit: Int, \$offset: Int, \$rootOnly: Boolean, \$showOnApp: Boolean, \$productsLimit: Int, \$productsOffset: Int, \$lang: String) {
    viewer(lang: \$lang) {
      categories(limit: \$limit, offset: \$offset, rootOnly: \$rootOnly, showOnApp: \$showOnApp) {
        ...${fragment.name}
      }
    }
  }
  $fragment
  ''';

  @override
  Map<String, dynamic> get variables => {
        "limit": limit,
        "offset": offset,
        "rootOnly": rootOnly,
        "showOnApp": showOnApp,
        "productsLimit": productsLimit,
        "productsOffset": productsOffset,
        "lang": lang
      };
}

class CategoryQuery extends BaseQuery {
  final Fragment fragment;
  final int id;
  final int productsLimit;
  final int productsOffset;

  CategoryQuery(this.fragment,
      {this.id, this.productsOffset, this.productsLimit});

  @override
  String get query => '''
  query Category(\$id: Int, \$productsLimit: Int, \$productsOffset: Int, \$lang: String) {
    viewer(lang: \$lang) {
      category(id: \$id) {
        ...${fragment.name}
      }
    }
  }
  $fragment
  ''';

  @override
  Map<String, dynamic> get variables => {
        "id": id,
        "productsLimit": productsLimit,
        "productsOffset": productsOffset,
        "lang": lang
      };
}
