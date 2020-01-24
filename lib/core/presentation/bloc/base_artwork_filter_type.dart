import 'package:equatable/equatable.dart';

abstract class FilterType extends Equatable {
  const FilterType();
}

class FilterTypeArtworkTitle extends FilterType {
  @override
  List<Object> get props => null;
}

class FilterTypeArtistName extends FilterType {
  @override
  List<Object> get props => null;
}

class FilterTypeSchoolName extends FilterType {
  @override
  List<Object> get props => null;
}

class FilterTypeZipCode extends FilterType {
  @override
  List<Object> get props => null;
}
