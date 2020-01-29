import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:student_art_collection/core/domain/entity/school.dart';
import 'package:student_art_collection/core/error/failure.dart';
import 'package:student_art_collection/core/session/session_manager.dart';
import 'package:student_art_collection/core/util/input_converter.dart';
import 'package:student_art_collection/features/list_art/domain/usecase/update_school_info.dart';
import 'package:student_art_collection/features/list_art/presentation/bloc/auth/school_auth_state.dart';
import 'package:student_art_collection/features/list_art/presentation/bloc/profile/school_profile_event.dart';
import 'package:student_art_collection/features/list_art/presentation/bloc/profile/school_profile_state.dart';
import 'package:meta/meta.dart';

class SchoolProfileBloc extends Bloc<SchoolProfileEvent, SchoolProfileState> {
  final UpdateSchoolInfo updateSchoolInfo;
  final SessionManager sessionManager;
  final InputConverter inputConverter;

  SchoolProfileBloc({
    @required this.updateSchoolInfo,
    @required this.sessionManager,
    @required this.inputConverter,
  });

  @override
  SchoolProfileState get initialState {
    final currentUser = sessionManager.currentUser;
    if (currentUser is Authorized) {
      return SchoolProfileInitial(
        school: currentUser.school,
      );
    } else {
      return SchoolProfileInitial();
    }
  }

  @override
  Stream<SchoolProfileState> mapEventToState(
    SchoolProfileEvent event,
  ) async* {
    final currentState = sessionManager.currentUser;
    if (currentState is Authorized) {
      final updateInfo = inputConverter.updateInfoToSchool(
        email: currentState.school.email,
        id: currentState.school.id,
        schoolName: currentState.school.schoolName,
        address: currentState.school.schoolName,
        city: currentState.school.city,
        zipcode: currentState.school.zipcode,
        state: currentState.school.state,
      );
      yield* updateInfo.fold(
        (failure) async* {
          yield SchoolProfileError(message: failure.message);
        },
        (school) async* {
          yield SchoolProfileLoading();
          final updatedSchool = await updateSchoolInfo(school);
          yield* _eitherUpdatedOrError(updatedSchool);
        },
      );
    }
  }

  Stream<SchoolProfileState> _eitherUpdatedOrError(
      Either<Failure, School> failureOrSchool) async* {
    yield* failureOrSchool.fold(
      (failure) async* {
        if (failure is CacheFailure) {
          yield SchoolProfileError(message: failure.message);
        } else if (failure is UserInputFailure) {
          yield SchoolProfileError(message: failure.message);
        } else {
          yield SchoolProfileError(message: 'Something went wrong');
        }
      },
      (school) async* {
        sessionManager.currentUser = Authorized(school: school);
        yield SchoolProfileUpdated(
          school: school,
        );
      },
    );
  }
}
