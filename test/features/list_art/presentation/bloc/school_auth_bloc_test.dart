import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:student_art_collection/core/util/input_converter.dart';
import 'package:student_art_collection/features/list_art/domain/usecase/login_school.dart';
import 'package:student_art_collection/features/list_art/domain/usecase/login_school_on_return.dart';
import 'package:student_art_collection/features/list_art/domain/usecase/logout_school.dart';
import 'package:student_art_collection/features/list_art/domain/usecase/register_new_school.dart';
import 'package:student_art_collection/features/list_art/presentation/bloc/auth/school_auth_bloc.dart';
import 'package:student_art_collection/features/list_art/presentation/bloc/auth/school_auth_state.dart';

class MockRegisterNewSchool extends Mock implements RegisterNewSchool {}

class MockLoginSchool extends Mock implements LoginSchool {}

class MockLogoutSchool extends Mock implements LogoutSchool {}

class MockLoginSchoolOnReturn extends Mock implements LoginSchoolOnReturn {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SchoolAuthBloc bloc;
  MockLoginSchool mockLoginSchool;
  MockRegisterNewSchool mockRegisterNewSchool;
  MockLogoutSchool mockLogoutSchool;
  MockLoginSchoolOnReturn mockLoginSchoolOnReturn;
  MockInputConverter mockInputConverter;

  setUp(() {
    mockInputConverter = MockInputConverter();
    mockLoginSchool = MockLoginSchool();
    mockRegisterNewSchool = MockRegisterNewSchool();
    mockLogoutSchool = MockLogoutSchool();
    mockLoginSchoolOnReturn = MockLoginSchoolOnReturn();
    bloc = SchoolAuthBloc(
      loginSchool: mockLoginSchool,
      registerNewSchool: mockRegisterNewSchool,
      logoutSchool: mockLogoutSchool,
      loginSchoolOnReturn: mockLoginSchoolOnReturn,
      converter: mockInputConverter,
    );
  });

  test('Initial state should be Unauthorized', () {
    expect(bloc.initialState, equals(Unauthorized()));
  });
}
