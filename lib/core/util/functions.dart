import 'dart:async';
import 'dart:math';

import 'package:email_validator/email_validator.dart';
import 'package:graphql/client.dart';
import 'package:intl/intl.dart';
import 'package:student_art_collection/core/data/model/artwork_model.dart';
import 'package:student_art_collection/core/domain/entity/artwork.dart' as aw;
import 'package:student_art_collection/core/domain/entity/artwork.dart';
import 'package:student_art_collection/core/presentation/bloc/base_artwork_sort_type.dart';
import 'package:collection/collection.dart';

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
  if (email != "") {
    return EmailValidator.validate(email);
  } else
    return false;
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

Future<List<Artwork>> returnSortedArtworks(
  List<Artwork> artworks,
  SortType sortType,
) async {
  return Future(() {
    _sortBySortType(artworks, sortType);
  }).then((artworks) {
    return artworks;
  });
}

void _sortBySortType(
  List<Artwork> artworks,
  SortType sortType,
) {
  if (sortType is SortNameAsc) {
    artworks.sort((a, b) {
      return a.title.toLowerCase().compareTo(b.title.toLowerCase());
    });
  } else if (sortType is SortNameDesc) {
    artworks.sort((a, b) {
      return b.title.toLowerCase().compareTo(a.title.toLowerCase());
    });
  } else if (sortType is SortSchoolNameAsc) {
    artworks.sort((a, b) {
      return a.schoolInfo.schoolName
          .toLowerCase()
          .compareTo(b.schoolInfo.schoolName.toLowerCase());
    });
  } else if (sortType is SortSchoolNameDesc) {
    artworks.sort((a, b) {
      return b.schoolInfo.schoolName
          .toLowerCase()
          .compareTo(a.schoolInfo.schoolName.toLowerCase());
    });
  } else if (sortType is SortStudentNameAsc) {
    artworks.sort((a, b) {
      return a.artistName.toLowerCase().compareTo(b.artistName.toLowerCase());
    });
  } else if (sortType is SortStudentNameDesc) {
    artworks.sort((a, b) {
      return b.artistName.toLowerCase().compareTo(a.artistName.toLowerCase());
    });
  } else if (sortType is SortPriceAsc) {
    artworks.sort((a, b) {
      return a.price.compareTo(b.price);
    });
  } else if (sortType is SortPriceDesc) {
    artworks.sort((a, b) {
      return b.price.compareTo(a.price);
    });
  } else if (sortType is SortDatePostedAsc) {
    artworks.sort((a, b) {
      return a.datePosted.compareTo(b.datePosted);
    });
  } else if (sortType is SortDatePostedDesc) {
    artworks.sort((a, b) {
      return b.datePosted.compareTo(a.datePosted);
    });
  }
}

SortType convertLabelToSortType(String label) {
  if (label == 'Artwork Title Asc.')
    return SortNameAsc();
  else if (label == 'Artwork Title Desc.')
    return SortNameDesc();
  else if (label == 'School Name Asc.')
    return SortSchoolNameAsc();
  else if (label == 'School Name Desc.')
    return SortSchoolNameDesc();
  else if (label == 'Artist Name Asc.')
    return SortStudentNameAsc();
  else if (label == 'Artist Name Desc.')
    return SortStudentNameDesc();
  else if (label == 'Most Recent')
    return SortDatePostedDesc();
  else if (label == 'Oldest')
    return SortDatePostedAsc();
  else if (label == 'Most expensive')
    return SortPriceDesc();
  else if (label == 'Least Expensive')
    return SortPriceAsc();
  else
    return SortNameAsc();
}
