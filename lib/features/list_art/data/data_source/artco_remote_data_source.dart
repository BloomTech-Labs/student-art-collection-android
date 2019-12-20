import 'dart:io';

import 'package:student_art_collection/core/data/model/school_model.dart';
import 'package:student_art_collection/core/domain/entity/school.dart';
import 'package:student_art_collection/features/list_art/data/mock_data.dart';
import 'package:student_art_collection/features/list_art/domain/usecase/login_school.dart';
import 'package:student_art_collection/features/list_art/domain/usecase/register_new_school.dart';

abstract class ArtcoRemoteDataSource {
  Future<School> registerNewSchool(SchoolToRegister schoolToRegister);

  Future<School> loginSchool(String uid);
}

class GraphQLRemoteDataSource implements ArtcoRemoteDataSource {
  @override
  Future<School> loginSchool(String uid) async {
    sleep(Duration(seconds: 3));
    return SchoolModel.fromJson(mockRegisteredSchool);
  }

  @override
  Future<School> registerNewSchool(SchoolToRegister schoolToRegister) async {
    sleep(Duration(seconds: 3));
    return SchoolModel.fromJson(mockRegisteredSchool);
  }
}
