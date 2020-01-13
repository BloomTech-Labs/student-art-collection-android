import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_art_collection/core/domain/entity/school.dart';
import 'package:meta/meta.dart';
import 'package:student_art_collection/core/error/exception.dart';
import 'package:student_art_collection/core/util/entity_constants.dart';
import 'package:student_art_collection/features/list_art/domain/usecase/login_school.dart';

abstract class SchoolLocalDataSource {
  Future<School> getCurrentlyStoredSchool(String uid);

  Future<bool> storeSchool(School schoolToStore);

  Future<bool> storeCredentials(Credentials credentials);
}

class SharedPrefsLocalDataSource implements SchoolLocalDataSource {
  final SharedPreferences sharedPrefs;

  SharedPrefsLocalDataSource({
    @required this.sharedPrefs,
  });

  @override
  Future<School> getCurrentlyStoredSchool(String uid) async {
    final schoolUid = sharedPrefs.getString(
        LOCAL_STORAGE_SCHOOL_UID ?? LOCAL_STORAGE_DEFAULT_RESPONSE_STRING);
    if (schoolUid != uid) {
      throw CacheException();
    }
    final completableSchool = Completer<School>();
    final id = sharedPrefs
        .getInt(LOCAL_STORAGE_SCHOOL_ID ?? LOCAL_STORAGE_DEFAULT_RESPONSE_INT);
    final name = sharedPrefs.getString(
        LOCAL_STORAGE_SCHOOL_NAME ?? LOCAL_STORAGE_DEFAULT_RESPONSE_STRING);
    final email = sharedPrefs.getString(
        LOCAL_STORAGE_SCHOOL_EMAIL ?? LOCAL_STORAGE_DEFAULT_RESPONSE_STRING);
    final address = sharedPrefs.getString(
        LOCAL_STORAGE_SCHOOL_ADDRESS ?? LOCAL_STORAGE_DEFAULT_RESPONSE_STRING);
    final city = sharedPrefs.getString(
        LOCAL_STORAGE_SCHOOL_CITY ?? LOCAL_STORAGE_DEFAULT_RESPONSE_STRING);
    final state = sharedPrefs.getString(
        LOCAL_STORAGE_SCHOOL_STATE ?? LOCAL_STORAGE_DEFAULT_RESPONSE_STRING);
    final zipcode = sharedPrefs.getString(
        LOCAL_STORAGE_SCHOOL_ZIPCODE ?? LOCAL_STORAGE_DEFAULT_RESPONSE_STRING);
    final school = School(
      id: id,
      schoolId: uid,
      schoolName: name,
      email: email,
      address: address,
      city: city,
      state: state,
      zipcode: zipcode,
    );
    completableSchool.complete(school);
    return completableSchool.future;
  }

  @override
  Future<bool> storeSchool(School schoolToStore) {
    final completableSchool = Completer<bool>();
    sharedPrefs.setInt(LOCAL_STORAGE_SCHOOL_ID, schoolToStore.id);
    sharedPrefs.setString(LOCAL_STORAGE_SCHOOL_UID, schoolToStore.schoolId);
    sharedPrefs.setString(LOCAL_STORAGE_SCHOOL_NAME, schoolToStore.schoolName);
    sharedPrefs.setString(LOCAL_STORAGE_SCHOOL_EMAIL, schoolToStore.email);
    sharedPrefs.setString(LOCAL_STORAGE_SCHOOL_ADDRESS, schoolToStore.address);
    sharedPrefs.setString(LOCAL_STORAGE_SCHOOL_CITY, schoolToStore.city);
    sharedPrefs.setString(LOCAL_STORAGE_SCHOOL_STATE, schoolToStore.state);
    sharedPrefs.setString(LOCAL_STORAGE_SCHOOL_ZIPCODE, schoolToStore.zipcode);
    completableSchool.complete(true);
    return completableSchool.future;
  }

  Future<bool> storeCredentials(Credentials credentials) {
    final completable = Completer<bool>();
    sharedPrefs.setString(LOCAL_STORAGE_USER_EMAIL, credentials.email);
    sharedPrefs.setString(LOCAL_STORAGE_USER_PASSWORD, credentials.password);
    completable.complete(true);
    return completable.future;
  }
}
