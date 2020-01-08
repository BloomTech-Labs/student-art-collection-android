import 'package:equatable/equatable.dart';

abstract class ArtworkUploadState extends Equatable {
  const ArtworkUploadState();
}

class InitialArtworkUploadState extends ArtworkUploadState {
  @override
  List<Object> get props => [];
}
