import 'package:flutter/material.dart';
import 'package:graphql/client.dart';
import 'package:student_art_collection/core/domain/entity/artwork.dart';
import 'package:student_art_collection/core/error/exception.dart';
import 'package:student_art_collection/core/util/functions.dart';
import 'package:student_art_collection/features/buy_art/data/data_source/query.dart';
import 'package:student_art_collection/features/buy_art/domain/entity/contact_form.dart';

abstract class BuyerRemoteDataSource{

  /// Throws a [ServerException] for all error codes
  Future <List<Artwork>> getAllArtwork();

  Future <bool> contactFormConfirmation({@required ContactForm contactForm});
}

class GraphQLBuyerRemoteDataSource implements BuyerRemoteDataSource{
  final GraphQLClient client;

  GraphQLBuyerRemoteDataSource({this.client});

  @override
  Future<List<Artwork>> getAllArtwork() async {
    final QueryOptions queryOptions = QueryOptions(
      documentNode: gql(GET_ALL_ARTWORK_FOR_BUYER),
    );
    final QueryResult result  = await client.query(queryOptions);
    if(result.hasException){
      throw ServerException();
    }
    return convertResultToArtworkList(result, "allArts");
  }

  @override
  Future<bool> contactFormConfirmation({@required ContactForm contactForm}) {
    // TODO: implement contactFormConfirmation
    return null;
  }



}