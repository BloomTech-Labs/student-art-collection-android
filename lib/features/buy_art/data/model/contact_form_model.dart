import 'package:flutter/material.dart';
import 'package:student_art_collection/core/util/api_constants.dart';
import 'package:student_art_collection/features/buy_art/domain/entity/contact_form.dart';

class ContactFormModel extends ContactForm {
  ContactFormModel({
    @required String sendTo,
    @required String name,
    @required String subject,
    @required String message,
    @required String from,
  }) : super(
    sendTo: sendTo,
    name: name,
    subject: subject,
    message : message,
    from: from
  );

  Map<String, dynamic> toJson(){
    return {
      CONTACT_FORM_SEND_TO: sendTo,
      CONTACT_FORM_NAME: name,
      CONTACT_FORM_MESSAGE: message,
      CONTACT_FORM_FROM: from,
      CONTACT_FORM_SUBJECT: subject,
    };
  }

  factory ContactFormModel.fromJson(Map<String, dynamic> json) {
    return ContactFormModel(
      sendTo: json[CONTACT_FORM_SEND_TO],
      name: json[CONTACT_FORM_NAME],
      message: json[CONTACT_FORM_MESSAGE],
      from: json[CONTACT_FORM_FROM],
      subject: json[CONTACT_FORM_SUBJECT],
    );
  }
}
