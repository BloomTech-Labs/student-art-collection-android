import 'package:meta/meta.dart';
import 'package:student_art_collection/core/data/model/image_model.dart';
import 'package:student_art_collection/core/domain/entity/artwork.dart';
import 'package:student_art_collection/core/data/model/category_model.dart';
import 'package:student_art_collection/core/util/api_constants.dart';

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
    DateTime datePosted,
    @required List<ImageModel> images,
  }) : super(
            title: title,
            category: category,
            price: price,
            artistName: artistName,
            sold: sold,
            artId: artId,
            description: description,
            datePosted: datePosted,
            schoolId: schoolId,
            images: images);

  factory ArtworkModel.fromJson(Map<String, dynamic> json) {
//extracts the json objects from the json array and
// converts them to Image objects
    var images = json[ARTWORK_IMAGES];
    List<ImageModel> imageList = List<ImageModel>();

    List<Map<String, dynamic>> jsonImageList =
        List<Map<String, dynamic>>.from(images);

    for (Map<String, dynamic> jsonImage in jsonImageList) {
      imageList.add(ImageModel.fromJson(jsonImage));
    }
    final artworkModel = ArtworkModel(
        title: json[ARTWORK_TITLE],
        //  category: CategoryModel.fromJson(json[ARTWORK_CATEGORY]),
        price: json[ARTWORK_PRICE].toDouble(),
        artistName: json[ARTWORK_ARTIST_NAME],
        sold: json[ARTWORK_SOLD],
        artId: int.parse(json[ARTWORK_ID]),
        description: json[ARTWORK_DESCRIPTION],
        //ToDo : setup datetime to json conversions
        datePosted: DateTime.fromMillisecondsSinceEpoch(
            int.parse(json[ARTWORK_DATE_POSTED])),
        schoolId: int.parse(json[ARTWORK_SCHOOL_ID]),
        images: imageList);
    return artworkModel;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> imageString = Map<String, dynamic>();

    for (ImageModel image in images) {
      imageString.addAll(image.toJson());
    }
    CategoryModel categoryModel = category;
    return {
      ARTWORK_TITLE: title,
      ARTWORK_CATEGORY: categoryModel.toJson(),
      ARTWORK_PRICE: price,
      ARTWORK_ARTIST_NAME: artistName,
      ARTWORK_SOLD: sold,
      ARTWORK_ID: artId,
      ARTWORK_DESCRIPTION: description,
      // ARTWORK_DATE_POSTED: datePosted,
      ARTWORK_SCHOOL_ID: schoolId,
      ARTWORK_IMAGES: [imageString],
    };
  }
}
