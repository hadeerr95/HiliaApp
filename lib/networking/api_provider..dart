import 'package:app/config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';

import 'custom_exception.dart';

class ApiProvider {
  static ApiProvider _instance;

  static Future<ApiProvider> get instance async {
    if (_instance != null) {
      return _instance;
    } else {
      _prefer = await SharedPreferences.getInstance();
      _instance = ApiProvider();
      return _instance;
    }
  }

  ApiProvider();
  static SharedPreferences _prefer;

  final http.Client _httpClient = http.Client();

  Future<dynamic> fetch(String url,
      {Map<String, String> headers = const {}}) async {
    try {
      final req = http.Request('GET', Uri.parse(ServerUrl + url));
      req.headers.addAll(headers);
      req.headers["Cookie"] = cookies ?? "";
      // var httpResponse;
      // print({"burl": url, "headers": req.headers});
      for (int i = 0; i < 3; i++) {
        try {
          final httpResponse = await _httpClient.send(req);
          await setCookies(httpResponse.headers);
          print({"statusCode": httpResponse.statusCode, "body": "done"});

          return _response(httpResponse);
        } catch (e) {
          if (i < 2) {
            print("Try number: $i");
            await Future.delayed(Duration(milliseconds: 500));
          } else
            throw SocketException(e.toString());
        }
      }
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
  }

  Future<dynamic> get(String url,
      {Map<String, String> headers = const {}}) async {
    var responseJson;
    try {
      final req = http.Request('GET', Uri.parse(ServerUrl + url));
      req.headers.addAll(headers);
      req.headers["Cookie"] = cookies ?? "";
      final response = await http.get(req.url, headers: req.headers);
      print(response.body);
      await setCookies(response.headers);
      responseJson = _responseJson(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> post(
    String url, {
    Map<String, String> headers = const {},
    Map<String, dynamic> body = const {},
  }) async {
    var responseJson;
    try {
      final req = http.Request('POST', Uri.parse(ServerUrl + url));
      req.headers.addAll(headers);
      req.headers["Cookie"] = cookies ?? "";
      req.headers["Content-Type"] = "text/plain";
      // Content-Type: "text/html; charset=utf-8"
      // Set-Cookie
      req.body = json.encode(body);
      print({"url": req.url, "headers": req.headers, "body": req.body});
      final response =
          await http.post(req.url, headers: req.headers, body: req.body);
      await setCookies(response.headers);
      responseJson = _responseJson(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> put(
    String url, {
    Map<String, String> headers = const {},
    Map<String, dynamic> body = const {},
  }) async {
    var responseJson;
    try {
      final req = http.Request('PUT', Uri.parse(ServerUrl + url));
      req.headers.addAll(headers);
      req.headers["Cookie"] = cookies ?? "";
      req.body = json.encode(body);
      final response =
          await http.put(req.url, headers: req.headers, body: req.body);
      await setCookies(response.headers);
      responseJson = _responseJson(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> delete(String url,
      {Map<String, String> headers = const {}}) async {
    var responseJson;
    try {
      final req = http.Request('DELETE', Uri.parse(ServerUrl + url));
      req.headers.addAll(headers);
      req.headers["Cookie"] = cookies ?? "";
      final response = await http.delete(req.url, headers: req.headers);
      await setCookies(response.headers);
      responseJson = _responseJson(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  dynamic _responseJson(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());
        return responseJson;
      case 400:
        print(response.body.toString());
        throw BadRequestException(response.body.toString());
      case 401:

      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:

      default:
        print(response.body.toString());
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }

  http.StreamedResponse _response(http.StreamedResponse response) {
    switch (response.statusCode) {
      case 200:
        return response;
      case 400:
        throw BadRequestException(response);
      case 401:

      case 403:
        throw UnauthorisedException(response);
      case 500:

      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }

  String get cookies => _prefer.getString("Cookie");

  Future<void> setCookies(Map<String, String> headers) async {
    if (headers.containsKey('set-cookie'))
      _prefer.setString("Cookie", headers['set-cookie']);
  }

  Future<void> emptyCookies() async {
    _prefer.setString("Cookie", "");
  }

  // _updateCookies(http.Response response) {
  //   String rawCookie = response.headers['set-cookie'];
  //   if (rawCookie != null) {
  //     int index = rawCookie.indexOf(';');
  //     String cookie = (index == -1) ? rawCookie : rawCookie.substring(0, index);
  //     _headers['Cookie'] = cookie;
  //     if (index > -1) {
  //       return cookie.split("=")[1];
  //     }
  //   }
  //   return null;
  // }
}
