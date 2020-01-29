import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:student_art_collection/core/domain/entity/artwork.dart';
import 'package:student_art_collection/core/error/exception.dart';
import 'package:student_art_collection/core/error/failure.dart';
import 'package:student_art_collection/core/network/network_info.dart';
import 'package:student_art_collection/core/util/text_constants.dart';
import 'package:student_art_collection/features/buy_art/data/data_source/buyer_local_data_source.dart';
import 'package:student_art_collection/features/buy_art/data/data_source/buyer_remote_data_source.dart';
import 'package:student_art_collection/features/buy_art/domain/entity/contact_form.dart';
import 'package:student_art_collection/features/buy_art/domain/repository/buyer_artwork_repository.dart';
import 'package:meta/meta.dart';
import 'package:student_art_collection/features/buy_art/domain/usecase/get_all_artwork.dart';

class BuyerArtworkRepositoryImpl implements BuyerArtworkRepository {
  final BuyerRemoteDataSource remoteDataSource;
  final BuyerLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  BuyerArtworkRepositoryImpl(
      {@required this.remoteDataSource,
      @required this.localDataSource,
      @required this.networkInfo});

  @override
  Future<Either<Failure, List<Artwork>>> getAllArtwork(
      {SearchFilters searchFilters}) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteArtworkList =
            await remoteDataSource.getAllArtwork(searchFilters: searchFilters);
        localDataSource.cacheArtworkList(remoteArtworkList);
        return Right(remoteArtworkList);
      } on ServerException {
        return Left(ServerFailure());
      } on PlatformException {
        return Left(
          PlatformFailure(message: TEXT_GALLERY_CURRENT_ZIPCODE_ERROR_LABEL),
        );
      }
    } else {
      try {
        final localArtworkList = await localDataSource.getLastArtworkList();
        if (localArtworkList == null) {
          return Left(CacheFailure());
        }
        return Right(localArtworkList);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, ContactForm>> contactFormConfirmation(
      {ContactForm contactForm}) async {
    if (await networkInfo.isConnected) {
      try {
        final ContactForm result = await remoteDataSource
            .contactFormConfirmation(contactForm: contactForm);
        return Right(result);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ServerFailure());
    }
  }
}
