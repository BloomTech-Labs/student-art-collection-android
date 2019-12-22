import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:student_art_collection/core/domain/entity/school.dart';
import 'package:student_art_collection/features/list_art/domain/repository/school_auth_repository.dart';
import 'package:student_art_collection/features/list_art/domain/usecase/login_school.dart';

import '../../mock/mock_classes.dart';
import '../../mock/mock_objects.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  LoginSchool usecase;
  MockSchoolAuthRepository mockSchoolAuthRepository;

  setUp(() {
    mockSchoolAuthRepository = MockSchoolAuthRepository();
    usecase = LoginSchool(mockSchoolAuthRepository);
  });

  final tCredentials = Credentials(email: 'test', password: 'test');

  test(
      'should get registered school from repository when school to register is sent',
      () async {
    when(mockSchoolAuthRepository.loginSchool(any))
        .thenAnswer((_) async => Right(tRegisteredSchool));

    final result = await usecase(tCredentials);

    expect(result, equals(Right(tRegisteredSchool)));
    verify(mockSchoolAuthRepository.loginSchool(tCredentials));
    verifyNoMoreInteractions(mockSchoolAuthRepository);
  });
}
