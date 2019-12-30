import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:student_art_collection/core/domain/entity/school.dart';
import 'package:student_art_collection/core/error/exception.dart';
import 'package:student_art_collection/core/error/failure.dart';
import 'package:student_art_collection/core/network/network_info.dart';
import 'package:student_art_collection/core/util/error.dart';
import 'package:student_art_collection/features/list_art/data/data_source/artco_remote_data_source.dart';
import 'package:student_art_collection/features/list_art/domain/repository/school_auth_repository.dart';
import 'package:student_art_collection/features/list_art/domain/usecase/login_school.dart';
import 'package:student_art_collection/features/list_art/domain/usecase/register_new_school.dart';
import 'package:meta/meta.dart';

class FirebaseAuthRepository implements SchoolAuthRepository {
  final NetworkInfo networkInfo;
  final ArtcoRemoteDataSource remoteDataSource;
  final FirebaseAuth firebaseAuth;

  FirebaseAuthRepository(
      {@required this.remoteDataSource,
      @required this.networkInfo,
      @required this.firebaseAuth});

  @override
  Future<Either<Failure, School>> loginSchool(Credentials credentials) async {
    if (await _isNetworkAvailable()) {
      try {
        final authResult = await firebaseAuth.signInWithEmailAndPassword(
            email: credentials.email, password: credentials.password);
        final school = await remoteDataSource.loginSchool(authResult.user.uid);
        return Right(school);
      } on PlatformException catch (e) {
        return Left(FirebaseFailure(e.message));
      } on ServerException {
        firebaseAuth.signOut();
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  Future<bool> _isNetworkAvailable() {
    return networkInfo.isConnected;
  }

  @override
  Future<Either<Failure, School>> registerNewSchool(
      SchoolToRegister school) async {
    if (await _isNetworkAvailable()) {
      try {
        final authResult = await firebaseAuth.createUserWithEmailAndPassword(
            email: school.email, password: school.password);
        school.schoolId = authResult.user.uid;
        final registeredSchool =
            await remoteDataSource.registerNewSchool(school);
        return Right(registeredSchool);
      } on PlatformException catch (e) {
        return Left(FirebaseFailure(e.message));
      } on ServerException {
        final user = await firebaseAuth.currentUser();
        user.delete();
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> logoutSchool() async {
    bool signOutSuccess;
    await firebaseAuth.signOut().then((value) {
      signOutSuccess = true;
    }, onError: (error) {
      signOutSuccess = false;
    });
    return signOutSuccess
        ? Right(signOutSuccess)
        : Left(FirebaseFailure(LOG_OUT_ERROR));
  }

  @override
  Future<Either<Failure, School>> loginSchoolOnReturn() async {
    try {
      final currentUser = await firebaseAuth.currentUser();
      if (currentUser == null)
        return Left(FirebaseFailure(LOGIN_ON_RETURN_ERROR));
      final school = await remoteDataSource.loginSchool(currentUser.uid);
      return Right(school);
    } on PlatformException catch (e) {
      return Left(FirebaseFailure(e.message));
    } on ServerException {
      firebaseAuth.signOut();
      return Left(ServerFailure());
    }
  }
}
