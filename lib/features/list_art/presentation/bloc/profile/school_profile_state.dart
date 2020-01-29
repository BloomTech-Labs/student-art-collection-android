import 'package:equatable/equatable.dart';
import 'package:student_art_collection/core/domain/entity/school.dart';

abstract class SchoolProfileState extends Equatable {
  const SchoolProfileState();
}

class SchoolProfileInitial extends SchoolProfileState {
  final School school;

  SchoolProfileInitial({
    this.school,
  });

  @override
  List<Object> get props => [school];
}

class SchoolProfileLoading extends SchoolProfileState {
  @override
  List<Object> get props => null;
}

class SchoolProfileUpdated extends SchoolProfileState {
  final School school;

  SchoolProfileUpdated({
    this.school,
  });

  @override
  List<Object> get props => [school];
}

class SchoolProfileError extends SchoolProfileState {
  final String message;

  SchoolProfileError({
    this.message,
  });

  @override
  List<Object> get props => [message];
}
