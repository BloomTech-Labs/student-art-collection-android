import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:student_art_collection/core/session/session_manager.dart';
import 'package:student_art_collection/features/list_art/domain/usecase/update_school_info.dart';
import 'package:student_art_collection/features/list_art/presentation/bloc/auth/school_auth_state.dart';
import 'package:student_art_collection/features/list_art/presentation/bloc/profile/school_profile_event.dart';
import 'package:student_art_collection/features/list_art/presentation/bloc/profile/school_profile_state.dart';
import 'package:meta/meta.dart';

class SchoolProfileBloc extends Bloc<SchoolProfileEvent, SchoolProfileState> {
  final UpdateSchoolInfo updateSchoolInfo;
  final SessionManager sessionManager;

  SchoolProfileBloc({
    @required this.updateSchoolInfo,
    @required this.sessionManager,
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
  ) async* {}
}
