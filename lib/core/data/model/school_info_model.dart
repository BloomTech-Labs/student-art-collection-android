import 'package:student_art_collection/core/data/model/school_model.dart';
import 'package:student_art_collection/core/domain/entity/artwork.dart';
import 'package:student_art_collection/core/domain/entity/school.dart';
import 'package:meta/meta.dart';
import 'package:student_art_collection/core/util/api_constants.dart';

class SchoolInfoModel extends SchoolInfo {
  SchoolInfoModel({
    @required int id,
    @required String schoolId,
    @required String email,
    String schoolName,
  }) : super(
    id: id,
    schoolId: schoolId,
    schoolName: schoolName,
    email: email,
  );

  factory SchoolInfoModel.fromJson(Map<String, dynamic> json) {
    return SchoolInfoModel(
        id: int.parse(json[SCHOOL_ID]),
        schoolId: json[SCHOOL_SCHOOL_ID],
        email: json[SCHOOL_EMAIL],
        schoolName: json[SCHOOL_NAME],
);
  }

  Map<String, dynamic> toJson() {
    return {
      SCHOOL_ID: id.toString(),
      SCHOOL_SCHOOL_ID: schoolId,
      SCHOOL_EMAIL: email,
      SCHOOL_NAME: schoolName,
    };
  }
}
