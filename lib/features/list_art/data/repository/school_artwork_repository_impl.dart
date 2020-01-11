import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:student_art_collection/core/domain/entity/artwork.dart';
import 'package:student_art_collection/core/error/exception.dart';
import 'package:student_art_collection/core/error/failure.dart';
import 'package:student_art_collection/core/network/network_info.dart';
import 'package:student_art_collection/features/list_art/data/data_source/school_remote_data_source.dart';
import 'package:student_art_collection/features/list_art/domain/repository/school_artwork_repository.dart';
import 'package:student_art_collection/features/list_art/domain/usecase/get_all_school_art.dart';
import 'package:student_art_collection/features/list_art/domain/usecase/upload_artwork.dart';
import 'package:student_art_collection/features/list_art/domain/usecase/upload_image.dart';

class SchoolArtworkRepositoryImpl implements SchoolArtworkRepository {
  final NetworkInfo networkInfo;
  final SchoolRemoteDataSource remoteDataSource;

  SchoolArtworkRepositoryImpl({
    @required this.networkInfo,
    @required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<Artwork>>> getArtworkForSchool(
      SchoolId schoolId) async {
    if (await _isNetworkAvailable()) {
      try {
        final artworkResult =
            await remoteDataSource.getArtworksForSchool(schoolId.schoolId);
        return Right(artworkResult);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Artwork>> uploadArtwork(
      ArtworkToUpload artworkToUpload) async {
    if (await _isNetworkAvailable()) {
      try {
        final uploadedArtwork =
            await remoteDataSource.uploadArtwork(artworkToUpload);
        return Right(uploadedArtwork);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Artwork>> updateArtwork(
      ArtworkToUpload artworkToUpdate) async {
    if (await _isNetworkAvailable()) {
      try {
        final uploadedArtwork =
            await remoteDataSource.updateArtwork(artworkToUpdate);
        return Right(uploadedArtwork);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, ReturnedImageUrl>> hostImage(File file) async {
    if (await _isNetworkAvailable()) {
      try {
        final hostedImage = await remoteDataSource.hostImage(file);
        return Right(hostedImage);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  Future<bool> _isNetworkAvailable() {
    return networkInfo.isConnected;
  }
}
