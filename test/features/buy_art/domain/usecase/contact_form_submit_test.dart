import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:student_art_collection/core/error/failure.dart';
import 'package:student_art_collection/features/buy_art/domain/entity/contact_form.dart';
import 'package:student_art_collection/features/buy_art/domain/repository/buyer_artwork_repository.dart';
import 'package:student_art_collection/features/buy_art/domain/usecase/contact_form_submit.dart';

class MockBuyerArtworkRepository extends Mock implements BuyerArtworkRepository {}

void main() {
  ContactFormSubmit usecase;
  MockBuyerArtworkRepository mockArtworkRepository;

  setUp(() {
    mockArtworkRepository = MockBuyerArtworkRepository();
    usecase = ContactFormSubmit(mockArtworkRepository);
  });

final ContactForm tContactForm = ContactForm(artId: 1,message: "test", buyerName: "test", email: "test@gmail.com", price: 50);

  test('should get ContactForm reply from the repository when data is valid', () async {
    //arrange
    when(mockArtworkRepository.contactFormConfirmation(contactForm: tContactForm))
        .thenAnswer((_) async => Right(tContactForm));
    //act
    final result = await usecase(tContactForm);

    //assert
    expect(result, Right(tContactForm));
    verify(mockArtworkRepository.contactFormConfirmation(contactForm: tContactForm));
    verifyNoMoreInteractions(mockArtworkRepository);
  });

  test('should get false reply from the repository when data is invalid', () async {
    //arrange
    when(mockArtworkRepository.contactFormConfirmation(contactForm: tContactForm))
        .thenAnswer((_) async => Left(ServerFailure()));
    //act
    final result = await usecase(tContactForm);

    //assert
    expect(result, Left(ServerFailure()));
    verify(mockArtworkRepository.contactFormConfirmation(contactForm: tContactForm));
    verifyNoMoreInteractions(mockArtworkRepository);
  });
}
