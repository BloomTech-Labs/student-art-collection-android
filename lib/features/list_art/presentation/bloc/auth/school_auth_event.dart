import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class SchoolAuthEvent extends Equatable {
  const SchoolAuthEvent();
}

class RegisterNewSchoolEvent extends SchoolAuthEvent {
  final String email,
      password,
      verifyPassword,
      schoolName,
      address,
      city,
      state,
      zipcode;

  RegisterNewSchoolEvent({
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

class LoginSchoolEvent extends SchoolAuthEvent {
  final String email, password;
  final bool shouldRemember;

  LoginSchoolEvent({
    @required this.email,
    @required this.password,
    this.shouldRemember = false,
  });

  @override
  List<Object> get props => [
        email,
        password,
      ];
}

class LoginOnReturnEvent extends SchoolAuthEvent {
  @override
  List<Object> get props => null;
}

class LogoutEvent extends SchoolAuthEvent {
  @override
  List<Object> get props => null;
}
