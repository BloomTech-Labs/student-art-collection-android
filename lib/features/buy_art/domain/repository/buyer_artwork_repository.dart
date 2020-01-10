
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:student_art_collection/core/domain/entity/artwork.dart';
import 'package:student_art_collection/core/error/failure.dart';
import 'package:student_art_collection/features/buy_art/domain/entity/contact_form.dart';

abstract class ArtworkRepository{
  Future <Either<Failure, List<Artwork>>> getAllArtwork();
  Future <Either<Failure, bool>> contactFormConfirmation({@required ContactForm contactForm});
}