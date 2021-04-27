import 'dart:convert';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'graphql.dart';

class GraphQLCacheManager {
  static const key = 'graphQLCacheKey';
  static CacheManager instance = CacheManager(
    Config(
      key,
      stalePeriod: const Duration(days: 7),
      maxNrOfCacheObjects: 2000,
      repo: JsonCacheInfoRepository(databaseName: key),
      fileService: GraphQLFileService(),
    ),
  );
}

class GraphQLFileService extends FileService {
  @override
  Future<FileServiceResponse> get(String url,
      {Map<String, String> headers = const {}}) async {
    // GraphQLClient _client = GraphQL.instance.client;
    Map kw = Map();
    if (json.decode(url) is Map) kw = (json.decode(url) as Map);
    String query = kw["query"];
    Map variables = kw["variables"];
    QueryOptions options = QueryOptions(
      documentNode: gql(query),
      variables: variables,
    );
    final QueryResult queryResult = await GraphQL.instance.query(options);
    if (queryResult.data == null) {
      if (queryResult.hasException)
        throw queryResult.exception;
      else
        throw Exception("null data");
    }

    return QueryGetResult(
        queryResult, kw.containsKey('age') ? kw["age"] : null);
  }
}

class QueryGetResult implements FileServiceResponse {
  QueryGetResult(this._result, this._ageDurationBySeconds);

  final DateTime _receivedTime = DateTime.now();

  final QueryResult _result;
  final int _ageDurationBySeconds;

  @override
  int get statusCode => 200;

  @override
  Stream<List<int>> get content =>
      Stream.value(utf8.encode(jsonEncode(_result.data)));

  @override
  int get contentLength => json.encode(_result.data).length;

  @override
  DateTime get validTill {
    var ageDuration = const Duration(days: 7);
    if (_ageDurationBySeconds != null) {
      ageDuration = Duration(seconds: _ageDurationBySeconds);
    }

    return _receivedTime.add(ageDuration);
  }

  @override
  String get eTag => null;

  @override
  String get fileExtension {
    var fileExtension = '';
    return fileExtension;
  }
}
