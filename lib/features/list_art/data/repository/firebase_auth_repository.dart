import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:student_art_collection/core/domain/entity/school.dart';
import 'package:student_art_collection/core/error/exception.dart';
import 'package:student_art_collection/core/error/failure.dart';
import 'package:student_art_collection/core/network/network_info.dart';
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
  Future<Either<Failure, School>> loginSchool(Credentials credentials) {
    // TODO: implement loginSchool
    return null;
  }

  @override
  Future<Either<Failure, School>> registerNewSchool(
      SchoolToRegister school) async {
    if (await networkInfo.isConnected) {
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
        return Left(ServerFailure());
      }
    }
    return null;
  }
}
