import 'dart:math';

import 'package:student_art_collection/core/domain/entity/artwork.dart'as aw;

/// Generates a Random Number within a range
Random randomNum = Random();
int randomInRange(int min, int max) => min + randomNum.nextInt(max - min);

List<String> imageListToUrlList(List<aw.Image> images){
  List<String> imageUrls = [];
  for(aw.Image image in images){
    imageUrls.add(image.imageUrl);
  }
  return imageUrls;
}