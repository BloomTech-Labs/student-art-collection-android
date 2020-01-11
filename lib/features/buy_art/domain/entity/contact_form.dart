import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ContactForm extends Equatable {
  final String sendTo;
  final String message;
  final String from;
  final String subject;
  final String name;

  ContactForm(
      {@required this.sendTo,
      @required this.message,
      @required this.from,
      @required this.subject,
      @required this.name});

  @override
  List<Object> get props =>
      [sendTo, name, message, from, subject];
}
