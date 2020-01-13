import 'dart:math';

import 'package:email_validator/email_validator.dart';
import 'package:graphql/client.dart';
import 'package:intl/intl.dart';
import 'package:student_art_collection/core/data/model/artwork_model.dart';
import 'package:student_art_collection/core/domain/entity/artwork.dart' as aw;
import 'package:student_art_collection/core/domain/entity/artwork.dart';

/// Generates a Random Number within a range
Random randomNum = Random();
int randomInRange(int min, int max) => min + randomNum.nextInt(max - min);

List<String> imageListToUrlList(List<aw.Image> images) {
  List<String> imageUrls = [];
  for (aw.Image image in images) {
    imageUrls.add(image.imageUrl);
  }
  return imageUrls;
}

List<Artwork> convertResultToArtworkList(QueryResult result, String mainKey) {
  List<Artwork> artworkList = [];
  int artworkIndex = 0;
  // ignore: unused_local_variable
  for (Map map in result.data[mainKey]) {
    artworkList.add(ArtworkModel.fromJson(result.data[mainKey][artworkIndex]));
    artworkIndex++;
  }
  return artworkList;
}

Artwork convertResultToArtwork(QueryResult result, String mainKey) {
  return ArtworkModel.fromJson(result.data[mainKey]);
}

bool emailValidation(String email) {
  if(email != ""){
    return EmailValidator.validate(email);
  }
  else return false;
}

String formatDate(DateTime dateTime) {
  return DateFormat('MM-dd-yyyy').format(dateTime);
}

String pickerValueToPureValue(String value) {
  final newValue = value.replaceAll(RegExp('[\\[\\]]'), '');
  return newValue;
}

int pricePickerValueToInt(String value) {
  final newValue = value.replaceAll(RegExp('[\\p{P}\$]'), '');
  return int.parse(newValue);
}
