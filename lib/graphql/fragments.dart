import 'package:app/constant.dart';

class Fragment {
  final String name;
  final String type;
  final String fields;
  final List<Fragment> fragments;

  Fragment(this.name, this.type, this.fields, {this.fragments});

  @override
  String toString() {
    String fragment = '''
    fragment $name on $type {
      $fields
    }
    ''';
    fragments?.forEach((e) => fragment += '$e');
    return fragment;
  }
}

Fragment get userFragment => Fragment(
      "UserFragment",
      "User",
      '''
      id
      sessionId
      lang
      login
      isAdmin
      setting {
        ...${appSettingFragment.name}
      }
      partner {
        ...${userPartnerFragment.name}
      }
      orders(limit: \$orderLimit, offset: \$orderOffset, state: \$orderState) {
        ...${orderFragment.name}
      }
''',
      fragments: [
        userPartnerFragment,
        orderFragment,
        basePartnerFragment,
        appSettingFragment
      ],
    );

Fragment get muteOrderFragment => Fragment("CheckOrderFragment", "Order", '''
  acquirerPaymentUrl
  ...${orderFragment.name}
''', fragments: [orderFragment, basePartnerFragment]);

Fragment get orderFragment => Fragment("OrderFragment", "Order", '''
    id
    name
    dateOrder 
    state
    partnerInvoice{
      ...${basePartnerFragment.name}
    }
    partnerShipping {
      ...${basePartnerFragment.name}
    }
    orderLines {
      productUomQty
      priceUnit
      variant {
        name
        currency {
          id
          name
          symbol
        }
      }
    }
  ''', fragments: []);

Fragment get basePartnerFragment => Fragment(
      "BasePartnerFragment",
      "Partner",
      '''
  id
  name
  phone
  email
  street
  city
  zip
  country {
    ...${countryFragment.name}
  }
  state {
    ...${stateFragment.name}
  }
''',
      fragments: [countryFragment, stateFragment],
    );

Fragment get shippingPartnerFragment =>
    Fragment("ShippingPartnerFragment", "Partner", '''
''');

Fragment get userPartnerFragment => Fragment(
      "UserPartnerFragment",
      "Partner",
      '''
  image
  ...${basePartnerFragment.name}
  contacts {
    ...${basePartnerFragment.name}
  }
''',
    );

Fragment get countryFragment => Fragment("CountryFragment", "Country", '''
  id
  name
  code
''');

Fragment get stateFragment => Fragment("StateFragment", "State", '''
  id
  name
  code
''');

Fragment get baseAdsFragment => Fragment("AdsFragment", "Ads", '''
      id
      name
      url
      image
''');
Fragment get muteUserFragment => Fragment("SessionFragment", "User", '''
      id
      sessionId
      lang
''');

Fragment get rootCategoryFragment => Fragment("ProductFragment", "Category", '''
    id
    name
    sequence
    suggestedProducts
    imageMedium
    children {
      id
      name
      sequence
      products(limit: \$productsLimit, offset: \$productsOffset) {
        ...${baseProductFragment.name}
      }
    }
    products(limit: \$productsLimit, offset: \$productsOffset) {
      ...${baseProductFragment.name}
    }
''', fragments: [baseProductFragment]);

Fragment get orderStatusFragment =>
    Fragment("OrderStatusFragment", " OrderStatus", '''
      txIds
      notOrder
      recall
      validation
      state
''');
Fragment get baseProductFragment =>
    Fragment("BaseProductFragment", "Product", '''
    $FieldId
    $FieldName
    $FieldDesc
    $FieldType
    listPrice
    currency {
      id
      name
      symbol
    }
    ratingCount
    ratingLastValue
    salesCount
    sequence
    imageMedium
    brand {
      id
      name
    }
    uom {
      name
    }
''', fragments: []);

Fragment productFragment = Fragment("ProductFragment", "Product", '''
...${baseProductFragment.name}
...${openProductFragment.name}
''', fragments: [openProductFragment]);

Fragment get openProductFragment =>
    Fragment("OpenProductFragment", "Product", '''
    websiteDescription
    image
    accessories {
      ...${baseProductFragment.name}
    }
    images {
      image
    }
    variants {
      id
      name
      lstPrice
      currency {
        id
        name
        symbol
      }
      attributeValues {
        id
        name
        htmlColor
        attribute {
          id
          name
          type
        }
      }
    }
    attributeLines {
      id
      attribute {
        id
        name
        type
      }
      values {
        id
        name
        htmlColor
      }
    }
''', fragments: [baseProductFragment]);

Fragment get appSettingFragment =>
    Fragment("AppSettingFragment", "AppSetting", '''
defCurrency {
  id
  name
  symbol
}
minimumAmountForFreeShipping
brands {
  id
  name
  description
  logo
}
acquirers {
  id
  name
  description
  imageMedium
  sequence
}
shippingServices {
  id
  imageMedium
  name
  listPrice
  currency {
      id
      name
      symbol
  }
  variants {
    id
    name
    lstPrice
    currency {
      id
      name
      symbol
    }
  }
}
countries {
  id
  name
  code
  states {
    id
    name
    code
  }
}
''', fragments: []);
