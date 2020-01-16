import 'package:student_art_collection/core/domain/entity/artwork.dart';
import 'package:meta/meta.dart';
import 'package:student_art_collection/core/util/api_constants.dart';

class CategoryModel extends Category {
  CategoryModel({@required int categoryId, @required String categoryName})
      : super(
      categoryId: categoryId,
      categoryName: categoryName,);

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      categoryName: json[CATEGORY_NAME],
      categoryId: int.parse(json[CATEGORY_ID]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      CATEGORY_ID:categoryId.toString(),
      CATEGORY_NAME:categoryName,
    };
  }
}
