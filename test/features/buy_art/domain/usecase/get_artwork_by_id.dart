import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:student_art_collection/core/domain/entity/artwork.dart';
import 'package:student_art_collection/features/buy_art/domain/repository/buyer_artwork_repository.dart';
import 'package:student_art_collection/features/buy_art/domain/usecase/get_artwork_by_id.dart';

class MockArtworkRepository extends Mock implements ArtworkRepository {}

void main() {
  GetArtworkByID usecase;
  MockArtworkRepository mockArtworkRepository;

  setUp(() {
    mockArtworkRepository = MockArtworkRepository();
    usecase = GetArtworkByID(mockArtworkRepository);
  });
  final tIDNumber = 1;
  final tArtwork = Artwork(artId: 1, price: 25, schoolId: 2, images: [
    Image(artId: 1, imageId: 1, imageUrl: 'https://picsum.photos/200/300')
  ]);

  test('should get artwork matching the id from the repository', () async {
    //arrange
    when(mockArtworkRepository.getArtworkById(any)).thenAnswer((_) async => Right(tArtwork));
    //act
    final result = await usecase(tIDNumber);
    //assert
    expect(result, Right(tArtwork));
    verify(mockArtworkRepository.getArtworkById(tIDNumber));
    verifyNoMoreInteractions(mockArtworkRepository);
  });
}
