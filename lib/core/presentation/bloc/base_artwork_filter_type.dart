import 'package:equatable/equatable.dart';

abstract class FilterType extends Equatable {
  const FilterType();
}

class FilterTypeSearch extends FilterType {
  final String searchQuery;

  const FilterTypeSearch({
    this.searchQuery = '',
  });

  @override
  List<Object> get props => [searchQuery];
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
