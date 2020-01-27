part of 'gallery_bloc.dart';

@immutable
abstract class GalleryEvent extends Equatable {
  const GalleryEvent();
}

class GetArtworkList extends GalleryEvent {
  final SortType sortType;
  final Map<String, FilterType> filterTypes;

  const GetArtworkList({
    this.sortType,
    this.filterTypes,
  });

  @override
  List<Object> get props => null;
}

class GetCurrentZipcodeEvent extends GalleryEvent {
  @override
  List<Object> get props => null;
}
