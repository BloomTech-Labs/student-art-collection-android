import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_art_collection/core/domain/entity/school.dart';
import 'package:student_art_collection/core/domain/usecase/usecase.dart';
import 'package:student_art_collection/core/error/failure.dart';
import 'package:student_art_collection/core/session/session_manager.dart';
import 'package:student_art_collection/core/util/input_converter.dart';
import 'package:student_art_collection/features/list_art/domain/usecase/login_school.dart';
import 'package:student_art_collection/features/list_art/domain/usecase/login_school_on_return.dart';
import 'package:student_art_collection/features/list_art/domain/usecase/logout_school.dart';
import 'package:student_art_collection/features/list_art/domain/usecase/register_new_school.dart';
import 'package:student_art_collection/features/list_art/presentation/bloc/auth/school_auth_event.dart';
import 'package:student_art_collection/features/list_art/presentation/bloc/auth/school_auth_state.dart';
import 'package:meta/meta.dart';

import '../../../../../service_locator.dart';

class SchoolAuthBloc extends Bloc<SchoolAuthEvent, SchoolAuthState> {
  final LoginSchool loginSchool;
  final RegisterNewSchool registerNewSchool;
  final LoginSchoolOnReturn loginSchoolOnReturn;
  final LogoutSchool logoutSchool;
  final InputConverter converter;
  final SessionManager sessionManager;

  SchoolAuthBloc({
    @required this.loginSchool,
    @required this.registerNewSchool,
    @required this.loginSchoolOnReturn,
    @required this.logoutSchool,
    @required this.converter,
    @required this.sessionManager,
  });

  @override
  SchoolAuthState get initialState => Unauthorized();

  @override
  Stream<SchoolAuthState> mapEventToState(
    SchoolAuthEvent event,
  ) async* {
    if (event is LoginSchoolEvent) {
      final credentials = converter.loginInfoToCredentials(
        email: event.email,
        password: event.password,
        shouldRemember: event.shouldRemember,
      );
      yield* credentials.fold(
        (failure) async* {
          yield SchoolAuthError(message: failure.message);
        },
        (credentials) async* {
          if (credentials.shouldRemember) {
            storeUserCredentials(credentials.email, credentials.password);
          }
          yield SchoolAuthLoading();
          final loginResult = await loginSchool(credentials);
          yield* _eitherAuthorizedOrErrorState(loginResult);
        },
      );
    }
    if (event is RegisterNewSchoolEvent) {
      final schoolToRegister = converter.registrationInfoToSchool(
        email: event.email,
        password: event.password,
        verifyPassword: event.verifyPassword,
        schoolName: event.schoolName,
        address: event.address,
        city: event.city,
        state: event.state,
        zipcode: event.zipcode,
      );
      yield* schoolToRegister.fold(
        (failure) async* {
          yield SchoolAuthError(message: failure.message);
        },
        (school) async* {
          yield SchoolAuthLoading();
          final registrationResult = await registerNewSchool(school);
          yield* _eitherAuthorizedOrErrorState(registrationResult);
        },
      );
    }
    if (event is LoginOnReturnEvent) {
      yield SchoolAuthLoading();
      final loginResult = await loginSchoolOnReturn(NoParams());
      yield* _eitherAuthorizedOrErrorReturn(loginResult);
    }
    if (event is LogoutSchool) {
      yield SchoolAuthLoading();
      final logoutResult = await logoutSchool(NoParams());
      yield logoutResult.fold((failure) {
        if (failure is FirebaseFailure)
          return SchoolAuthError(message: failure.message);
        return SchoolAuthError(message: 'Something went wrong');
      }, (success) {
        return Unauthorized();
      });
    }
  }

  Stream<SchoolAuthState> _eitherAuthorizedOrErrorState(
      Either<Failure, School> failureOrSchool) async* {
    yield failureOrSchool.fold(
      (failure) {
        if (failure is FirebaseFailure)
          return SchoolAuthError(message: failure.message);
        return SchoolAuthError(message: 'Something went wrong');
      },
      (school) {
        sessionManager.currentUser = Authorized(school: school);
        storeSchoolInfo();
        return Authorized(
          school: school,
        );
      },
    );
  }

  Stream<SchoolAuthState> _eitherAuthorizedOrErrorReturn(
      Either<Failure, String> failureOrSchool) async* {
    yield failureOrSchool.fold(
      (failure) {
        if (failure is FirebaseFailure)
          return SchoolAuthError(message: failure.message);
        return SchoolAuthError(message: 'Something went wrong');
      },
      (uid) {
        final school = School(
          id: sl<SharedPreferences>().getInt('id' ?? ''),
          schoolId: sl<SharedPreferences>().getString('uid' ?? ''),
          email: sl<SharedPreferences>().getString('schoolEmail' ?? ''),
          address: sl<SharedPreferences>().getString('address' ?? ''),
          city: sl<SharedPreferences>().getString('city' ?? ''),
          state: sl<SharedPreferences>().getString('state' ?? ''),
          zipcode: sl<SharedPreferences>().getString('zipcode' ?? ''),
        );
        sessionManager.currentUser = Authorized(school: school);
        return sessionManager.currentUser;
      },
    );
  }

  void storeUserCredentials(String email, String password) {
    sl<SharedPreferences>().setString('email', email);
    sl<SharedPreferences>().setString('password', password);
  }

  void storeSchoolInfo() {
    final currentUser = sessionManager.currentUser;
    if (currentUser is Authorized) {
      sl<SharedPreferences>().setInt('id', currentUser.school.id);
      sl<SharedPreferences>().setString('uid', currentUser.school.schoolId);
      sl<SharedPreferences>()
          .setString('schoolName', currentUser.school.schoolName);
      sl<SharedPreferences>()
          .setString('schoolEmail', currentUser.school.email);
      sl<SharedPreferences>().setString('address', currentUser.school.address);
      sl<SharedPreferences>().setString('state', currentUser.school.state);
      sl<SharedPreferences>().setString('zipcode', currentUser.school.zipcode);
    }
  }
}
