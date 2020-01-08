import 'dart:io';

import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:student_art_collection/core/data/model/artwork_model.dart';
import 'package:student_art_collection/core/data/model/school_model.dart';
import 'package:student_art_collection/core/domain/entity/artwork.dart';
import 'package:student_art_collection/core/domain/entity/school.dart';
import 'package:student_art_collection/core/error/exception.dart';
import 'package:student_art_collection/core/util/api_constants.dart';
import 'package:student_art_collection/features/list_art/data/data_source/mutation.dart';
import 'package:student_art_collection/features/list_art/data/data_source/query.dart';
import 'package:student_art_collection/features/list_art/data/mock_data.dart';
import 'package:student_art_collection/features/list_art/domain/usecase/login_school.dart';
import 'package:student_art_collection/features/list_art/domain/usecase/register_new_school.dart';

abstract class SchoolRemoteDataSource {
  Future<School> registerNewSchool(SchoolToRegister schoolToRegister);

  Future<School> loginSchool(String uid);

  Future<List<Artwork>> getArtworksForSchool(int schoolId);

  Future<Artwork> uploadArtwork(Artwork artwork);
}

class GraphQLSchoolRemoteDataSource implements SchoolRemoteDataSource {
  final GraphQLClient client;

  GraphQLSchoolRemoteDataSource({this.client});

  @override
  Future<School> loginSchool(String uid) async {
    final QueryOptions queryOptions = QueryOptions(
      documentNode: gql(GET_SCHOOL_QUERY),
      variables: <String, dynamic>{
        'school_id': uid,
      },
    );
    final QueryResult result = await client.query(queryOptions);
    return handleAuthResult(result, "schoolBySchoolId");
  }

  @override
  Future<School> registerNewSchool(SchoolToRegister schoolToRegister) async {
    final MutationOptions options = MutationOptions(
      documentNode: gql(ADD_SCHOOL_MUTATION),
      variables: <String, dynamic>{
        'schoolId': schoolToRegister.schoolId,
        'schoolName': schoolToRegister.schoolName,
        'email': schoolToRegister.email,
        'address': schoolToRegister.address,
        'city': schoolToRegister.city,
        'zipcode': schoolToRegister.zipcode
      },
    );
    final QueryResult result = await client.mutate(options);
    return handleAuthResult(result, "school");
  }

  Future<School> handleAuthResult(QueryResult result, String key) async {
    if (result.hasException) {
      throw ServerException();
    }
    final school = SchoolModel.fromJson(result.data[key]);
    return school;
  }

  @override
  Future<List<Artwork>> getArtworksForSchool(int schoolId) async {
    final QueryOptions options = QueryOptions(
        documentNode: gql(GET_ARTWORK_FOR_SCHOOL),
        variables: <String, dynamic>{
          'school_id': 1,
        });
    final QueryResult result = await client.query(options);
    return convertResultToArtworks(result);
  }

  List<Artwork> convertResultToArtworks(QueryResult result) {
    return [
      Artwork(price: 25, schoolId: 1, artId: 1, images: [
        Image(imageUrl: "https://picsum.photos/600/900", imageId: 1, artId: 1)
      ]),
      Artwork(price: 25, schoolId: 1, artId: 1, images: [
        Image(imageUrl: "https://picsum.photos/601/900", imageId: 1, artId: 1)
      ]),
      Artwork(price: 25, schoolId: 1, artId: 1, images: [
        Image(imageUrl: "https://picsum.photos/602/900", imageId: 1, artId: 1)
      ]),
      Artwork(price: 25, schoolId: 1, artId: 1, images: [
        Image(imageUrl: "https://picsum.photos/603/900", imageId: 1, artId: 1)
      ]),
      Artwork(price: 25, schoolId: 1, artId: 1, images: [
        Image(imageUrl: "https://picsum.photos/604/900", imageId: 1, artId: 1)
      ]),
      Artwork(price: 25, schoolId: 1, artId: 1, images: [
        Image(imageUrl: "https://picsum.photos/605/900", imageId: 1, artId: 1)
      ]),
      Artwork(price: 25, schoolId: 1, artId: 1, images: [
        Image(imageUrl: "https://picsum.photos/606/900", imageId: 1, artId: 1)
      ]),
      Artwork(price: 25, schoolId: 1, artId: 1, images: [
        Image(imageUrl: "https://picsum.photos/607/900", imageId: 1, artId: 1)
      ]),
      Artwork(price: 25, schoolId: 1, artId: 1, images: [
        Image(imageUrl: "https://picsum.photos/608/900", imageId: 1, artId: 1)
      ]),
      Artwork(price: 25, schoolId: 1, artId: 1, images: [
        Image(imageUrl: "https://picsum.photos/609/900", imageId: 1, artId: 1)
      ]),
      Artwork(price: 25, schoolId: 1, artId: 1, images: [
        Image(imageUrl: "https://picsum.photos/610/900", imageId: 1, artId: 1)
      ]),
      Artwork(price: 25, schoolId: 1, artId: 1, images: [
        Image(imageUrl: "https://picsum.photos/611/900", imageId: 1, artId: 1)
      ]),
      Artwork(price: 25, schoolId: 1, artId: 1, images: [
        Image(imageUrl: "https://picsum.photos/612/900", imageId: 1, artId: 1)
      ]),
    ];
  }

  @override
  Future<Artwork> uploadArtwork(Artwork artwork) {
    // TODO: implement uploadArtwork
    return null;
  }
}
