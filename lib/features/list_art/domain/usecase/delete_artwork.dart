import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:student_art_collection/core/domain/entity/artwork.dart';
import 'package:student_art_collection/core/domain/usecase/usecase.dart';
import 'package:student_art_collection/core/error/failure.dart';
import 'package:student_art_collection/features/list_art/domain/repository/school_artwork_repository.dart';

class DeleteArtwork implements UseCase<ArtworkToDeleteId, ArtworkToDeleteId> {
  final SchoolArtworkRepository repository;

  DeleteArtwork(this.repository);

  @override
  Future<Either<Failure, ArtworkToDeleteId>> call(ArtworkToDeleteId params) {
    return repository.deleteArtwork(params);
  }
}

class ArtworkToDeleteId extends Equatable {
  final int artId;

  ArtworkToDeleteId({this.artId});

  @override
  List<Object> get props => [artId];
}
