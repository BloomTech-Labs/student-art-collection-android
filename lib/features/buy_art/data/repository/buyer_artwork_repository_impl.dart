import 'package:dartz/dartz.dart';
import 'package:student_art_collection/core/domain/entity/artwork.dart';
import 'package:student_art_collection/core/error/exception.dart';
import 'package:student_art_collection/core/error/failure.dart';
import 'package:student_art_collection/core/network/network_info.dart';
import 'package:student_art_collection/features/buy_art/data/data_source/buyer_local_data_source.dart';
import 'package:student_art_collection/features/buy_art/data/data_source/buyer_remote_data_source.dart';
import 'package:student_art_collection/features/buy_art/domain/entity/contact_form.dart';
import 'package:student_art_collection/features/buy_art/domain/repository/buyer_artwork_repository.dart';
import 'package:meta/meta.dart';

class ArtworkRepositoryImpl implements ArtworkRepository {
  final BuyerRemoteDataSource remoteDataSource;
  final BuyerLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  ArtworkRepositoryImpl(
      {@required this.remoteDataSource,
      @required this.localDataSource,
      @required this.networkInfo});

  @override
  Future<Either<Failure, List<Artwork>>> getAllArtwork() async {
    // TODO: implement getAllArtwork
    if (await networkInfo.isConnected) {
      try {
        final remoteArtworkList = await remoteDataSource.getAllArtwork();
        localDataSource.cacheArtworkList(remoteArtworkList);
        return Right(await remoteDataSource.getAllArtwork());
    } on ServerException {
    return Left(ServerFailure());
    }
    } else {
    try {
    final localArtworkList = await localDataSource.getLastArtworkList();
    return Right(localArtworkList);
    } on CacheException {
    return Left(CacheFailure());
    }
    }
  }

  @override
  Future<Either<Failure, bool>> contactFormConfirmation({ContactForm contactForm}) async {
    if (await networkInfo.isConnected) {
      try {
        final bool result = await remoteDataSource.contactFormConfirmation(contactForm: contactForm);
        return Right(result);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      //todo: Setup Queueing Service
      return Left(ServerFailure());
    }
  }
}
