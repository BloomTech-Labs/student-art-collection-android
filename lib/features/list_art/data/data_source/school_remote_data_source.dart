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
        SCHOOL_SCHOOL_ID: uid,
      },
      false,
    );
    return handleAuthResult(result, LOGIN_SCHOOL_QUERY_KEY);
  }

  @override
  Future<School> registerNewSchool(SchoolToRegister schoolToRegister) async {
    final QueryResult result = await performMutation(
      ADD_SCHOOL_MUTATION,
      <String, dynamic>{
        SCHOOL_SCHOOL_ID: schoolToRegister.schoolId,
        SCHOOL_NAME: schoolToRegister.schoolName,
        SCHOOL_EMAIL: schoolToRegister.email,
        SCHOOL_ADDRESS: schoolToRegister.address,
        SCHOOL_CITY: schoolToRegister.city,
        SCHOOL_ZIPCODE: schoolToRegister.zipcode
      },
    );
    return handleAuthResult(result, SCHOOL_MUTATION_RESULT_KEY);
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
        SCHOOL_SCHOOL_ID: schoolId,
      },
      true,
    );
    return convertResultToArtworkList(result, 'artBySchool');
  }

  @override
  Future<Artwork> uploadArtwork(ArtworkToUpload artworkToUpload) async {
    final QueryResult result = await performMutation(
      ADD_ARTWORK_MUTATION,
      {
        SCHOOL_SCHOOL_ID: 2,
        ARTWORK_CATEGORY: artworkToUpload.category,
        ARTWORK_PRICE: artworkToUpload.price,
        ARTWORK_SOLD: artworkToUpload.sold,
        ARTWORK_TITLE: artworkToUpload.title,
        ARTWORK_ARTIST_NAME: artworkToUpload.artistName,
        ARTWORK_DESCRIPTION: artworkToUpload.description,
        IMAGE_URL: artworkToUpload.imagesToUpload[0],
      },
    );
    if (result.hasException) {
      throw ServerException(message: result.exception.graphqlErrors[0].message);
    }
    final Artwork savedArtwork =
        convertResultToArtwork(result, SCHOOL_MUTATION_RESULT_KEY);
    artworkToUpload.imagesToUpload.removeAt(0);
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
    final QueryResult result = await performMutation(
      UPDATE_ARTWORK_MUTATION,
      {
        ARTWORK_ID: artworkToUpdate.artworkToCompare.artId,
        ARTWORK_PRICE: artworkToUpdate.price,
        ARTWORK_SOLD: artworkToUpdate.sold,
        ARTWORK_TITLE: artworkToUpdate.title,
        ARTWORK_ARTIST_NAME: artworkToUpdate.artistName,
        ARTWORK_DESCRIPTION: artworkToUpdate.description,
        ARTWORK_CATEGORY: artworkToUpdate.category,
      },
    );
    if (result.hasException) throw ServerException();
    final Artwork updatedArtwork =
        convertResultToArtwork(result, SCHOOL_MUTATION_RESULT_KEY);
    final List<Image> uploadedImages = await uploadImages(
        updatedArtwork.artId, artworkToUpdate.imagesToUpload);
    uploadedImages.forEach((image) {
      updatedArtwork.images.add(image);
    });
    return updatedArtwork;
  }

  Future deleteImages(List<Image> imagesToDelete) async {
    await Future.forEach(imagesToDelete, (image) async {
      final QueryResult result = await performMutation(
        DELETE_IMAGE_FROM_ARTWORK,
        {
          IMAGE_ID: image.imageId,
        },
      );
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
        {ARTWORK_ID: artId, IMAGE_URL: imageUrl},
      );
      if (imageResult.hasException) {
        throw ServerException();
      }
      savedImages.add(
          ImageModel.fromJson(imageResult.data[SCHOOL_MUTATION_RESULT_KEY]));
    });
    return savedImages;
  }

  @override
  Future<ArtworkToDeleteId> deleteArtwork(int id) async {
    final QueryResult result = await performMutation(
      DELETE_ARTWORK,
      {
        ARTWORK_ID: id,
      },
    );
    if (result.hasException) {
      throw ServerException();
    }
    final int deletedId =
        int.parse(result.data[SCHOOL_MUTATION_RESULT_KEY][ARTWORK_ID]);
    return ArtworkToDeleteId(artId: deletedId);
  }
}
