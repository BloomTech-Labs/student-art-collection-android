import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:student_art_collection/features/list_art/domain/repository/school_auth_repository.dart';
import 'package:student_art_collection/features/list_art/domain/usecase/login_school_on_return.dart';

import '../../mock/mock_classes.dart';


void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  LoginSchoolOnReturn usecase;
  MockSchoolAuthRepository mockSchoolAuthRepository;

  setUp(() {
    mockSchoolAuthRepository = MockSchoolAuthRepository();
    usecase = LoginSchoolOnReturn(mockSchoolAuthRepository);
  });
}
