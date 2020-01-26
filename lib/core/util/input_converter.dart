import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:student_art_collection/core/domain/entity/artwork.dart';
import 'package:student_art_collection/core/domain/entity/school.dart';
import 'package:student_art_collection/core/error/failure.dart';
import 'package:student_art_collection/core/presentation/bloc/base_artwork_filter_type.dart';
import 'package:student_art_collection/features/buy_art/domain/usecase/get_all_artwork.dart';
import 'package:student_art_collection/features/list_art/domain/usecase/login_school.dart';
import 'package:student_art_collection/features/list_art/domain/usecase/register_new_school.dart';
import 'package:student_art_collection/features/list_art/domain/usecase/upload_artwork.dart';

class InputConverter {
  Either<UserInputFailure, Credentials> loginInfoToCredentials({
    email: String,
    password: String,
    shouldRemember: bool,
  }) {
    if (!checkNullOrEmpty(email) || !checkNullOrEmpty(password)) {
      return Left(
          UserInputFailure(message: 'Please make sure fields are not empty'));
    }
    return Right(Credentials(
      email: email,
      password: password,
      shouldRemember: shouldRemember,
    ));
  }

  Either<UserInputFailure, SchoolToRegister> registrationInfoToSchool({
    email: String,
    password: String,
    verifyPassword: String,
    schoolName: String,
    address: String,
    city: String,
    state: String,
    zipcode: String,
  }) {
    return Right(SchoolToRegister(
      email: email,
      password: password,
      schoolName: schoolName,
      address: address,
      city: city,
      state: state,
      zipcode: zipcode,
    ));
  }

  Either<ArtworkInputFailure, ArtworkToUpload> uploadInfoToArtwork(
    int schoolId,
    int category,
    int price,
    bool sold,
    String title,
    String artistName,
    String description,
    List<String> imagesToUpload,
  ) {
    return Right(ArtworkToUpload(
      schoolId: schoolId,
      category: category,
      price: price,
      sold: sold,
      title: title,
      artistName: artistName,
      description: description,
      imagesToUpload: imagesToUpload,
    ));
  }

  Either<ArtworkInputFailure, ArtworkToUpload> updateInfoToArtwork(
    Artwork artwork,
    int category,
    int price,
    bool sold,
    String title,
    String artistName,
    String description,
    List<String> imagesToUpload,
  ) {
    List<Image> imagesToDelete = List();
    artwork.images.forEach((image) {
      if (!imagesToUpload.contains(image.imageUrl)) {
        imagesToDelete.add(image);
      }
      if (imagesToUpload.contains(image.imageUrl)) {
        imagesToUpload.remove(image.imageUrl);
      }
    });
    return Right(ArtworkToUpload(
      artworkToCompare: artwork,
      category: category,
      price: price,
      sold: sold,
      title: title,
      artistName: artistName,
      description: description,
      imagesToUpload: imagesToUpload,
      imagesToDelete: imagesToDelete,
    ));
  }

  bool checkNullOrEmpty(String stringToValidate) {
    if (['', null].contains(stringToValidate)) {
      return false;
    }
    return true;
  }

  Either<SearchFiltersFailure, SearchFilters> filterTypesToFilters(
    Map<String, FilterType> filterTypes,
  ) {
    String searchQuery;
    String zipCode;
    int category;
    if (filterTypes != null) {
      FilterTypeZipCode zipcodeFilter = filterTypes['zipcode'];
      if (zipcodeFilter != null && checkNullOrEmpty(zipcodeFilter.zipcode)) {
        zipCode = zipcodeFilter.zipcode;
      }
      FilterTypeCategory categoryFilter = filterTypes['category'];
      if (categoryFilter != null && categoryFilter.category != null) {
        category = categoryFilter.category;
      }
      FilterTypeSearch searchFilter = filterTypes['search'];
      if (searchFilter != null && checkNullOrEmpty(searchFilter.searchQuery)) {
        searchQuery = searchFilter.searchQuery;
      }
    }
    return Right(SearchFilters(
        searchQuery: searchQuery, zipcode: zipCode, category: category));
  }
}
