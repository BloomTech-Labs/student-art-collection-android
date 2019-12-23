import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:student_art_collection/core/domain/usecase/usecase.dart';
import 'package:student_art_collection/core/error/failure.dart';
import 'package:student_art_collection/core/util/Error.dart';
import 'package:student_art_collection/features/list_art/domain/repository/school_auth_repository.dart';
import 'package:student_art_collection/features/list_art/domain/usecase/login_school_on_return.dart';

import '../../mock/mock_classes.dart';
import '../../mock/mock_objects.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  LoginSchoolOnReturn usecase;
  MockSchoolAuthRepository mockSchoolAuthRepository;

  setUp(() {
    mockSchoolAuthRepository = MockSchoolAuthRepository();
    usecase = LoginSchoolOnReturn(mockSchoolAuthRepository);
  });

  test(
      'should return user school from repository if user was previously logged in',
      () async {
    when(mockSchoolAuthRepository.loginSchoolOnReturn())
        .thenAnswer((_) async => Right(tRegisteredSchool));

    final result = await usecase(NoParams());

    verify(mockSchoolAuthRepository.loginSchoolOnReturn());
    verifyNoMoreInteractions(mockSchoolAuthRepository);
    expect(result, Right(tRegisteredSchool));
  });

  test('should return FirebaseFailure if unable to login previous user',
      () async {
    when(mockSchoolAuthRepository.loginSchoolOnReturn())
        .thenAnswer((_) async => Left(FirebaseFailure(LOGIN_ON_RETURN_ERROR)));

    final result = await usecase(NoParams());

    verify(mockSchoolAuthRepository.loginSchoolOnReturn());
    verifyNoMoreInteractions(mockSchoolAuthRepository);
    expect(result, equals(Left(FirebaseFailure(LOGIN_ON_RETURN_ERROR))));
  });
}
