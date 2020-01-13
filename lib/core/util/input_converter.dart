import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:student_art_collection/core/domain/entity/artwork.dart';
import 'package:student_art_collection/core/domain/entity/school.dart';
import 'package:student_art_collection/core/error/failure.dart';
import 'package:student_art_collection/features/list_art/domain/usecase/login_school.dart';
import 'package:student_art_collection/features/list_art/domain/usecase/register_new_school.dart';
import 'package:student_art_collection/features/list_art/domain/usecase/upload_artwork.dart';

class InputConverter {
  Either<UserInputFailure, Credentials> loginInfoToCredentials({
    email: String,
    password: String,
    shouldRemember: bool,
  }) {
    var i = 0;
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
}
