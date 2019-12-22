import 'package:firebase_auth/firebase_auth.dart';
import 'package:mockito/mockito.dart';
import 'package:student_art_collection/core/network/network_info.dart';
import 'package:student_art_collection/features/list_art/data/data_source/artco_remote_data_source.dart';
import 'package:student_art_collection/features/list_art/domain/repository/school_auth_repository.dart';

class MockRemoteDataSource extends Mock implements GraphQLRemoteDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockFirebaseUser extends Mock implements FirebaseUser {}

class MockAuthResult extends Mock implements AuthResult {}

class MockSchoolAuthRepository extends Mock implements SchoolAuthRepository {}