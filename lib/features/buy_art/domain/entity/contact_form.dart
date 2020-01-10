import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ContactForm extends Equatable {
  final int artId;
  final String message;
  final String buyerName;
  final String email;
  final double price;

  ContactForm(
      {@required this.artId,
      @required this.message,
      @required this.buyerName,
      @required this.email,
      @required this.price});

  @override
  // TODO: implement props
  List<Object> get props => [
    artId,
    message,
    buyerName,
    email,
    price,
  ];
}
