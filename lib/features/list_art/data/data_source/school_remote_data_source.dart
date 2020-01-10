import 'dart:developer';
import 'dart:io';

import 'package:cloudinary_client/cloudinary_client.dart';
import 'package:cloudinary_client/models/CloudinaryResponse.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:student_art_collection/core/data/model/artwork_model.dart';
import 'package:student_art_collection/core/data/model/image_model.dart';
import 'package:student_art_collection/core/data/model/school_model.dart';
import 'package:student_art_collection/core/domain/entity/artwork.dart';
import 'package:student_art_collection/core/domain/entity/school.dart';
import 'package:student_art_collection/core/error/exception.dart';
import 'package:student_art_collection/core/util/api_constants.dart';
import 'package:student_art_collection/core/util/functions.dart';
import 'package:student_art_collection/features/list_art/data/data_source/mutation.dart';
import 'package:student_art_collection/features/list_art/data/data_source/query.dart';
import 'package:student_art_collection/features/list_art/data/mock_data.dart';
import 'package:student_art_collection/features/list_art/domain/usecase/login_school.dart';
import 'package:student_art_collection/features/list_art/domain/usecase/register_new_school.dart';
import 'package:student_art_collection/features/list_art/domain/usecase/upload_artwork.dart';

abstract class SchoolRemoteDataSource {
  Future<School> registerNewSchool(SchoolToRegister schoolToRegister);

  Future<School> loginSchool(String uid);

  Future<List<Artwork>> getArtworksForSchool(int schoolId);

  Future<Artwork> uploadArtwork(ArtworkToUpload artwork);
}

class GraphQLSchoolRemoteDataSource implements SchoolRemoteDataSource {
  final GraphQLClient client;
  final CloudinaryClient cloudinaryClient;

  GraphQLSchoolRemoteDataSource({
    this.client,
    this.cloudinaryClient,
  });

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
          'school_id': schoolId,
        });
    final QueryResult result = await client.query(options);
    return convertResultToArtworkList(result, 'artBySchool');
  }

  @override
  Future<Artwork> uploadArtwork(ArtworkToUpload artworkToUpload) async {
    final imagePaths = List<String>();
    for (File file in artworkToUpload.imagesToUpload) {
      imagePaths.add(file.path);
    }
    final response = await cloudinaryClient.uploadImages(imagePaths);
    final imageUrls = List<String>();
    response.forEach((CloudinaryResponse cReponse) {
      imageUrls.add(cReponse.url);
    });
    final MutationOptions options = MutationOptions(
        documentNode: gql(ADD_ARTWORK_MUTATION),
        variables: <String, dynamic>{
          'school_id': artworkToUpload.schoolId,
          'category': artworkToUpload.category,
          'price': artworkToUpload.price,
          'sold': artworkToUpload.sold,
          'title': artworkToUpload.title,
          'artist_name': artworkToUpload.artistName,
          'description': artworkToUpload.description,
        });
    final QueryResult result = await client.mutate(options);
    final Artwork savedArtwork = convertResultToArtwork(result, 'action');
    for (String imageUrl in imageUrls) {
      final imageToUpload = ImageToUpload(
        artId: savedArtwork.artId,
        imageUrl: imageUrl,
      );
      final MutationOptions imageOptions = MutationOptions(
          documentNode: gql(ADD_IMAGE_TO_ARTWORK_MUTATION),
          variables: <String, dynamic>{
            'art_id': savedArtwork.artId,
            'image_url': imageToUpload.imageUrl
          });
      final QueryResult imageResult = await client.mutate(imageOptions);
      savedArtwork.images.add(ImageModel.fromJson(imageResult.data['action']));
    }
    return savedArtwork;
  }
}
