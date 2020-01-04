import 'dart:io';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:student_art_collection/core/data/model/school_model.dart';
import 'package:student_art_collection/core/domain/entity/school.dart';
import 'package:student_art_collection/core/error/exception.dart';
import 'package:student_art_collection/core/util/api_constants.dart';
import 'package:student_art_collection/features/list_art/data/data_source/mutation.dart';
import 'package:student_art_collection/features/list_art/data/data_source/query.dart';
import 'package:student_art_collection/features/list_art/data/mock_data.dart';
import 'package:student_art_collection/features/list_art/domain/usecase/login_school.dart';
import 'package:student_art_collection/features/list_art/domain/usecase/register_new_school.dart';

abstract class SchoolRemoteDataSource {
  Future<School> registerNewSchool(SchoolToRegister schoolToRegister);

  Future<School> loginSchool(String uid);
}

class GraphQLSchoolRemoteDataSource implements SchoolRemoteDataSource {
  final GraphQLClient client;

  GraphQLSchoolRemoteDataSource({this.client});

  @override
  Future<School> loginSchool(String uid) async {
    final QueryOptions queryOptions = QueryOptions(
      documentNode: gql(GET_SCHOOL_QUERY),
      variables: <String, dynamic>{
        'id': 1,
      },
    );
    final QueryResult result = await client.query(queryOptions);
    return handleQueryResult(result);
  }

  @override
  Future<School> registerNewSchool(SchoolToRegister schoolToRegister) async {
    final MutationOptions options = MutationOptions(
      documentNode: gql(ADD_SCHOOL_MUTATION),
      variables: <String, dynamic>{
        'schoolId': schoolToRegister.schoolId,
        'schoolName': schoolToRegister.schoolName,
        'email': schoolToRegister.email,
        'address': schoolToRegister.address,
        'city': schoolToRegister.city,
        'zipcode': schoolToRegister.zipcode
      },
    );
    final QueryResult result = await client.mutate(options);
    return handleQueryResult(result);
  }

  Future<School> handleQueryResult(QueryResult result) async {
    if (result.hasException) {
      throw ServerException();
    }
    final school = SchoolModel.fromJson(result.data["school"]);
    return school;
  }
}
