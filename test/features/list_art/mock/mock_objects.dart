import 'package:student_art_collection/core/data/model/school_model.dart';
import 'package:student_art_collection/core/domain/entity/school.dart';
import 'package:student_art_collection/features/list_art/domain/usecase/register_new_school.dart';

final tSchoolToRegister = SchoolToRegister(
    email: 'test@test.com',
    password: 'password',
    schoolName: 'test',
    address: 'test',
    city: 'test',
    state: 'test',
    zipcode: 'test');

final tRegisteredSchool = School(
    id: 1,
    schoolId: 'test',
    email: 'test',
    schoolName: 'test',
    address: 'test',
    city: 'test',
    state: 'test',
    zipcode: 'test');

final SchoolModel tSchoolModel = SchoolModel(
    id: 1,
    schoolId: 'test',
    email: 'test@test.com',
    schoolName: 'test',
    address: 'test',
    city: 'test',
    state: 'test',
    zipcode: 'test');
