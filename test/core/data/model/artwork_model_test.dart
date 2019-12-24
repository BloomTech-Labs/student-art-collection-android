import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:student_art_collection/core/data/model/artwork_model.dart';
import 'package:student_art_collection/core/data/model/category_model.dart';
import 'package:student_art_collection/core/data/model/image_model.dart';
import 'package:student_art_collection/core/domain/entity/artwork.dart';
import 'package:student_art_collection/core/util/api_constants.dart';

import '../../fixtures/fixture_reader.dart';

void main() {
  final tImageList = [ImageModel(
      imageId: 1, imageUrl: "test", artId: 1
  )];

  final tCategory = CategoryModel(
    categoryId: 1, categoryName: 'test',);

  final tArtworkModel = ArtworkModel(
    artId: 1,
    artistName: "test",
    category: tCategory,
    images: tImageList,
    price: 25.50,
    schoolId: 1,
    sold: false,
    description: "test",
    title: "test"
  );

  test('should be a subclass of Artwork entity', () async {
    //assert
    expect(tArtworkModel, isA<Artwork>());
  });

  group('Json', () {
    test('should return a valid model', () async {
      //arrange
      final Map<String, dynamic> jsonMap = json.decode(fixture('artwork.json'));
      //act
      final result = ArtworkModel.fromJson(jsonMap);
      //assert
      expect(result, tArtworkModel);
    });

    test('should return a Json map containing the proper data', () async {
      //act
      final result = tArtworkModel.toJson();
      final expectedMap = {
        ARTWORK_TITLE: "test",
        ARTWORK_CATEGORY: {
          CATEGORY_ID: 1,
          CATEGORY_NAME: "test"
        },
        ARTWORK_PRICE: 25.50,
        ARTWORK_ARTIST_NAME: "test",
        ARTWORK_SOLD: false,
        ARTWORK_ID: 1,
        ARTWORK_DESCRIPTION: "test",
        ARTWORK_SCHOOL_ID: 1,
        ARTWORK_IMAGES: [
          {
            IMAGE_ID: 1,
            IMAGE_ART_ID: 1,
            IMAGE_URL: "test"
          }
        ]
      };
      //assert
      expect(result, expectedMap);
    });
  });
}
