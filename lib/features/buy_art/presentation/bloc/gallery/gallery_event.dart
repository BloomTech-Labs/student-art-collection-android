part of 'gallery_bloc.dart';

@immutable
abstract class GalleryEvent extends Equatable {
  const GalleryEvent();
}

class GetArtworkList extends GalleryEvent {
  final List<SortType> sortTypes;

  const GetArtworkList({this.sortTypes});

  @override
  List<Object> get props => null;
}
