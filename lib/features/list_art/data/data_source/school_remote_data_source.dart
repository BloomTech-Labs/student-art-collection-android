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
import 'package:student_art_collection/features/list_art/domain/usecase/delete_artwork.dart';
import 'package:student_art_collection/features/list_art/domain/usecase/login_school.dart';
import 'package:student_art_collection/features/list_art/domain/usecase/register_new_school.dart';
import 'package:student_art_collection/features/list_art/domain/usecase/upload_artwork.dart';
import 'package:student_art_collection/features/list_art/domain/usecase/upload_image.dart';

abstract class SchoolRemoteDataSource {
  Future<School> registerNewSchool(SchoolToRegister schoolToRegister);

  Future<School> loginSchool(String uid);

  Future<List<Artwork>> getArtworksForSchool(int schoolId);

  Future<Artwork> uploadArtwork(ArtworkToUpload artwork);

  Future<Artwork> updateArtwork(ArtworkToUpload artwork);

  Future<ReturnedImageUrl> hostImage(File file);

  Future<ArtworkToDeleteId> deleteArtwork(int id);
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
    if (result.hasException) {
      throw ServerException();
    }
    return handleAuthResult(result, 'action');
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
    if (result.hasException) {
      throw ServerException(message: result.exception.graphqlErrors[0].message);
    }
    final Artwork savedArtwork = convertResultToArtwork(result, 'action');
    final uploadedImages =
        await uploadImages(savedArtwork.artId, artworkToUpload.imagesToUpload);
    uploadedImages.forEach((image) {
      savedArtwork.images.add(image);
    });
    return savedArtwork;
  }

  @override
  Future<ReturnedImageUrl> hostImage(File file) async {
    final response = await cloudinaryClient.uploadImage(file.path);
    return ReturnedImageUrl(imageUrl: response.url);
  }

  @override
  Future<Artwork> updateArtwork(ArtworkToUpload artworkToUpdate) async {
    await deleteImages(artworkToUpdate.imagesToDelete);
    final MutationOptions options = MutationOptions(
        documentNode: gql(UPDATE_ARTWORK_MUTATION),
        variables: <String, dynamic>{
          'id': artworkToUpdate.artworkToCompare.artId,
          'price': artworkToUpdate.price,
          'sold': artworkToUpdate.sold,
          'title': artworkToUpdate.title,
          'artist_name': artworkToUpdate.artistName,
          'description': artworkToUpdate.description,
        });
    final QueryResult result = await client.mutate(options);
    if (result.hasException) throw ServerException();
    final Artwork updatedArtwork = convertResultToArtwork(result, 'action');
    final List<Image> uploadedImages = await uploadImages(
        updatedArtwork.artId, artworkToUpdate.imagesToUpload);
    uploadedImages.forEach((image) {
      updatedArtwork.images.add(image);
    });
    return updatedArtwork;
  }

  Future deleteImages(List<Image> imagesToDelete) async {
    await Future.forEach(imagesToDelete, (image) async {
      final MutationOptions options = MutationOptions(
          documentNode: gql(DELETE_IMAGE_FROM_ARTWORK),
          variables: <String, dynamic>{
            'id': image.imageId,
          });
      final QueryResult result = await client.mutate(options);
      if (result.hasException) {
        throw ServerException();
      }
    });
    return null;
  }

  Future<List<Image>> uploadImages(
      int artId, List<String> imagesToUpload) async {
    List<Image> savedImages = List();
    await Future.forEach(imagesToUpload, (imageUrl) async {
      final MutationOptions imageOptions = MutationOptions(
          documentNode: gql(ADD_IMAGE_TO_ARTWORK_MUTATION),
          variables: <String, dynamic>{'art_id': artId, 'image_url': imageUrl});
      final QueryResult imageResult = await client.mutate(imageOptions);
      if (imageResult.hasException) {
        throw ServerException();
      }
      savedImages.add(ImageModel.fromJson(imageResult.data['action']));
    });
    return savedImages;
  }

  @override
  Future<ArtworkToDeleteId> deleteArtwork(int id) async {
    final MutationOptions options = MutationOptions(
        documentNode: gql(DELETE_ARTWORK),
        variables: <String, dynamic>{
          'id': id,
        });
    final QueryResult deleteResult = await client.mutate(options);
    if (deleteResult.hasException) {
      throw ServerException();
    }
    final int deletedId = int.parse(deleteResult.data['action']['id']);
    return ArtworkToDeleteId(artId: deletedId);
  }
}
