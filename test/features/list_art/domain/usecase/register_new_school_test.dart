import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:student_art_collection/core/domain/entity/school.dart';
import 'package:student_art_collection/features/list_art/domain/repository/school_auth_repository.dart';
import 'package:student_art_collection/features/list_art/domain/usecase/register_new_school.dart';

import '../../mock/mock_classes.dart';
import '../../mock/mock_objects.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  RegisterNewSchool usecase;
  MockSchoolAuthRepository mockSchoolAuthRepository;

  setUp(() {
    mockSchoolAuthRepository = MockSchoolAuthRepository();
    usecase = RegisterNewSchool(mockSchoolAuthRepository);
  });

  test(
      'should get registered school from repository when school to register is sent',
      () async {
    when(mockSchoolAuthRepository.registerNewSchool(any))
        .thenAnswer((_) async => Right(tRegisteredSchool));

    final result = await usecase(tSchoolToRegister);

    expect(result, equals(Right(tRegisteredSchool)));
    verify(mockSchoolAuthRepository.registerNewSchool(tSchoolToRegister));
    verifyNoMoreInteractions(mockSchoolAuthRepository);
  });
}
