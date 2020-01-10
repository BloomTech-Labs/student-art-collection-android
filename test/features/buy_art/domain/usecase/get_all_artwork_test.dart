import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:student_art_collection/core/domain/entity/artwork.dart';
import 'package:student_art_collection/core/domain/usecase/usecase.dart';
import 'package:student_art_collection/features/buy_art/domain/repository/buyer_artwork_repository.dart';
import 'package:student_art_collection/features/buy_art/domain/usecase/get_all_artwork.dart';

class MockArtworkRepository extends Mock implements BuyerArtworkRepository {}

void main() {
  GetAllArtwork usecase;
  MockArtworkRepository mockArtworkRepository;

  setUp(() {
    mockArtworkRepository = MockArtworkRepository();
    usecase = GetAllArtwork(mockArtworkRepository);
  });

  final tImagesList = [
    Image(imageId: 1, artId: 1, imageUrl: 'https://picsum.photos/200/300'),
    Image(imageId: 2, artId: 1, imageUrl: 'https://picsum.photos/200/300')
  ];
  final tArtworkList = [
    Artwork(artId: 1, schoolId: 1, price: 25, images: tImagesList),
    Artwork(artId: 21, schoolId: 1, price: 25, images: tImagesList)
  ];

  test('should get all artwork from the repository', () async {
    //arrange
    when(mockArtworkRepository.getAllArtwork())
        .thenAnswer((_) async => Right(tArtworkList));
    //act
    final result = await usecase(NoParams());

    //assert
    expect(result, Right(tArtworkList));
    verify(mockArtworkRepository.getAllArtwork());
    verifyNoMoreInteractions(mockArtworkRepository);
  });
}
