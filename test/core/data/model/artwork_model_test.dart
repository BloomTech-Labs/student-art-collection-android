import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:student_art_collection/core/data/model/artwork_model.dart';
import 'package:student_art_collection/core/data/model/category_model.dart';
import 'package:student_art_collection/core/data/model/image_model.dart';
import 'package:student_art_collection/core/domain/entity/artwork.dart';

import '../../fixtures/fixture_reader.dart';

void main() {
  final tImageList = [ImageModel(
      imageId: 1, imageUrl: 'https://picsum.photos/200/300', artId: 1
  )];

  final tCategory = CategoryModel(
    categoryId: 1, categoryName: 'test',);

  final tArtworkModel = ArtworkModel(
    artId: 1,
    artistName: "name",
    category: tCategory,
    images: tImageList,
    price: 25.50,
    schoolId: 1,
    sold: false,
    description: "description",
    title: "title"
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
        "title": "title",
        "category": {
          "category_id": 1,
          "category_name": "test"
        },
        "price": 25.50,
        "artist_name": "name",
        "sold": false,
        "art_id": 1,
        "description": "description",
        "school_id": 1,
        "images": [
          {
            "image_id": 1,
            "art_id": 1,
            "image_url": "https://picsum.photos/200/300"
          }
        ]
      };
      //assert
      expect(result, expectedMap);
    });
  });
}
