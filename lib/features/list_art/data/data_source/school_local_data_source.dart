import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_art_collection/core/domain/entity/school.dart';
import 'package:meta/meta.dart';
import 'package:student_art_collection/core/error/exception.dart';

abstract class SchoolLocalDataSource {
  Future<School> getCurrentlyStoredSchool(String uid);

  Future<bool> storeSchool(School schoolToStore);
}

class SharedPrefsLocalDataSource implements SchoolLocalDataSource {
  final SharedPreferences sharedPrefs;

  SharedPrefsLocalDataSource({
    @required this.sharedPrefs,
  });

  @override
  Future<School> getCurrentlyStoredSchool(String uid) async {
    final schoolUid = sharedPrefs.getString('school' ?? 'error');
    if (schoolUid != uid) {
      throw CacheException();
    }
    final completableSchool = Completer<School>();
    final id = sharedPrefs.getInt('id' ?? 'error');
    final email = sharedPrefs.getString('schoolEmail' ?? 'error');
    final address = sharedPrefs.getString('address' ?? 'error');
    final city = sharedPrefs.getString('city' ?? 'error');
    final state = sharedPrefs.getString('state' ?? 'error');
    final zipcode = sharedPrefs.getString('zipcode' ?? 'error');
    final school = School(
      id: id,
      schoolId: uid,
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
    sharedPrefs.setInt('id', schoolToStore.id);
    sharedPrefs.setString('uid', schoolToStore.schoolId);
    sharedPrefs.setString('schoolName', schoolToStore.schoolName);
    sharedPrefs.setString('schoolEmail', schoolToStore.email);
    sharedPrefs.setString('address', schoolToStore.address);
    sharedPrefs.setString('state', schoolToStore.state);
    sharedPrefs.setString('zipcode', schoolToStore.zipcode);
    completableSchool.complete(true);
    return completableSchool.future;
  }
}
