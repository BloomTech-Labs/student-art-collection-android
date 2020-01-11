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

class SchoolAuthLoading extends SchoolAuthState {
  @override
  List<Object> get props => null;
}

class Authorized extends SchoolAuthState {
  final School school;

  Authorized({@required this.school});

  @override
  List<Object> get props => [school];
}

class SchoolAuthError extends SchoolAuthState {
  final String message;

  SchoolAuthError({@required this.message});

  @override
  List<Object> get props => [message];
}
