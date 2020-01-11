import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:student_art_collection/core/domain/usecase/usecase.dart';
import 'package:student_art_collection/core/error/failure.dart';
import 'package:student_art_collection/features/list_art/domain/repository/school_artwork_repository.dart';

class HostImage implements UseCase<ReturnedImageUrl, File> {
  final SchoolArtworkRepository repository;

  HostImage(this.repository);

  @override
  Future<Either<Failure, ReturnedImageUrl>> call(File params) {
    return repository.hostImage(params);
  }
}

class ReturnedImageUrl implements Equatable {
  final String imageUrl;

  ReturnedImageUrl({
    this.imageUrl,
  });

  @override
  List<Object> get props => [imageUrl];
}
