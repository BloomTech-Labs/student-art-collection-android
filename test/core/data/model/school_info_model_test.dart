import 'package:flutter_test/flutter_test.dart';
import 'package:student_art_collection/core/data/model/school_info_model.dart';
import 'package:student_art_collection/core/data/model/school_model.dart';
import 'package:student_art_collection/core/domain/entity/artwork.dart';
import 'dart:convert';

import '../../fixtures/fixture_reader.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final tSchoolInfoModel = SchoolInfoModel(
      id: 1,
      schoolId: "1",
      email: 'test@gmail.com',
      schoolName: 'test',);

  test('should be a subclass of a School entity', () {
    expect(tSchoolInfoModel, isA<SchoolInfo>());
  });

  group('fromJson', () {
    test('should return a valid SchoolInfoModel from json', () {
      final Map<String, dynamic> jsonMap = json.decode(fixture('school_info.json'));

      final result = SchoolInfoModel.fromJson(jsonMap);

      expect(result, tSchoolInfoModel);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing the proper data', () {
      final result = tSchoolInfoModel.toJson();

      final expectedMap = json.decode(fixture('school_info.json'));

      expect(result, expectedMap);
    });
  });
}
