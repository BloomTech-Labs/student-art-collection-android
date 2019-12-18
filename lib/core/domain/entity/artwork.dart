import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Artwork extends Equatable {
  final int artId;
  final String title;
  final Category category;
  final double price;
  final String artistName;
  final bool sold;
  final int schoolId;
  final String description;
  final DateTime datePosted;
  final List<Image> images;

  Artwork({
    @required this.artId,
    this.title,
    this.category,
    @required this.price,
    this.artistName,
    this.sold,
    @required this.schoolId,
    this.description,
    this.datePosted,
    @required this.images,
  });

  @override
  List<Object> get props => [
        artId,
        title,
        category,
        price,
        artistName,
        sold,
        schoolId,
        description,
        datePosted,
        images,
      ];
}

class Category extends Equatable {
  final int categoryId;
  final String categoryName;

  Category({
    @required this.categoryId,
    @required this.categoryName,
  });

  @override
  List<Object> get props => [
        categoryId,
        categoryName,
      ];
}

class Image extends Equatable {
  final int imageId;
  final int artId;
  final String imageUrl;

  Image({
    @required this.imageId,
    @required this.artId,
    @required this.imageUrl,
  });

  @override
  List<Object> get props => [imageId, artId, imageUrl];
}
