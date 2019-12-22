import 'package:equatable/equatable.dart';
import 'package:student_art_collection/core/domain/entity/school.dart';
import 'package:meta/meta.dart';

abstract class SchoolAuthState extends Equatable {
  const SchoolAuthState();
}

class Unauthorized extends SchoolAuthState {
  @override
  List<Object> get props => [];
}

class Loading extends SchoolAuthState {
  @override
  List<Object> get props => null;
}

class Loaded extends SchoolAuthState {
  final School school;

  Loaded({@required this.school});

  @override
  List<Object> get props => [school];
}

class Error extends SchoolAuthState {
  final String message;

  Error({@required this.message});

  @override
  List<Object> get props => [message];
}
