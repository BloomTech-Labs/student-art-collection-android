import 'package:student_art_collection/core/domain/entity/artwork.dart';
import 'package:meta/meta.dart';

class CategoryModel extends Category {
  CategoryModel({@required int categoryId, @required String categoryName})
      : super(
      categoryId: categoryId,
      categoryName: categoryName,);

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      categoryName: json['category_name'],
      categoryId: json['category_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category_id':categoryId,
      'category_name':categoryName,
    };
  }
}
