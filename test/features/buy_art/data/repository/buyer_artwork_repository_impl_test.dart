import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:student_art_collection/core/data/model/artwork_model.dart';
import 'package:student_art_collection/core/data/model/category_model.dart';
import 'package:student_art_collection/core/data/model/image_model.dart';
import 'package:student_art_collection/core/error/exception.dart';
import 'package:student_art_collection/core/error/failure.dart';
import 'package:student_art_collection/core/network/network_info.dart';
import 'package:student_art_collection/features/buy_art/data/data_source/buyer_local_data_source.dart';
import 'package:student_art_collection/features/buy_art/data/data_source/buyer_remote_data_source.dart';
import 'package:student_art_collection/features/buy_art/data/repository/buyer_artwork_repository_impl.dart';
import 'package:student_art_collection/features/buy_art/domain/entity/contact_form.dart';

class MockRemoteDataSource extends Mock implements BuyerRemoteDataSource {}

class MockLocalDataSource extends Mock implements BuyerLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  BuyerArtworkRepositoryImpl repository;
  MockRemoteDataSource mockRemoteDataSource;
  MockLocalDataSource mockLocalDataSource;
  MockNetworkInfo mockNetworkInfo;

  final tID = 1;
  final tImageList = [
    ImageModel(imageId: 1, imageUrl: 'https://picsum.photos/200/300', artId: 1)
  ];

  final tCategory = CategoryModel(
    categoryId: 1,
    categoryName: 'test',
  );

  final tArtworkModel = ArtworkModel(
      artId: tID,
      artistName: "name",
      category: tCategory,
      images: tImageList,
      price: 25.50,
      schoolId: 1,
      sold: false,
      description: "description",
      title: "title");

  final tContactForm = ContactForm(
    artId: tID,
    email: 'test@gmail.com',
    buyerName: 'test',
    price: 50,
    message: 'test'
  );

  setUp(() {
    mockNetworkInfo = MockNetworkInfo();
    mockLocalDataSource = MockLocalDataSource();
    mockRemoteDataSource = MockRemoteDataSource();
    repository = BuyerArtworkRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  group('getAllArtwork', () {
    List<ArtworkModel> tArtworkList = [tArtworkModel];

    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
          'should return remote data when the call to remote data source is successful',
          () async {
        //arrange
        when(mockRemoteDataSource.getAllArtwork())
            .thenAnswer((_) async => tArtworkList);
        //act
        final result = await repository.getAllArtwork();
        //assert
        verify(mockRemoteDataSource.getAllArtwork());
        expect(result, equals(Right(tArtworkList)));
      });

      test(
          'should cache the data locally when the call to remote data source is succesful',
          () async {
        //arrange
        when(mockRemoteDataSource.getAllArtwork())
            .thenAnswer((_) async => tArtworkList);
        //act
        await repository.getAllArtwork();
        //assert
        verify(mockRemoteDataSource.getAllArtwork());
        verify(mockLocalDataSource.cacheArtworkList(tArtworkList));
      });

      test(
          'should return server failure when the call to remote data source is unsuccesful',
          () async {
        //arrange
        when(mockRemoteDataSource.getAllArtwork()).thenThrow(ServerException());
        //act
        final result = await repository.getAllArtwork();
        //assert
        verify(mockRemoteDataSource.getAllArtwork());
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(Left(ServerFailure())));
      });
    });

    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test(
          'should return requested locally cached data when cached data is present',
          () async {
        //arrange
        when(mockLocalDataSource.getLastArtworkList())
            .thenAnswer((_) async => tArtworkList);
        //act
        final result = await repository.getAllArtwork();
        //assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastArtworkList());
        expect(result, equals(Right(tArtworkList)));
      });

      test(
          'should return CacheFailure when device is offline and no cached data is present',
          () async {
        //arrange
        when(mockLocalDataSource.getLastArtworkList()).thenThrow(CacheException());
        //act
        final result = await repository.getAllArtwork();
        //assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastArtworkList());
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });

  group('contactFormSubmit', () {

    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
          'should return remote data when the call to remote data source is successful',
              () async {
            //arrange
            when(mockRemoteDataSource.contactFormConfirmation(contactForm: tContactForm))
                .thenAnswer((_) async => tContactForm);
            //act
            final result = await repository.contactFormConfirmation(contactForm: tContactForm);
            //assert
            verify(mockRemoteDataSource.contactFormConfirmation(contactForm: tContactForm));
            expect(result, equals(Right(tContactForm)));
          });


      test(
          'should return server failure when the call to remote data source is unsuccesful',
              () async {
            //arrange
            when(mockRemoteDataSource.contactFormConfirmation(contactForm: tContactForm)).thenThrow(ServerException());
            //act
            final result = await repository.contactFormConfirmation(contactForm: tContactForm);
            //assert
            verify(mockRemoteDataSource.contactFormConfirmation(contactForm: tContactForm));
            verifyZeroInteractions(mockLocalDataSource);
            expect(result, equals(Left(ServerFailure())));
          });
    });

    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test(
          'should return ServerFailure when device is offline',
              () async {
            //arrange
            when(mockRemoteDataSource.contactFormConfirmation(contactForm: tContactForm)).thenThrow(ServerFailure());
            //act
            final result = await repository.contactFormConfirmation(contactForm:tContactForm );
            //assert
            expect(result, equals(Left(ServerFailure())));
          });
    });
  });



}
