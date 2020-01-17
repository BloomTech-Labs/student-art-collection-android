import 'dart:developer';
import 'dart:io';

import 'package:cloudinary_client/cloudinary_client.dart';
import 'package:cloudinary_client/models/CloudinaryResponse.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:student_art_collection/core/data/data_source/base_remote_data_source.dart';
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
import 'package:meta/meta.dart';

abstract class SchoolRemoteDataSource {
  Future<School> registerNewSchool(SchoolToRegister schoolToRegister);

  Future<School> loginSchool(String uid);

  Future<List<Artwork>> getArtworksForSchool(int schoolId);

  Future<Artwork> uploadArtwork(ArtworkToUpload artwork);

  Future<Artwork> updateArtwork(ArtworkToUpload artwork);

  Future<ReturnedImageUrl> hostImage(File file);

  Future<ArtworkToDeleteId> deleteArtwork(int id);
}

class GraphQLSchoolRemoteDataSource extends BaseRemoteDataSource
    implements SchoolRemoteDataSource {
  final CloudinaryClient cloudinaryClient;

  GraphQLSchoolRemoteDataSource({
    graphQLClient: GraphQLClient,
    this.cloudinaryClient,
  }) : super(graphQLClient: graphQLClient);

  @override
  Future<School> loginSchool(String uid) async {
    final QueryResult result = await performQuery(
      GET_SCHOOL_QUERY,
      <String, dynamic>{
        'school_id': uid,
      },
    );
    return handleAuthResult(result, "schoolBySchoolId");
  }

  @override
  Future<School> registerNewSchool(SchoolToRegister schoolToRegister) async {
    final QueryResult result = await performMutation(
      ADD_SCHOOL_MUTATION,
      <String, dynamic>{
        'schoolId': schoolToRegister.schoolId,
        'schoolName': schoolToRegister.schoolName,
        'email': schoolToRegister.email,
        'address': schoolToRegister.address,
        'city': schoolToRegister.city,
        'zipcode': schoolToRegister.zipcode
      },
    );
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
    final QueryResult result = await performQuery(
      GET_ARTWORK_FOR_SCHOOL,
      {
        'school_id': schoolId,
      },
    );
    return convertResultToArtworkList(result, 'artBySchool');
  }

  @override
  Future<Artwork> uploadArtwork(ArtworkToUpload artworkToUpload) async {
    final QueryResult result = await performMutation(
      ADD_ARTWORK_MUTATION,
      {
        'input': {
          'school_id': 2,
          'category': artworkToUpload.category,
          'price': artworkToUpload.price,
          'sold': artworkToUpload.sold,
          'title': artworkToUpload.title,
          'artist_name': artworkToUpload.artistName,
          'description': artworkToUpload.description,
          'image_url': artworkToUpload.imagesToUpload[0],
        }
      },
    );
    if (result.hasException) {
      throw ServerException(message: result.exception.graphqlErrors[0].message);
    }
    final Artwork savedArtwork = convertResultToArtwork(result, 'action');
    artworkToUpload.imagesToUpload.removeAt(0);
    final uploadedImages =
        await uploadImages(savedArtwork.artId, artworkToUpload.imagesToUpload);
    uploadedImages.forEach((image) {
      savedArtwork.images.add(image);
    });
    return savedArtwork;
  }

  MutationOptions getProdOptions(ArtworkToUpload artworkToUpload) {
    final MutationOptions options = MutationOptions(
        fetchPolicy: FetchPolicy.noCache,
        documentNode: gql(ADD_ARTWORK_MUTATION),
        variables: <String, dynamic>{
          'school_id': artworkToUpload.schoolId,
          'category': artworkToUpload.category,
          'price': artworkToUpload.price,
          'sold': artworkToUpload.sold,
          'title': artworkToUpload.title,
          'artist_name': artworkToUpload.artistName,
          'description': artworkToUpload.description,
          'image_url': artworkToUpload.imagesToUpload[0],
        });
    return options;
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
        fetchPolicy: FetchPolicy.noCache,
        documentNode: gql(UPDATE_ARTWORK_MUTATION),
        variables: <String, dynamic>{
          'id': artworkToUpdate.artworkToCompare.artId,
          'price': artworkToUpdate.price,
          'sold': artworkToUpdate.sold,
          'title': artworkToUpdate.title,
          'artist_name': artworkToUpdate.artistName,
          'description': artworkToUpdate.description,
          'category': artworkToUpdate.category,
        });
    final QueryResult result = await graphQLClient.mutate(options);
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
          fetchPolicy: FetchPolicy.noCache,
          documentNode: gql(DELETE_IMAGE_FROM_ARTWORK),
          variables: <String, dynamic>{
            'id': image.imageId,
          });
      final QueryResult result = await graphQLClient.mutate(options);
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
      final QueryResult imageResult = await performMutation(
        ADD_IMAGE_TO_ARTWORK_MUTATION,
        {'art_id': artId, 'image_url': imageUrl},
      );
      if (imageResult.hasException) {
        throw ServerException();
      }
      savedImages.add(ImageModel.fromJson(imageResult.data['action']));
    });
    return savedImages;
  }

  @override
  Future<ArtworkToDeleteId> deleteArtwork(int id) async {
    final QueryResult result = await performMutation(
      DELETE_ARTWORK,
      {
        'id': id,
      },
    );
    if (result.hasException) {
      throw ServerException();
    }
    final int deletedId = int.parse(result.data['action']['id']);
    return ArtworkToDeleteId(artId: deletedId);
  }
}
