import 'package:flutter_test/flutter_test.dart';
import 'package:student_art_collection/core/domain/entity/artwork.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('Artwork entity', () {
    final tImages1 = [Image(artId: 1, imageUrl: 'Test url', imageId: 1)];
    final tImages2 = [Image(artId: 1, imageUrl: 'Test url', imageId: 1)];

    final tCategory = Category(categoryId: 1, categoryName: 'Test category');

    final Artwork tArtwork1 = Artwork(
        artId: 1,
        images: tImages1,
        price: 20.00,
        schoolId: 1,
        category: tCategory);

    final Artwork tArtwork2 = Artwork(
        artId: 1,
        images: tImages2,
        price: 20.00,
        schoolId: 1,
        category: tCategory);

    test(
        'Multiple Artwork entities with identical properties and shared Category and Images shoudld be regarded as equal by Equatable',
        () {
      expect(tArtwork1, equals(tArtwork2));
    });
  });
}
