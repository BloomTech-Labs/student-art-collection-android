import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:student_art_collection/core/domain/entity/school.dart';
import 'package:student_art_collection/core/error/failure.dart';
import 'package:student_art_collection/core/util/input_converter.dart';
import 'package:student_art_collection/features/list_art/domain/usecase/login_school.dart';
import 'package:student_art_collection/features/list_art/domain/usecase/login_school_on_return.dart';
import 'package:student_art_collection/features/list_art/domain/usecase/logout_school.dart';
import 'package:student_art_collection/features/list_art/domain/usecase/register_new_school.dart';
import 'package:student_art_collection/features/list_art/presentation/bloc/school_auth_event.dart';
import 'package:student_art_collection/features/list_art/presentation/bloc/school_auth_state.dart';
import 'package:meta/meta.dart';

class SchoolAuthBloc extends Bloc<SchoolAuthEvent, SchoolAuthState> {
  final LoginSchool loginSchool;
  final RegisterNewSchool registerNewSchool;
  final LoginSchoolOnReturn loginSchoolOnReturn;
  final LogoutSchool logoutSchool;
  final InputConverter converter;

  SchoolAuthBloc({
    @required this.loginSchool,
    @required this.registerNewSchool,
    @required this.loginSchoolOnReturn,
    @required this.logoutSchool,
    @required this.converter,
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
      );
      yield* credentials.fold(
        (failure) async* {
          yield Error(message: failure.message);
        },
        (credentials) async* {
          yield Loading();
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
          yield Error(message: failure.message);
        },
        (school) async* {
          yield Loading();
          final registrationResult = await registerNewSchool(school);
          yield* _eitherAuthorizedOrErrorState(registrationResult);
        },
      );
    }
  }

  Stream<SchoolAuthState> _eitherAuthorizedOrErrorState(
      Either<Failure, School> failureOrSchool) async* {
    yield failureOrSchool.fold(
        (failure) => Error(message: 'Something went wrong'),
        (school) => Authorized(
              school: school,
            ));
  }
}
