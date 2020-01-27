import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:student_art_collection/core/domain/entity/artwork.dart';
import 'package:student_art_collection/core/domain/usecase/usecase.dart';
import 'package:student_art_collection/core/error/failure.dart';
import 'package:student_art_collection/core/presentation/bloc/base_artwork_filter_type.dart';
import 'package:student_art_collection/features/buy_art/domain/repository/buyer_artwork_repository.dart';

class GetArtwork implements UseCase<List<Artwork>, SearchFilters> {
  final BuyerArtworkRepository artworkRepository;

  GetArtwork(this.artworkRepository);

  @override
  Future<Either<Failure, List<Artwork>>> call(SearchFilters filters) async {
    return await artworkRepository.getAllArtwork(searchFilters: filters);
  }
}

class SearchFilters extends Equatable {
  final String searchQuery;
  final bool zipcode;
  final int category;

  const SearchFilters({
    this.zipcode,
    this.searchQuery,
    this.category,
  });

  @override
  List<Object> get props => [
        searchQuery,
        zipcode,
        category,
      ];
}
