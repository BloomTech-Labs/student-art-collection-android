import 'package:flutter_test/flutter_test.dart';
import 'package:student_art_collection/features/buy_art/domain/entity/contact_form.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('ContactForm entity', () {

    final tContactForm1 = ContactForm(
        email: 'test@gmail.com',
        message: 'test',
        buyerName: 'test',
        artId: 1,
        price: 50.0);

    final tContactForm2 = ContactForm(
        email: 'test@gmail.com',
        message: 'test',
        buyerName: 'test',
        artId: 1,
        price: 50.0);

    test(
        'Multiple ContactForm entities with identical properties and shared Category and Images shoudld be regarded as equal by Equatable',
        () {
      expect(tContactForm1, equals(tContactForm2));
    });
  });
}
