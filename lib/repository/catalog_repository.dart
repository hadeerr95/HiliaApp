import 'dart:async';
import 'dart:convert';
import 'package:app/models/models.dart';
import 'package:app/graphql/graphql.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'base_repository.dart';

class ProductNotExist implements Exception {}

class CatalogRepository extends BaseRepository {
  static CatalogRepository _instance;

  static CatalogRepository get instance {
    if (_instance != null) {
      return _instance;
    } else {
      _instance = CatalogRepository();
      return _instance;
    }
  }

  Stream<HiliaCategory> fetchCategory(
      {int id, int productsLimit, int productsOffset}) async* {
    CategoryQuery query = CategoryQuery(rootCategoryFragment,
        id: id, productsLimit: productsLimit, productsOffset: productsOffset);
    yield* fetchfirstFromCache(query).map<HiliaCategory>(
        (event) => HiliaCategory.fromJson(event.data['category']));
  }

  Stream<List<HiliaCategory>> fetchCategories(
      {int offset, int limit, int productsLimit, int productsOffset}) async* {
    CategoriesQuery query = CategoriesQuery(rootCategoryFragment,
        rootOnly: true,
        showOnApp: true,
        offset: offset,
        limit: limit,
        productsLimit: productsLimit,
        productsOffset: productsOffset);
    yield* fetchfirstFromCache(query).map<List<HiliaCategory>>((event) =>
        (event.data['categories'] as List)
            .map<HiliaCategory>((e) => HiliaCategory.fromJson(e))
            .toList());
  }

  Stream<Product> fetchProduct(int id) async* {
    ProductQuery query = ProductQuery(productFragment, id);

    yield* fetchfirstFromCache(query).map<Product>(
        (event) => Product.fromJson((event.data['product'] as Map)));
  }

  Stream<List<Product>> fetchProducts(
      {int categId, int limit, int offset}) async* {
    ProductsQuery query = ProductsQuery(baseProductFragment,
        limit: limit, offset: offset, categId: categId);

    yield* fetchfirstFromCache(query).map<List<Product>>((event) =>
        (event.data['products'] as List)
            .map<Product>((e) => Product.fromJson(e))
            .toList());
  }

  Stream<List<Ads>> fetchAds({int limit, int offset}) async* {
    AdsQuery query = AdsQuery(baseAdsFragment, limit: limit, offset: offset);
    yield* fetchfirstFromCache(query).map<List<Ads>>((event) =>
        (event.data['ads'] as List).map<Ads>((e) => Ads.fromJson(e)).toList());
  }

  Future<List<CartItem>> getCart() async {
    try {
      if ((await getJson('Cart')) == null) await setJson('Cart', []);
      List cart = await getJson('Cart') as List;
      return cart.map((e) => CartItem.fromJson(e)).toList();
    } catch (e) {
      print("-----$e----");
      throw Exception(e);
    }
  }

  Future<List<CartItem>> setCart(List<CartItem> cart) async {
    try {
      if (cart != null) {
        await setJson("Cart", cart.map((e) => e.toJson).toList());
      } else {
        await setJson("Cart", []);
      }
      return await getCart();
    } catch (e) {
      return await getCart();
    }
  }

  Future<List<int>> getFav() async {
    try {
      if ((await getJson('Fav')) == null) await setJson('Fav', []);
      List fav = await getJson('Fav') as List;
      return fav.map<int>((e) => e as int).toList();
    } catch (e) {
      print("-----$e----");
      throw Exception(e);
    }
  }

  Future<List<int>> setFav(List<int> fav) async {
    try {
      if (fav != null) {
        await setJson("Fav", fav);
      } else {
        await setJson("Fav", []);
      }
      return await getFav();
    } catch (e) {
      return await getFav();
    }
  }

  Future<dynamic> getJson(String key) async {
    SharedPreferences prefer = await SharedPreferences.getInstance();
    var value = prefer.getString(key);
    return value != null ? json.decode(value) : null;
  }

  Future<bool> setJson(String key, Object value) async {
    SharedPreferences prefer = await SharedPreferences.getInstance();
    return prefer.setString(key, json.encode(value));
  }

  Future<bool> clearJson(String key) async {
    SharedPreferences prefer = await SharedPreferences.getInstance();
    return prefer.remove(key);
  }
}
