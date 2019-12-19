import 'package:equatable/equatable.dart';
import 'package:student_art_collection/core/domain/entity/artwork.dart';
import 'package:meta/meta.dart';

class School extends Equatable {
  final int id;
  final String schoolId;
  final String schoolName;
  final String email;
  final String password;
  final String address;
  final String city;
  final String state;
  final String zipcode;
  final List<Artwork> artworks;

  School(
      {@required this.id,
      @required this.schoolId,
      @required this.email,
      this.schoolName,
      this.password,
      this.address,
      this.city,
      this.state,
      this.zipcode,
      this.artworks});

  @override
  List<Object> get props => [
        id,
        schoolId,
        schoolName,
        email,
        password,
        address,
        city,
        state,
        zipcode,
        artworks
      ];
}
