import 'package:dartz/dartz.dart';
import 'package:student_art_collection/core/domain/entity/artwork.dart';
import 'package:student_art_collection/core/error/exception.dart';
import 'package:student_art_collection/core/error/failure.dart';
import 'package:student_art_collection/core/network/network_info.dart';
import 'package:student_art_collection/features/buy_art/data/data_source/buyer_local_data_source.dart';
import 'package:student_art_collection/features/buy_art/data/data_source/buyer_remote_data_source.dart';
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
  Future<Either<Failure, Artwork>> getArtworkById(int id) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteArtwork = await remoteDataSource.getArtworkById(id);
        localDataSource.cacheArtwork(remoteArtwork);
        return Right(await remoteDataSource.getArtworkById(id));
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localArtwork = await localDataSource.getArtworkById(id);
        return Right(localArtwork);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
