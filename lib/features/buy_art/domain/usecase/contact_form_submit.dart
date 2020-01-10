
import 'package:dartz/dartz.dart';
import 'package:student_art_collection/core/domain/usecase/usecase.dart';
import 'package:student_art_collection/core/error/failure.dart';
import 'package:student_art_collection/features/buy_art/domain/entity/contact_form.dart';
import 'package:student_art_collection/features/buy_art/domain/repository/buyer_artwork_repository.dart';

class ContactFormSubmit implements UseCase<bool, ContactForm> {
  final ArtworkRepository artworkRepository;

  ContactFormSubmit(this.artworkRepository);

  @override
  Future<Either<Failure, bool>> call(ContactForm contactForm) async {
    return await artworkRepository.contactFormConfirmation(contactForm: contactForm);
  }
}