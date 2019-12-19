import 'package:student_art_collection/core/domain/entity/artwork.dart';
import 'package:student_art_collection/core/domain/entity/school.dart';
import 'package:meta/meta.dart';

class SchoolModel extends School {
  SchoolModel({
    @required int id,
    @required String schoolId,
    @required String email,
    String schoolName,
    String password,
    String address,
    String city,
    String state,
    String zipcode,
    List<Artwork> artworks,
  }) : super(
          id: id,
          schoolId: schoolId,
          schoolName: schoolName,
          email: email,
          password: password,
          address: address,
          city: city,
          state: state,
          zipcode: zipcode,
          artworks: artworks,
        );
}
