part of 'artwork_details_bloc.dart';

abstract class ArtworkDetailsEvent extends Equatable{
  const ArtworkDetailsEvent();
}

class SubmitContactForm extends ArtworkDetailsEvent{
  //ToDo: pass in ContactFormObject
  @override
  // TODO: implement props
  List<Object> get props => null;
}