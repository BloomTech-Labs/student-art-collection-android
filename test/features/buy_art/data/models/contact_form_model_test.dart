import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:student_art_collection/core/util/api_constants.dart';
import 'package:student_art_collection/features/buy_art/data/model/contact_form_model.dart';
import 'package:student_art_collection/features/buy_art/domain/entity/contact_form.dart';

import '../../../../core/fixtures/fixture_reader.dart';

void main() {
  final ContactFormModel tContactFormModel = ContactFormModel(
      subject: "test",
      message: "test",
      name: "test",
      sendTo: "test@gmail.com",
      from: "test");

  test('should be a subclass of ContactForm entity', () async {
    //assert
    expect(tContactFormModel, isA<ContactForm>());
  });

  group('Json', () {
    test('should return a valid model', () async {
      //arrange
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('contact_form.json'));
      //act
      final result = ContactFormModel.fromJson(jsonMap);
      //assert
      expect(result, tContactFormModel);
    });

    test('should return a Json map containing the proper data', () async {
      //act
      final result = tContactFormModel.toJson();
      final expectedMap = {
        CONTACT_FORM_SEND_TO: tContactFormModel.sendTo,
        CONTACT_FORM_NAME: tContactFormModel.name,
        CONTACT_FORM_SUBJECT: tContactFormModel.subject,
        CONTACT_FORM_FROM: tContactFormModel.from,
        CONTACT_FORM_MESSAGE: tContactFormModel.message
      };
      //assert
      expect(result, expectedMap);
    });
  });
}
