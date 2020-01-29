import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:student_art_collection/core/domain/entity/school.dart';
import 'package:student_art_collection/core/error/exception.dart';
import 'package:student_art_collection/core/error/failure.dart';
import 'package:student_art_collection/core/network/network_info.dart';
import 'package:student_art_collection/core/util/error.dart';
import 'package:student_art_collection/features/list_art/data/data_source/school_local_data_source.dart';
import 'package:student_art_collection/features/list_art/data/data_source/school_remote_data_source.dart';
import 'package:student_art_collection/features/list_art/domain/repository/school_auth_repository.dart';
import 'package:student_art_collection/features/list_art/domain/usecase/login_school.dart';
import 'package:student_art_collection/features/list_art/domain/usecase/register_new_school.dart';
import 'package:meta/meta.dart';
import 'package:student_art_collection/features/list_art/domain/usecase/update_school_info.dart';

class FirebaseAuthRepository implements SchoolAuthRepository {
  final NetworkInfo networkInfo;
  final SchoolRemoteDataSource remoteDataSource;
  final FirebaseAuth firebaseAuth;
  final SchoolLocalDataSource localDataSource;

  FirebaseAuthRepository({
    @required this.remoteDataSource,
    @required this.networkInfo,
    @required this.firebaseAuth,
    @required this.localDataSource,
  });

  @override
  Future<Either<Failure, School>> loginSchool(Credentials credentials) async {
    if (await _isNetworkAvailable()) {
      try {
        final authResult = await firebaseAuth.signInWithEmailAndPassword(
            email: credentials.email, password: credentials.password);
        final school = await remoteDataSource.loginSchool(authResult.user.uid);
        if (credentials.shouldRemember) {
          localDataSource.storeSchool(school);
          localDataSource.storeCredentials(credentials);
        }
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
    final localClear = await localDataSource.logoutSchool();
    return signOutSuccess
        ? Right(localClear)
        : Left(FirebaseFailure(LOG_OUT_ERROR));
  }

  @override
  Future<Either<Failure, School>> loginSchoolOnReturn() async {
    try {
      final currentUser = await firebaseAuth.currentUser();
      if (currentUser == null)
        return Left(FirebaseFailure(LOGIN_ON_RETURN_ERROR));
      final school =
          await localDataSource.getCurrentlyStoredSchool(currentUser.uid);
      return Right(school);
    } on PlatformException catch (e) {
      return Left(FirebaseFailure(e.message));
    } on ServerException {
      firebaseAuth.signOut();
      return Left(ServerFailure());
    } on CacheException {
      firebaseAuth.signOut();
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, School>> updateSchoolInfo(
      SchoolToUpdate schoolToUpdate) async {
    if (await _isNetworkAvailable()) {
      try {
        final updatedSchool =
            await remoteDataSource.updateSchoolInfo(schoolToUpdate);
        return Right(updatedSchool);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
