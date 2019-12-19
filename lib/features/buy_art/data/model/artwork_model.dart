import 'package:meta/meta.dart';
import 'package:student_art_collection/core/domain/entity/artwork.dart';
import 'package:student_art_collection/features/buy_art/data/model/category_model.dart';

import 'image_model.dart';

class ArtworkModel extends Artwork {
  ArtworkModel({
    @required int artId,
    String title,
    CategoryModel category,
    @required double price,
    String artistName,
    bool sold,
    @required int schoolId,
    String description,
    DateTime dateTime,
    @required List<ImageModel> images,
  }) : super(
            title: title,
            category: category,
            price: price,
            artistName: artistName,
            sold: sold,
            artId: artId,
            description: description,
            datePosted: dateTime,
            schoolId: schoolId,
            images: images);

  factory ArtworkModel.fromJson(Map<String, dynamic> json) {
//extracts the json objects from the json array and
// converts them to Image objects
    var images = json['images'];
    List<ImageModel> imageList = List<ImageModel>();

    List<Map<String, dynamic>> jsonImageList =
        List<Map<String, dynamic>>.from(images);

    for (Map<String, dynamic> jsonImage in jsonImageList) {
      imageList.add(ImageModel.fromJson(jsonImage));
    }

    return ArtworkModel(
        title: json['title'],
        category: CategoryModel.fromJson(json['category']),
        price: json['price'],
        artistName: json['artist_name'],
        sold: json['sold'],
        artId: json['art_id'],
        description: json['description'],
        //ToDo : setup datetime to json conversions
        //datePosted: json['date_posted'],
        schoolId: json['school_id'],
        images: imageList);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> imageString = Map<String, dynamic>();

    for (ImageModel image in images) {
      imageString.addAll(image.toJson());
    }
    CategoryModel categoryModel = category;
    return {
      'title': title,
      'category': categoryModel.toJson(),
      'price': price,
      'artist_name': artistName,
      'sold': sold,
      'art_id': artId,
      'description': description,
      // 'date_posted': datePosted,
      'school_id': schoolId,
      'images': [imageString],
    };
  }
}
