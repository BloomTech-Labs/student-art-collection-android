import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:student_art_collection/features/buy_art/domain/entity/contact_form.dart';
import 'package:student_art_collection/features/buy_art/domain/repository/buyer_artwork_repository.dart';

part 'artwork_details_event.dart';

part 'artwork_details_state.dart';

class ArtworkDetailsBloc
    extends Bloc<ArtworkDetailsEvent, ArtworkDetailsState> {
  final BuyerArtworkRepository artworkRepository;

  ArtworkDetailsBloc({this.artworkRepository});

  @override
  ArtworkDetailsState get initialState => ArtworkDetailsInitialState();

  @override
  Stream<ArtworkDetailsState> mapEventToState(
      ArtworkDetailsEvent event) async* {
    if (event is SubmitContactForm) {
      yield ArtworkDetailsLoadingState();

      final confirmation = await artworkRepository.contactFormConfirmation(
          contactForm: event.contactForm);

      yield* confirmation.fold((failure) async* {
        //TODO: replace message with const
        yield ArtworkDetailsErrorState(message: "Error Please Try Again");
      }, (confirmation) async* {
        
        final ContactForm confirmationContactForm = ContactForm(
            name: confirmation.name,
            message: confirmation.message,
            from: confirmation.from,
            subject: confirmation.subject,
            sendTo: confirmation.sendTo);

        if (confirmationContactForm == event.contactForm) {
          yield ArtworkDetailsFormSubmittedState();
        } else {
          yield ArtworkDetailsErrorState(message: "Error Please Try Again");
        }
      });
    }
  }
}
