part of 'artwork_details_bloc.dart';


abstract class ArtworkDetailsState  extends Equatable{
  const ArtworkDetailsState();
}

class ArtworkDetailsInitialState extends ArtworkDetailsState {
  const ArtworkDetailsInitialState();

  @override
  // TODO: implement props
  List<Object> get props => null;
}

class ArtworkDetailsErrorState extends ArtworkDetailsState {
  final String message;
  const ArtworkDetailsErrorState({@required this.message});
  @override
  // TODO: implement props
  List<Object> get props => null;
}


class ArtworkDetailsLoadingState extends ArtworkDetailsState {
  const ArtworkDetailsLoadingState();

  @override
  // TODO: implement props
  List<Object> get props => null;
}

class ArtworkDetailsFormSubmittedState extends ArtworkDetailsState {
  const ArtworkDetailsFormSubmittedState();

  @override
  // TODO: implement props
  List<Object> get props => null;
}