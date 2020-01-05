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

class SchoolAuthRepositoryImpl implements SchoolArtworkRepository {
  final NetworkInfo networkInfo;
  final SchoolRemoteDataSource remoteDataSource;
  final FirebaseAuth firebaseAuth;

  SchoolAuthRepositoryImpl({
    @required this.networkInfo,
    @required this.remoteDataSource,
    @required this.firebaseAuth,
  });

  @override
  Future<Either<Failure, List<Artwork>>> getArtworkForSchool(
      SchoolId schoolId) async {
    if (await _isNetworkAvailable()) {
      try {} on ServerException {}
    }
    return null;
  }

  @override
  Future<Either<Failure, Artwork>> uploadArtwork(Artwork artwork) {
    // TODO: implement uploadArtwork
    return null;
  }

  Future<bool> _isNetworkAvailable() {
    return networkInfo.isConnected;
  }
}
