import 'package:geolocator/geolocator.dart';
import 'package:graphql/client.dart';
import 'package:meta/meta.dart';

abstract class BaseRemoteDataSource {
  final GraphQLClient graphQLClient;

  BaseRemoteDataSource({
    @required this.graphQLClient,
  });

  Future<QueryResult> performMutation(
    String mutation,
    Map<String, dynamic> variables,
  ) async {
    final MutationOptions mutationOptions = MutationOptions(
      documentNode: gql(mutation),
      variables: variables,
      fetchPolicy: FetchPolicy.noCache,
    );
    return await graphQLClient.mutate(mutationOptions);
  }

  Future<QueryResult> performQuery(
    String query,
    Map<String, dynamic> variables,
    bool shouldCache,
  ) async {
    final QueryOptions queryOptions = QueryOptions(
      documentNode: gql(query),
      variables: variables,
      fetchPolicy: shouldCache ? FetchPolicy.cacheFirst : FetchPolicy.noCache,
    );
    return await graphQLClient.query(queryOptions);
  }
}
