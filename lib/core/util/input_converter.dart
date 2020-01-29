import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:student_art_collection/core/domain/entity/artwork.dart';
import 'package:student_art_collection/core/domain/entity/school.dart';
import 'package:student_art_collection/core/error/failure.dart';
import 'package:student_art_collection/core/presentation/bloc/base_artwork_filter_type.dart';
import 'package:student_art_collection/features/buy_art/domain/usecase/get_all_artwork.dart';
import 'package:student_art_collection/features/list_art/domain/usecase/login_school.dart';
import 'package:student_art_collection/features/list_art/domain/usecase/register_new_school.dart';
import 'package:student_art_collection/features/list_art/domain/usecase/update_school_info.dart';
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
    if (!checkNullOrEmpty(email) ||
        !checkNullOrEmpty(password) ||
        !checkNullOrEmpty(verifyPassword) ||
        !checkNullOrEmpty(schoolName) ||
        !checkNullOrEmpty(address) ||
        !checkNullOrEmpty(city) ||
        !checkNullOrEmpty(zipcode)) {
      return Left(
          UserInputFailure(message: 'Please make sure no fields are empty.'));
    } else if (password != verifyPassword) {
      return Left(UserInputFailure(message: 'Your passwords do not match.'));
    } else if (password.toString().length < 8 ||
        password.toString().length > 64) {
      return Left(UserInputFailure(
          message: 'Password should be between 8 and 64 characters.'));
    }
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

  Either<UserInputFailure, SchoolToUpdate> updateInfoToSchool(
      {email: String,
      id: int,
      schoolName: String,
      address: String,
      city: String,
      zipcode: String,
      state: String}) {
    if (!checkNullOrEmpty(schoolName) ||
        !checkNullOrEmpty(address) ||
        !checkNullOrEmpty(city) ||
        !checkNullOrEmpty(zipcode)) {
      return Left(
          UserInputFailure(message: 'Please make sure no fields are empty.'));
    } else {
      return Right(SchoolToUpdate(
        email: email,
        id: id,
        state: state,
        schoolName: schoolName,
        address: address,
        city: city,
        zipcode: zipcode,
      ));
    }
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
    bool zipCode;
    int category;
    if (filterTypes != null) {
      FilterTypeCategory categoryFilter = filterTypes['category'];
      if (categoryFilter != null && categoryFilter.category != null) {
        category = categoryFilter.category;
      }
      FilterTypeSearch searchFilter = filterTypes['search'];
      if (searchFilter != null && checkNullOrEmpty(searchFilter.searchQuery)) {
        searchQuery = searchFilter.searchQuery;
      }
      FilterTypeZipCode zipcodeFilter = filterTypes['zipcode'];
      if (zipcodeFilter != null && zipcodeFilter.zipcode != null) {
        zipCode = zipcodeFilter.zipcode;
      }
    }
    return Right(SearchFilters(
        searchQuery: searchQuery, zipcode: zipCode, category: category));
  }
}
