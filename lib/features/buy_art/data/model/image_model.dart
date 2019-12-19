import 'package:student_art_collection/core/domain/entity/artwork.dart';
import 'package:meta/meta.dart';

class ImageModel extends Image {
  ImageModel({@required int artId, @required int imageId, String imageUrl})
      : super(
      artId: artId,
      imageId: imageId,
      imageUrl: imageUrl);

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      imageId: json['image_id'],
      artId: json['art_id'],
      imageUrl: json['image_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'image_id':imageId,
      'art_id':artId,
      'image_url':imageUrl
    };
  }
}
