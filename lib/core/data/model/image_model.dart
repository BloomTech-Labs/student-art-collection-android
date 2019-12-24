import 'package:student_art_collection/core/domain/entity/artwork.dart';
import 'package:meta/meta.dart';
import 'package:student_art_collection/core/util/api_constants.dart';

class ImageModel extends Image {
  ImageModel({@required int artId, @required int imageId, String imageUrl})
      : super(artId: artId, imageId: imageId, imageUrl: imageUrl);

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      imageId: json[IMAGE_ID],
      artId: json[IMAGE_ART_ID],
      imageUrl: json[IMAGE_URL],
    );
  }

  Map<String, dynamic> toJson() {
    return {IMAGE_ID: imageId, IMAGE_ART_ID: artId, IMAGE_URL: imageUrl};
  }
}
