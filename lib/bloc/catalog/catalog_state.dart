part of 'catalog_bloc.dart';

class CatalogState extends Equatable {
  CatalogState({
    this.categoriesState = const LoaderState<List<HiliaCategory>>(data: []),
    this.adsState = const LoaderState<List<Ads>>(data: []),
    this.productsState = const ProductLoadersState([]),
    // this.setting = const LoaderState<AppSetting>(),
    this.cartState = const LoaderState<List<CartItem>>(data: []),
    this.favState = const LoaderState<List<int>>(data: []),
    this.notifications = const LoaderState<List<UserNotification>>(data: []),
  });

  final LoaderState<List<HiliaCategory>> categoriesState;
  final LoaderState<List<Ads>> adsState;
  final ProductLoadersState productsState;
  // final LoaderState<AppSetting> setting;
  final LoaderState<List<CartItem>> cartState;
  final LoaderState<List<int>> favState;
  final LoaderState<List<UserNotification>> notifications;

  @override
  List<Object> get props => [
        categoriesState,
        productsState,
        adsState,
        // setting,
        cartState,
        favState,
        notifications
      ];

  static CatalogState get empty => CatalogState();

  CatalogState copyWith({
    LoaderState<List<HiliaCategory>> categoriesState,
    LoaderState<List<Ads>> adsState,
    ProductLoadersState productsState,
    // LoaderState<AppSetting> setting,
    LoaderState<List<CartItem>> cartState,
    LoaderState<List<int>> favState,
    LoaderState<List<UserNotification>> notifications,
  }) {
    return CatalogState(
      categoriesState: categoriesState ?? this.categoriesState,
      adsState: adsState ?? this.adsState,
      productsState: productsState ?? this.productsState,
      // setting: setting ?? this.setting,
      cartState: cartState ?? this.cartState,
      favState: favState ?? this.favState,
      notifications: notifications ?? this.notifications,
    );
  }

  List<HiliaCategory> get allCategories =>
      categoriesState.data.fold<List<HiliaCategory>>(
          [],
          (pV, e) => pV
            ..add(e)
            ..addAll(e.children))
        ..sort((a, b) => a.sequence.compareTo(b.sequence));

  List<HiliaCategory> get getChildrenCategories => categoriesState.data
      .fold<List<HiliaCategory>>([], (pV, e) => pV..addAll(e.children))
        ..sort((a, b) => a.sequence.compareTo(b.sequence));

  List<HiliaCategory> get getRootCategories =>
      categoriesState.data..sort((a, b) => a.sequence.compareTo(b.sequence));

  List<Product> get allProduct => productsState.items
      .where((e) => e.status == LoaderStatus.loaded)
      .map((e) => e.data)
      .toList();
  // categoriesState.data
  //     .map<List<Product>>((e) => e.allProducts)
  //     .fold<List<Product>>([], (pv, e) => pv..addAll(e));

  List<Variant> get allVariants =>
      allProduct.fold<List<Variant>>([], (pv, e) => pv..addAll(e.variants));

  LoaderState<Product> getProductState(int id) {
    return productsState.items
        .firstWhere((e) => e.data.id == id, orElse: () => null);
  }

  Product getProduct(int id) {
    return allProduct.firstWhere((e) => e.id == id, orElse: () => null);
  }

  Variant getVariant(int id) {
    return allVariants?.firstWhere((e) => e.id == id, orElse: () => null);
  }

  List<Variant> getVariants(List<int> ids) {
    print(ids);
    return ids.map((e) => getVariant(e)).toList();
  }

  Product getProductByVariantId(int id) {
    return allProduct.firstWhere(
        (e) => e.variants.any((variant) => variant.id == id),
        orElse: () => null);
  }
}

enum LoaderStatus { none, loading, loaded, failed }

class LoaderState<T> extends Equatable {
  final LoaderStatus status;
  final T data;
  final ex;

  const LoaderState({this.status = LoaderStatus.none, this.ex, this.data});

  LoaderState<T> loading() {
    return this.copyWith(status: LoaderStatus.loading);
  }

  LoaderState<T> loadSucceeded(T data) {
    return this.copyWith(status: LoaderStatus.loaded, data: data);
  }

  LoaderState<T> loadFailed(ex) {
    return this.copyWith(status: LoaderStatus.failed, ex: ex);
  }

  LoaderState<T> copyWith({LoaderStatus status, ex, T data}) {
    return LoaderState<T>(
      status: status ?? this.status,
      ex: ex ?? this.ex,
      data: data ?? this.data,
    );
  }

  @override
  List<Object> get props => [status, ex, data];
}

class ListState<T> {
  final List<LoaderState<T>> items;

  const ListState(this.items);

  ListState<T> copyWithUpdateItem(LoaderState<T> item) =>
      ListState<T>([...items]
        ..removeWhere((e) => e.data == item.data)
        ..add(item));
}

class ProductLoadersState {
  final List<LoaderState<Product>> items;

  const ProductLoadersState(this.items);

  ProductLoadersState copyWithUpdateItem(LoaderState<Product> item) =>
      ProductLoadersState([...items]
        ..removeWhere((e) => e.data.id == item.data.id)
        ..add(item));
}
