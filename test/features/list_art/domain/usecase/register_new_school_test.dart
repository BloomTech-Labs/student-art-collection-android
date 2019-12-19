import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:student_art_collection/core/domain/entity/school.dart';
import 'package:student_art_collection/features/list_art/domain/repository/school_auth_repository.dart';
import 'package:student_art_collection/features/list_art/domain/usecase/register_new_school.dart';

class MockSchoolAuthRepository extends Mock implements SchoolAuthRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  RegisterNewSchool usecase;
  MockSchoolAuthRepository mockSchoolAuthRepository;

  setUp(() {
    mockSchoolAuthRepository = MockSchoolAuthRepository();
    usecase = RegisterNewSchool(mockSchoolAuthRepository);
  });

  final tSchoolToRegister = SchoolToRegister(
      email: 'test@test.com',
      password: 'password',
      schoolName: 'test',
      address: 'test',
      city: 'test',
      state: 'test',
      zipcode: 'test');

  final tRegisteredSchool = School(
      id: 1,
      schoolId: 'test',
      email: 'test@test.com',
      schoolName: 'test',
      address: 'test',
      city: 'test',
      state: 'test',
      zipcode: 'test');

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
