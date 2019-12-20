import 'package:student_art_collection/core/domain/entity/artwork.dart';
import 'package:student_art_collection/core/domain/entity/school.dart';
import 'package:meta/meta.dart';

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
        id: json['id'],
        schoolId: json['schoolId'],
        email: json['email'],
        schoolName: json['schoolName'],
        address: json['address'],
        city: json['city'],
        state: json['state'],
        zipcode: json['zipcode']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'schoolId': schoolId,
      'email': email,
      'schoolName': schoolName,
      'address': address,
      'city': city,
      'state': state,
      'zipcode': zipcode
    };
  }
}
