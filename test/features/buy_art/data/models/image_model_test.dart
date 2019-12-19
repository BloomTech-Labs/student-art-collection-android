import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:student_art_collection/core/data/model/image_model.dart';
import 'package:student_art_collection/core/domain/entity/artwork.dart';

import '../../../../core/fixtures/fixture_reader.dart';

void main() {
  final tImageModel = ImageModel(
      imageId: 1, imageUrl: 'https://picsum.photos/200/300', artId: 1);

  test('should be a subclass of Image entity', () async {
    //assert
    expect(tImageModel, isA<Image>());
  });

  group('Json', () {
    test('should return a valid model', () async {
      //arrange
      final Map<String, dynamic> jsonMap = json.decode(fixture('image.json'));
      //act
      final result = ImageModel.fromJson(jsonMap);
      //assert
      expect(result, tImageModel);
    });

    test('should return a Json map containing the proper data', () async {
      //act
      final result = tImageModel.toJson();
      final expectedMap = {
        "image_id" : 1,
        "art_id" : 1,
        "image_url" : "https://picsum.photos/200/300"
      };
      //assert
      expect(result, expectedMap);
    });
  });
}
