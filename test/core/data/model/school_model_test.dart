import 'package:flutter_test/flutter_test.dart';
import 'package:student_art_collection/core/data/model/school_model.dart';
import 'package:student_art_collection/core/domain/entity/school.dart';
import 'dart:convert';

import '../../fixtures/fixture_reader.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final tSchoolModel = SchoolModel(
      id: 1,
      schoolId: 'test',
      email: 'test',
      schoolName: 'test',
      address: 'test',
      city: 'test',
      zipcode: 'test');

  test('should be a subclass of a School entity', () {
    expect(tSchoolModel, isA<School>());
  });

  group('fromJson', () {
    test('should return a valid SchoolModel from json', () {
      final Map<String, dynamic> jsonMap = json.decode(fixture('school.json'));

      final result = SchoolModel.fromJson(jsonMap);

      expect(result, tSchoolModel);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing the proper data', () {
      final result = tSchoolModel.toJson();

      final expectedMap = json.decode(fixture('school.json'));

      expect(result, expectedMap);
    });
  });
}
