import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:student_art_collection/core/domain/entity/school.dart';
import 'package:student_art_collection/features/list_art/domain/repository/school_auth_repository.dart';
import 'package:student_art_collection/features/list_art/domain/usecase/login_school.dart';

class MockSchoolAuthRepository extends Mock implements SchoolAuthRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  LoginSchool usecase;
  MockSchoolAuthRepository mockSchoolAuthRepository;

  setUp(() {
    mockSchoolAuthRepository = MockSchoolAuthRepository();
    usecase = LoginSchool(mockSchoolAuthRepository);
  });

  final tCredentials = Credentials(email: 'test', password: 'test');

  final tSchool = School(
      id: 1,
      schoolId: 'test',
      email: 'test@test.com',
      password: 'password',
      schoolName: 'test',
      address: 'test',
      city: 'test',
      state: 'test',
      zipcode: 'test');

  test(
      'should get registered school from repository when school to register is sent',
      () async {
    when(mockSchoolAuthRepository.loginSchool(any))
        .thenAnswer((_) async => Right(tSchool));

    final result = await usecase(tCredentials);

    expect(result, equals(Right(tSchool)));
    verify(mockSchoolAuthRepository.loginSchool(tCredentials));
    verifyNoMoreInteractions(mockSchoolAuthRepository);
  });
}
