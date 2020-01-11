part of 'gallery_bloc.dart';

@immutable
abstract class GalleryEvent extends Equatable{
  const GalleryEvent();
}

class GetArtworkList extends GalleryEvent{
  @override
  List<Object> get props => null;
}
