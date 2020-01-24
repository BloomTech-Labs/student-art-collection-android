part of 'gallery_bloc.dart';

@immutable
abstract class GalleryEvent extends Equatable {
  const GalleryEvent();
}

class GetArtworkList extends GalleryEvent {
  final SortType sortType;
  final FilterType filterType;

  const GetArtworkList({
    this.sortType,
    this.filterType,
  });

  @override
  List<Object> get props => null;
}
