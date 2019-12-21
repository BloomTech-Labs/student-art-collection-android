import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:student_art_collection/core/data/model/category_model.dart';
import 'package:student_art_collection/core/domain/entity/artwork.dart';
import '../../fixtures/fixture_reader.dart';

void main() {
  final tCategoryModel = CategoryModel(
      categoryId: 1, categoryName: 'test',);

  test('should be a subclass of Category entity', () async {
    //assert
    expect(tCategoryModel, isA<Category>());
  });

  group('Json', () {
    test('should return a valid model', () async {
      //arrange
      final Map<String, dynamic> jsonMap = json.decode(fixture('category.json'));
      //act
      final result = CategoryModel.fromJson(jsonMap);
      //assert
      expect(result, tCategoryModel);
    });

    test('should return a Json map containing the proper data', () async {
      //act
      final result = tCategoryModel.toJson();
      final expectedMap = {
        "category_id" : 1,
        "category_name" : 'test',
      };
      //assert
      expect(result, expectedMap);
    });
  });
}
