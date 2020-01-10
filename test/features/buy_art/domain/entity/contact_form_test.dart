import 'package:flutter_test/flutter_test.dart';
import 'package:student_art_collection/features/buy_art/domain/entity/contact_form.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('ContactForm entity', () {
    final ContactForm tContactForm1 = ContactForm(
        subject: "test",
        message: "test",
        name: "test",
        sendTo: "test@gmail.com",
        from: "test");

    final ContactForm tContactForm2 = ContactForm(
        subject: "test",
        message: "test",
        name: "test",
        sendTo: "test@gmail.com",
        from: "test");

    test(
        'Multiple ContactForm entities with identical properties and shared Category and Images shoudld be regarded as equal by Equatable',
        () {
      expect(tContactForm1, equals(tContactForm2));
    });
  });
}
