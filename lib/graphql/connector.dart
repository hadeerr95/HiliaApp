import 'package:app/config.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'auth_util.dart';

class GraphQL {
  static GraphQL _instance;

  static GraphQL get instance {
    if (_instance != null) return _instance;
    return GraphQL();
  }

  Future<QueryResult> query(QueryOptions options) async {
    return await GraphQL.instance.client.query(options);
  }

  Future<QueryResult> mutate(MutationOptions options) async {
    return await GraphQL.instance.client.mutate(options);
  }

  final GraphQLClient _client = GraphQLClient(
    cache: InMemoryCache(),
    link: SessionAuthLink().concat(HttpLink(
      uri: ServerUrl + '/graphql',
    )),
  );
  GraphQLClient get client => _client;
}
