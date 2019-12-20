import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:student_art_collection/core/data/model/school_model.dart';
import 'package:student_art_collection/core/domain/entity/school.dart';
import 'package:student_art_collection/core/error/failure.dart';
import 'package:student_art_collection/core/network/network_info.dart';
import 'package:student_art_collection/features/list_art/data/data_source/artco_remote_data_source.dart';
import 'package:student_art_collection/features/list_art/data/repository/firebase_auth_repository.dart';
import 'package:student_art_collection/features/list_art/domain/usecase/login_school.dart';
import 'package:student_art_collection/features/list_art/domain/usecase/register_new_school.dart';

class MockRemoteDataSource extends Mock implements GraphQLRemoteDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockFirebaseUser extends Mock implements FirebaseUser {}

class MockAuthResult extends Mock implements AuthResult {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  FirebaseAuthRepository repository;
  MockRemoteDataSource mockRemoteDataSource;
  MockNetworkInfo mockNetworkInfo;
  MockFirebaseAuth mockFirebaseAuth;
  MockAuthResult mockAuthResult;
  MockFirebaseUser mockFirebaseUser;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    mockFirebaseAuth = MockFirebaseAuth();
    mockAuthResult = MockAuthResult();
    mockFirebaseUser = MockFirebaseUser();

    repository = FirebaseAuthRepository(
        networkInfo: mockNetworkInfo,
        remoteDataSource: mockRemoteDataSource,
        firebaseAuth: mockFirebaseAuth);
  });

  void runTestsOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });
      body();
    });
  }

  void runTestsOffline(Function body) {
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });
      body();
    });
  }

  final SchoolModel tSchoolModel = SchoolModel(
      id: 1,
      schoolId: 'test',
      email: 'test@test.com',
      schoolName: 'test',
      address: 'test',
      city: 'test',
      state: 'test',
      zipcode: 'test');

  final School tSchool = tSchoolModel;

  group('registerNewSchool', () {
    final schoolToRegister = SchoolToRegister(
      schoolId: 'test',
      email: 'test',
      password: 'test',
      schoolName: 'test',
      address: 'test',
      city: 'test',
      state: 'test',
      zipcode: 'test',
    );

    void createNewUserSuccess() {
      when(mockFirebaseAuth.createUserWithEmailAndPassword(
              email: schoolToRegister.email,
              password: schoolToRegister.password))
          .thenAnswer((_) async => mockAuthResult);
      when(mockAuthResult.user).thenReturn(mockFirebaseUser);
      when(mockFirebaseUser.uid).thenReturn('test');
    }

    test('should check if the device is online', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      createNewUserSuccess();

      repository.registerNewSchool(schoolToRegister);

      verify(mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      test('should call firebaseAuth.createUserWithEmailAndPassword', () async {
        createNewUserSuccess();

        final result = await repository.registerNewSchool(schoolToRegister);

        verify(mockFirebaseAuth.createUserWithEmailAndPassword(
                email: schoolToRegister.email,
                password: schoolToRegister.password))
            .called(1);
      });

      test(
          'should return FirebaseFailure when Firebase registration attempt is unsuccessful',
          () async {
        when(mockFirebaseAuth.createUserWithEmailAndPassword(
                email: schoolToRegister.email,
                password: schoolToRegister.password))
            .thenThrow(
                PlatformException(code: '1', message: 'Could not sign in'));

        final result = await repository.registerNewSchool(schoolToRegister);

        verify(mockFirebaseAuth.createUserWithEmailAndPassword(
                email: schoolToRegister.email,
                password: schoolToRegister.password))
            .called(1);

        expect(result, Left(FirebaseFailure('Could not sign in')));
      });

      test(
          'should return a School\'s information when registration is successful',
          () async {
        createNewUserSuccess();

        when(mockRemoteDataSource.registerNewSchool(any))
            .thenAnswer((_) async => tSchoolModel);

        final result = await repository.registerNewSchool(schoolToRegister);

        verify(mockRemoteDataSource.registerNewSchool(schoolToRegister));
        expect(result, Right(tSchool));
      });
    });

    runTestsOffline(() {
      test(
          'should return NetworkFailure with no cached data when network is down',
          () async {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

        final result = await repository.registerNewSchool(schoolToRegister);

        expect(result, Left(NetworkFailure()));
      });
    });
  });

  group('loginSchool', () {
    final credentials = Credentials(email: 'test', password: 'test');

    void signInUserSuccess() {
      when(mockFirebaseAuth.signInWithEmailAndPassword(
        email: credentials.email,
        password: credentials.password,
      )).thenAnswer((_) async => mockAuthResult);
      when(mockAuthResult.user).thenReturn(mockFirebaseUser);
      when(mockFirebaseUser.uid).thenReturn('test');
    }

    test('should check if the device is online', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      signInUserSuccess();

      await repository.loginSchool(credentials);

      verify(mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      test('should call firebaseAuth.createUserWithEmailAndPassword', () async {
        signInUserSuccess();

        final result = await repository.loginSchool(credentials);

        verify(mockFirebaseAuth.signInWithEmailAndPassword(
                email: credentials.email, password: credentials.password))
            .called(1);
      });

      test(
          'should return FirebaseFailure when Firebase registration attempt is unsuccessful',
          () async {
        when(mockFirebaseAuth.signInWithEmailAndPassword(
                email: credentials.email, password: credentials.password))
            .thenThrow(
                PlatformException(code: '1', message: 'Could not sign in'));

        final result = await repository.loginSchool(credentials);

        verify(mockFirebaseAuth.signInWithEmailAndPassword(
                email: credentials.email, password: credentials.password))
            .called(1);

        expect(result, Left(FirebaseFailure('Could not sign in')));
      });

      test(
          'should return a School\'s information when registration is successful',
          () async {
        signInUserSuccess();

        when(mockRemoteDataSource.loginSchool(any))
            .thenAnswer((_) async => tSchoolModel);

        final result = await repository.loginSchool(credentials);

        verify(mockRemoteDataSource.loginSchool(any));
        expect(result, Right(tSchool));
      });
    });
  });
}
