import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ContactForm extends Equatable {
  final String sendTo;
  final String message;
  final String from;
  final String subject;
  final String name;

  ContactForm({this.sendTo, this.message, this.from, this.subject, this.name});



  @override
  // TODO: implement props
  List<Object> get props => [
  ];
}
