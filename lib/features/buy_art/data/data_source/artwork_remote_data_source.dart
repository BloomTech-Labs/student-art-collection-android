import 'package:graphql/client.dart';
import 'package:student_art_collection/core/data/model/artwork_model.dart';
import 'package:student_art_collection/core/domain/entity/artwork.dart';
import 'package:student_art_collection/core/error/exception.dart';
import 'package:student_art_collection/features/buy_art/data/data_source/query.dart';

abstract class ArtworkRemoteDataSource{

  /// Throws a [ServerException] for all error codes
  Future <List<ArtworkModel>> getAllArtwork();

  /// Throws a [ServerException] for all error codes
  Future <ArtworkModel> getArtworkById(int id);
}

class GraphQLArtworkRemoteDataSource implements ArtworkRemoteDataSource{
  final GraphQLClient client;

  GraphQLArtworkRemoteDataSource({this.client});

  @override
  Future<List<ArtworkModel>> getAllArtwork() async {
    final QueryOptions queryOptions = QueryOptions(
      documentNode: gql(GET_ALL_ARTWORK_FOR_BUYER),
    );
    final QueryResult result  = await client.query(queryOptions);
    if(result.hasException){
      throw ServerException();
    }

    //Todo: Untested will need revision
    final artworkList = result.data["image_url"];

    return artworkList;
  }

  @override
  Future<ArtworkModel> getArtworkById(int id) {
    // TODO: implement getArtworkById
    return null;
  }



}