import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class SchoolAuthEvent extends Equatable {
  const SchoolAuthEvent();
}

class RegisterNewSchool extends SchoolAuthEvent {
  final String email,
      password,
      verifyPassword,
      schoolName,
      address,
      city,
      state,
      zipcode;

  RegisterNewSchool({
    @required this.email,
    @required this.password,
    @required this.verifyPassword,
    @required this.schoolName,
    @required this.address,
    @required this.city,
    @required this.state,
    @required this.zipcode,
  });

  @override
  List<Object> get props => [
        email,
        password,
        verifyPassword,
        schoolName,
        address,
        city,
        state,
        zipcode,
      ];
}

class LoginSchool extends SchoolAuthEvent {
  final String email, password;

  LoginSchool({
    @required this.email,
    @required this.password,
  });

  @override
  List<Object> get props => [
        email,
        password,
      ];
}

class LoginOnReturn extends SchoolAuthEvent {
  @override
  List<Object> get props => null;
}
