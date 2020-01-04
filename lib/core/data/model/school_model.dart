import 'package:student_art_collection/core/domain/entity/artwork.dart';
import 'package:student_art_collection/core/domain/entity/school.dart';
import 'package:meta/meta.dart';
import 'package:student_art_collection/core/util/api_constants.dart';

class SchoolModel extends School {
  SchoolModel({
    @required int id,
    @required String schoolId,
    @required String email,
    String schoolName,
    String address,
    String city,
    String state,
    String zipcode,
  }) : super(
          id: id,
          schoolId: schoolId,
          schoolName: schoolName,
          email: email,
          address: address,
          city: city,
          state: state,
          zipcode: zipcode,
        );

  factory SchoolModel.fromJson(Map<String, dynamic> json) {
    return SchoolModel(
        id: int.parse(json[SCHOOL_ID]),
        schoolId: json[SCHOOL_SCHOOL_ID],
        email: json[SCHOOL_EMAIL],
        schoolName: json[SCHOOL_NAME],
        address: json[SCHOOL_ADDRESS],
        city: json[SCHOOL_CITY],
        state: json[SCHOOL_STATE],
        zipcode: json[SCHOOL_ZIPCODE]);
  }

  Map<String, dynamic> toJson() {
    return {
      SCHOOL_ID: id.toString(),
      SCHOOL_SCHOOL_ID: schoolId,
      SCHOOL_EMAIL: email,
      SCHOOL_NAME: schoolName,
      SCHOOL_ADDRESS: address,
      SCHOOL_CITY: city,
      SCHOOL_STATE: state,
      SCHOOL_ZIPCODE: zipcode
    };
  }
}
