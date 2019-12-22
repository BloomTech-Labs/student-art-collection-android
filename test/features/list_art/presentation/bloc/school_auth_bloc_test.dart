import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:student_art_collection/features/list_art/domain/usecase/login_school.dart';
import 'package:student_art_collection/features/list_art/domain/usecase/register_new_school.dart';

class MockRegisterNewSchool extends Mock implements RegisterNewSchool {}

class MockLoginSchool extends Mock implements LoginSchool {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
}
