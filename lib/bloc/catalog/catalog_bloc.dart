import 'dart:async';
import 'package:app/models/models.dart';
import 'package:app/repository/repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'catalog_state.dart';

class CatalogCubit extends Cubit<CatalogState> {
  CatalogCubit({
    @required CatalogRepository catalogRepository,
  })  : assert(catalogRepository != null),
        _catalogRepository = catalogRepository,
        super(CatalogState());

  final CatalogRepository _catalogRepository;

  Future<void> reloadCatalog() async {
    loadCategories(refresh: true);
  }

  Future<void> catalogStarted() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    try {
      // emit(CatalogState.empty);
      loadCart();
      loadFav();
//
//      await Future<void>.delayed(const Duration(milliseconds: 500));
//      shippingServiceLoad();
    } catch (e) {
      print(e);
    }
  }

  Future<void> loadCart() async {
    try {
      emit(state.copyWith(cartState: state.cartState.loading()));
      List<CartItem> cart = await _catalogRepository.getCart();

      emit(state.copyWith(
          cartState: state.cartState.loadSucceeded(
              cart..sort((a, b) => a.variantId.compareTo(b.variantId)))));
    } catch (e) {
      emit(state.copyWith(cartState: state.cartState.loadFailed(e)));
      print("$e");
    }
  }

  Future<void> loadFav() async {
    try {
      emit(state.copyWith(favState: state.favState.loading()));
      List<int> favs = await _catalogRepository.getFav();

      emit(state.copyWith(favState: state.favState.loadSucceeded(favs)));
    } catch (e) {
      emit(state.copyWith(favState: state.favState.loadFailed(e)));
      print("$e");
    }
  }

  Future<void> addItemToCart(CartItem item) async {
    try {
      emit(state.copyWith(cartState: state.cartState.loading()));
      List<CartItem> cart =
          await _catalogRepository.setCart([...state.cartState.data]
            ..removeWhere((e) => e.variantId == item.variantId)
            ..add(item));

      emit(state.copyWith(
          cartState: state.cartState.loadSucceeded(
              cart..sort((a, b) => a.variantId.compareTo(b.variantId)))));
    } catch (e) {
      emit(state.copyWith(cartState: state.cartState.loadFailed(e)));
      print("$e");
    }
  }

  Future<void> addItemToFav(int item) async {
    try {
      emit(state.copyWith(favState: state.favState.loading()));
      List<int> fav = await _catalogRepository
          .setFav([...state.favState.data, item].toSet().toList());

      emit(state.copyWith(favState: state.favState.loadSucceeded(fav)));
    } catch (e) {
      emit(state.copyWith(favState: state.favState.loadFailed(e)));
      print("$e");
    }
  }

  Future<void> removeItemFromCart(int variantId) async {
    try {
      emit(state.copyWith(cartState: state.cartState.loading()));
      List<CartItem> cart = await _catalogRepository.setCart([
        ...state.cartState.data
      ]..removeWhere((e) => e.variantId == variantId));

      emit(state.copyWith(
          cartState: state.cartState.loadSucceeded(
              cart..sort((a, b) => a.variantId.compareTo(b.variantId)))));
    } catch (e) {
      emit(state.copyWith(cartState: state.cartState.loadFailed(e)));
      print("$e");
    }
  }

  Future<void> removeItemFromFav(int item) async {
    try {
      emit(state.copyWith(favState: state.favState.loading()));
      List<int> fav = await _catalogRepository
          .setFav([...state.favState.data]..removeWhere((e) => e == item));

      emit(state.copyWith(favState: state.favState.loadSucceeded(fav)));
    } catch (e) {
      emit(state.copyWith(favState: state.favState.loadFailed(e)));
      print("$e");
    }
  }

  Future<void> updateCart(List<CartItem> items) async {
    try {
      emit(state.copyWith(cartState: state.cartState.loading()));
      List<CartItem> cart = await _catalogRepository.setCart(items);
      emit(state.copyWith(
          cartState: state.cartState.loadSucceeded(
              cart..sort((a, b) => a.variantId.compareTo(b.variantId)))));
    } catch (e) {
      emit(state.copyWith(cartState: state.cartState.loadFailed(e)));
      print("$e");
    }
  }

  Future<void> loadCategories({bool refresh = false}) async {
    try {
      emit(state.copyWith(categoriesState: state.categoriesState.loading()));
      _catalogRepository
          .fetchCategories(
              productsLimit: 40,
              offset: refresh ? 0 : state.categoriesState.data.length)
          .handleError((e) {
        emit(state.copyWith(
            categoriesState: state.categoriesState.loadFailed(e)));
        print("$e");
      }).listen((event) {
        List<HiliaCategory> categories;
        if (refresh)
          categories = event;
        else {
          categories = [
            ...event,
            ...state.categoriesState.data
                .where((item) => !event.any((e) => e.id == item.id))
          ];
        }
        emit(state.copyWith(
            categoriesState: state.categoriesState.loadSucceeded(categories)));
      });

      loadAds(refresh: true);
    } catch (e) {
      emit(
          state.copyWith(categoriesState: state.categoriesState.loadFailed(e)));
      print("$e");
    }
  }

  Future<void> loadAds({bool refresh = false}) async {
    try {
      emit(state.copyWith(adsState: state.adsState.loading()));
      _catalogRepository
          .fetchAds(offset: refresh ? 0 : state.adsState.data.length)
          .handleError((e) {
        emit(state.copyWith(adsState: state.adsState.loadFailed(e)));
        print("$e");
      }).listen((event) {
        List<Ads> ads;
        if (refresh)
          ads = event;
        else {
          ads = [
            ...event,
            ...state.adsState.data
                .where((item) => !event.any((e) => e.id == item.id))
          ];
        }
        emit(state.copyWith(adsState: state.adsState.loadSucceeded(ads)));
      });
    } catch (e) {
      emit(state.copyWith(adsState: state.adsState.loadFailed(e)));
      print("$e");
    }
  }

  // Future<void> loadAppSetting() async {
  //   try {
  //     emit(state.copyWith(setting: state.setting.loading()));
  //     _catalogRepository.fetchAppSetting().handleError((e) {
  //       emit(state.copyWith(setting: state.setting.loadFailed(e)));
  //       print("$e");
  //     }).listen((event) {
  //       emit(state.copyWith(setting: state.setting.loadSucceeded(event)));
  //     });
  //   } catch (e) {
  //     emit(state.copyWith(setting: state.setting.loadFailed(e)));
  //     print("$e");
  //   }
  // }

  Future<void> loadProduct(int id) async {
    try {
      emit(state.copyWith(
          productsState: state.productsState.copyWithUpdateItem(
              LoaderState<Product>(
                  data: Product(id: id), status: LoaderStatus.loading))));
      _catalogRepository.fetchProduct(id).handleError((e) {
        print("$e");
        emit(state.copyWith(
            productsState: state.productsState.copyWithUpdateItem(
                LoaderState<Product>(data: Product(id: id)).loadFailed("$e"))));
      }).listen((event) {
        emit(state.copyWith(
            productsState: state.productsState.copyWithUpdateItem(
                LoaderState<Product>().loadSucceeded(event))));
      });
    } catch (e) {
      print("$e");
      emit(state.copyWith(
          productsState: state.productsState.copyWithUpdateItem(
              LoaderState<Product>(data: Product(id: id)).loadFailed(e))));
    }
  }

  removeNotification(UserNotification e) {}

  void addNotification(UserNotification userNotification) {}
}
