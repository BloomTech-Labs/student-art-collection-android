import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class SchoolProfileEvent extends Equatable {
  const SchoolProfileEvent();
}

class UpdateSchoolInfoEvent extends SchoolProfileEvent {
  final String schoolName, address, city, state, zipcode;

  UpdateSchoolInfoEvent({
    @required this.schoolName,
    @required this.address,
    @required this.city,
    @required this.state,
    @required this.zipcode,
  });

  @override
  List<Object> get props => [
        schoolName,
        address,
        city,
        state,
        zipcode,
      ];
}
