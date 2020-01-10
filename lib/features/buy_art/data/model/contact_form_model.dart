import 'package:flutter/material.dart';
import 'package:student_art_collection/core/util/api_constants.dart';
import 'package:student_art_collection/features/buy_art/domain/entity/contact_form.dart';

class ContactFormModel extends ContactForm {
  ContactFormModel({
    @required int artId,
    @required double price,
    @required String message,
    @required String buyerName,
    @required String email,
  }) : super(
            artId: artId,
            price: price,
            message: message,
            buyerName: buyerName,
            email: email);

  Map<String, dynamic> toJson(){
    return {
      CONTACT_FORM_ART_ID: artId,
      CONTACT_FORM_ART_PRICE: price,
      CONTACT_FORM_MESSAGE: message,
      CONTACT_FORM_EMAIL: email,
      CONTACT_FORM_BUYER_NAME: buyerName,
    };
  }

  factory ContactFormModel.fromJson(Map<String, dynamic> json) {
    return ContactFormModel(
      artId: json[CONTACT_FORM_ART_ID],
      price: json[CONTACT_FORM_ART_PRICE],
      message: json[CONTACT_FORM_MESSAGE],
      email: json[CONTACT_FORM_EMAIL],
      buyerName: json[CONTACT_FORM_BUYER_NAME],
    );
  }
}
