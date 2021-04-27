import 'dart:async';
import 'dart:convert';

import 'package:app/graphql/graphql.dart';
import 'package:app/compo.dart';
import 'package:app/config.dart';
import 'package:app/models/models.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

part 'api_service.dart';

class ConnectionFailure implements Exception {}

class ServerProblem implements Exception {}

class RequestFailed implements Exception {}

abstract class BaseService {
  Future<Exception> exceptionHandler(e) async {
    print('Create Order Not Succeeded: $e');
    if (await isConnectivityByUrl(ServerUrl)) {
      print('RequestFailed');
      return RequestFailed();
    } else if (await isConnectivity) {
      print('ServerProblem');
      return ServerProblem();
    } else {
      print('The internet is not connected');
      return ConnectionFailure();
    }
  }

  Future<dynamic> fetchFileFromCache(BaseQuery query) async {
    var fileInfo =
        await GraphQLCacheManager.instance.getFileFromCache(query.toString());
    var file = fileInfo?.file;
    if ((await file?.exists()) ?? false)
      return json.decode(await file.readAsString());
  }

  Future<dynamic> fetchFileFromInternet(BaseQuery query) async {
    var fileInfo =
        await GraphQLCacheManager.instance.downloadFile(query.toString());
    // print("\n.\n..\n.\n..\n.\n..\n.\n..\n.\n..\n.\n..\n.\n..\n.\n..\n");
    var file = fileInfo.file;
    // print((await file?.readAsString()) ?? "---");
    if ((await file?.exists()) ?? false)
      return jsonDecode(await file.readAsString());
  }

  Stream<FetchData> fetchfirstFromCache(BaseQuery query) async* {
    try {
      var data = await fetchFileFromCache(query);
      // print("Cache: $data");
      if (data != null) yield FetchDataFromCache(data["viewer"]);
    } catch (e) {
      print("Ex-fetchfirstFromCache, Cache: $e");
    } finally {
      var data = await fetchFileFromInternet(query);
      // print("Internet: $data");
      if (data != null) yield FetchDataFromInternet(data["viewer"]);
    }
  }
}

abstract class FetchData {
  final data;

  FetchData(this.data);
}

class FetchDataFromCache extends FetchData {
  FetchDataFromCache(data) : super(data);
}

class FetchDataFromInternet extends FetchData {
  FetchDataFromInternet(data) : super(data);
}
