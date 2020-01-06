import 'package:equatable/equatable.dart';

abstract class SchoolGalleryState extends Equatable {
  const SchoolGalleryState();
}

class InitialSchoolGalleryState extends SchoolGalleryState {
  @override
  List<Object> get props => [];
}
