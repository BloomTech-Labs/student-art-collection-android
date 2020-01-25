import 'package:equatable/equatable.dart';

abstract class FilterType extends Equatable {
  final String searchQuery;

  const FilterType({
    this.searchQuery,
  });

  @override
  List<Object> get props => [searchQuery];
}

class FilterTypeArtworkTitle extends FilterType {
  const FilterTypeArtworkTitle({
    searchQuery: String,
  }) : super(searchQuery: searchQuery);

  @override
  List<Object> get props => null;
}

class FilterTypeArtistName extends FilterType {
  const FilterTypeArtistName({
    searchQuery: String,
  }) : super(searchQuery: searchQuery);

  @override
  List<Object> get props => null;
}

class FilterTypeSchoolName extends FilterType {
  const FilterTypeSchoolName({
    searchQuery: String,
  }) : super(searchQuery: searchQuery);

  @override
  List<Object> get props => null;
}

class FilterTypeZipCode extends FilterType {
  final String zipcode;

  const FilterTypeZipCode({
    this.zipcode,
  });

  @override
  List<Object> get props => [zipcode];
}

class FilterTypeCategory extends FilterType {
  final int category;

  const FilterTypeCategory({
    this.category,
  });

  @override
  List<Object> get props => [category];
}
