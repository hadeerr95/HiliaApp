part of 'service.dart';

class ApiService extends BaseService {
  static ApiService _instance;

  static ApiService get instance {
    if (_instance != null) {
      return _instance;
    } else {
      _instance = ApiService();
      return _instance;
    }
  }

  Future<SaleOrder> checkout(SaleOrder order) async {
    try {
      CheckoutMutation checkoutMutation =
          CheckoutMutation(muteOrderFragment, order);
      print(checkoutMutation.variables);
      MutationOptions queryOptions = MutationOptions(
          documentNode: gql(checkoutMutation.mutation),
          variables: checkoutMutation.variables);
      QueryResult result = await GraphQL.instance.mutate(queryOptions);
      if (result.hasException) print(result.exception);
      if (result.data != null) {
        print('Create Order Succeeded');
        return SaleOrder.fromJson(result.data['order']);
      } else {
        throw result.exception;
      }
    } catch (e) {
      throw await exceptionHandler(e);
    }
  }

  Future<Partner> createPartner(Partner partner) async {
    try {
      CreatePartnerMutation createPartnerMutation = CreatePartnerMutation(
        basePartnerFragment,
        partner,
      );
      print(createPartnerMutation.variables);
      MutationOptions queryOptions = MutationOptions(
          documentNode: gql(createPartnerMutation.mutation),
          variables: createPartnerMutation.variables);
      QueryResult result = await GraphQL.instance.mutate(queryOptions);
      if (result.data != null) {
        print('Create Order Succeeded');
        return Partner.fromJson(result.data['partner']);
      } else {
        throw result.exception;
      }
    } catch (e) {
      throw await exceptionHandler(e);
    }
  }

  Future<SaleOrder> getOrder(int id) async {
    try {
      OrderQuery query = OrderQuery(
        muteOrderFragment,
        id,
      );
      QueryOptions queryOptions = QueryOptions(
          documentNode: gql(query.query), variables: query.variables);
      QueryResult result = await GraphQL.instance.query(queryOptions);
      if (result.data != null) {
        print('Update Order Succeeded');
        return SaleOrder.fromJson(result.data['viewer']['order']);
      } else {
        throw result.exception;
      }
    } catch (e) {
      throw await exceptionHandler(e);
    }
  }

  Future<Partner> updatePartner(Partner partner) async {
    try {
      UpdatePartnerMutation updatePartnerMutation = UpdatePartnerMutation(
        basePartnerFragment,
        partner.id,
        partner,
      );
      print(updatePartnerMutation.variables);
      MutationOptions queryOptions = MutationOptions(
          documentNode: gql(updatePartnerMutation.mutation),
          variables: updatePartnerMutation.variables);
      QueryResult result = await GraphQL.instance.mutate(queryOptions);
      if (result.data != null) {
        print('Update Order Succeeded');
        return Partner.fromJson(result.data['partner']);
      } else {
        throw result.exception;
      }
    } catch (e) {
      throw await exceptionHandler(e);
    }
  }
}
