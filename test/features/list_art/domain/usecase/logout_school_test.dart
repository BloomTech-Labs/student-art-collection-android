import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:student_art_collection/core/domain/usecase/usecase.dart';
import 'package:student_art_collection/features/list_art/domain/repository/school_auth_repository.dart';
import 'package:student_art_collection/features/list_art/domain/usecase/logout_school.dart';

import '../../mock/mock_classes.dart';
import 'login_school_test.dart';


void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  LogoutSchool usecase;
  MockSchoolAuthRepository mockSchoolAuthRepository;

  setUp(() {
    mockSchoolAuthRepository = MockSchoolAuthRepository();
    usecase = LogoutSchool(mockSchoolAuthRepository);
  });

  void logoutSuccess() {
    when(mockSchoolAuthRepository.logoutSchool())
        .thenAnswer((_) async => Right(true));
  }

  test('should call repository.logoutSchool()', () async {
    logoutSuccess();

    await usecase(NoParams());

    verify(mockSchoolAuthRepository.logoutSchool());
  });

  test('should successfully logout school', () async {
    logoutSuccess();

    final result = await usecase(NoParams());

    expect(result, Right(true));
    verify(mockSchoolAuthRepository.logoutSchool());
    verifyNoMoreInteractions(mockSchoolAuthRepository);
  });
}
