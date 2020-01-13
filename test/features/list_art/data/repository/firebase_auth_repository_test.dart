import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:student_art_collection/core/data/model/school_model.dart';
import 'package:student_art_collection/core/domain/entity/school.dart';
import 'package:student_art_collection/core/error/exception.dart';
import 'package:student_art_collection/core/error/failure.dart';
import 'package:student_art_collection/core/network/network_info.dart';
import 'package:student_art_collection/core/util/error.dart';
import 'package:student_art_collection/features/list_art/data/data_source/school_remote_data_source.dart';
import 'package:student_art_collection/features/list_art/data/repository/firebase_auth_repository.dart';
import 'package:student_art_collection/features/list_art/domain/usecase/login_school.dart';
import 'package:student_art_collection/features/list_art/domain/usecase/register_new_school.dart';

import '../../mock/mock_classes.dart';
import '../../mock/mock_objects.dart';

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

  final School tSchool = tSchoolModel;

  group('registerNewSchool', () {
    void createNewUserSuccess() {
      when(mockFirebaseAuth.createUserWithEmailAndPassword(
              email: tSchoolToRegister.email,
              password: tSchoolToRegister.password))
          .thenAnswer((_) async => mockAuthResult);
      when(mockAuthResult.user).thenReturn(mockFirebaseUser);
      when(mockFirebaseUser.uid).thenReturn('test');
    }

    test('should check if the device is online', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      createNewUserSuccess();

      repository.registerNewSchool(tSchoolToRegister);

      verify(mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      test('should call firebaseAuth.createUserWithEmailAndPassword', () async {
        createNewUserSuccess();

        final result = await repository.registerNewSchool(tSchoolToRegister);

        verify(mockFirebaseAuth.createUserWithEmailAndPassword(
                email: tSchoolToRegister.email,
                password: tSchoolToRegister.password))
            .called(1);
      });

      test(
          'should return FirebaseFailure when Firebase registration attempt is unsuccessful',
          () async {
        when(mockFirebaseAuth.createUserWithEmailAndPassword(
                email: tSchoolToRegister.email,
                password: tSchoolToRegister.password))
            .thenThrow(
                PlatformException(code: '1', message: 'Could not sign in'));

        final result = await repository.registerNewSchool(tSchoolToRegister);

        verify(mockFirebaseAuth.createUserWithEmailAndPassword(
                email: tSchoolToRegister.email,
                password: tSchoolToRegister.password))
            .called(1);

        expect(result, Left(FirebaseFailure('Could not sign in')));
      });

      test(
          'should return a School\'s information when registration is successful',
          () async {
        createNewUserSuccess();

        when(mockRemoteDataSource.registerNewSchool(any))
            .thenAnswer((_) async => tSchoolModel);

        final result = await repository.registerNewSchool(tSchoolToRegister);

        verify(mockRemoteDataSource.registerNewSchool(tSchoolToRegister));
        expect(result, Right(tSchool));
      });
    });

    runTestsOffline(() {
      test(
          'should return NetworkFailure with no cached data when network is down',
          () async {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

        final result = await repository.registerNewSchool(tSchoolToRegister);

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

  group('logoutSchool', () {
    test('should log out school when and nullify current FirebaseUser',
        () async {
      when(mockFirebaseAuth.signOut()).thenAnswer((_) async => null);
      when(mockFirebaseAuth.currentUser()).thenAnswer((_) async => null);

      final result = await repository.logoutSchool();

      verify(mockFirebaseAuth.signOut());
      expect(result, Right(true));
    });
  });

  group('loginSchoolOnReturn', () {
    test('should return FirebaseFailure when unable to login school on return',
        () async {
      when(mockFirebaseAuth.currentUser()).thenAnswer((_) async => null);

      final result = await repository.loginSchoolOnReturn();

      verify(mockFirebaseAuth.currentUser());
      expect(result, Left(FirebaseFailure(LOGIN_ON_RETURN_ERROR)));
    });
  });
}
