import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:student_art_collection/core/data/model/image_model.dart';
import 'package:student_art_collection/core/domain/entity/artwork.dart';
import 'package:student_art_collection/core/util/api_constants.dart';

import '../../fixtures/fixture_reader.dart';

void main() {
  final tImageModel = ImageModel(
      imageId: 1, imageUrl: 'test', artId: 1);

  test('should be a subclass of Image entity', () async {
    //assert
    expect(tImageModel, isA<Image>());
  });

  group('Json', () {
    /*test('should return a valid model', () async {
      //arrange
      final Map<String, dynamic> jsonMap = json.decode(fixture('image.json'));
      //act
      final result = ImageModel.fromJson(jsonMap);
      //assert
      expect(result, tImageModel);
    });*/

    test('should return a Json map containing the proper data', () async {
      //act
      final result = tImageModel.toJson();
      final expectedMap = {
        IMAGE_ID : 1,
        IMAGE_ART_ID : 1,
        IMAGE_URL : "test"
      };
      //assert
      expect(result, expectedMap);
    });
  });
}
