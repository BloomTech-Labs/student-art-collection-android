part of 'gallery_bloc.dart';

@immutable
abstract class GalleryEvent extends Equatable {
  const GalleryEvent();
}

class GetArtworkList extends GalleryEvent {
  final SortType sortType;
  final List<FilterType> filterTypes;

  const GetArtworkList({
    this.sortType,
    this.filterTypes,
  });

  @override
  List<Object> get props => null;
}
