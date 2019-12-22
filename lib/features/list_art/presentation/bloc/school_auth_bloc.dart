import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:student_art_collection/features/list_art/domain/usecase/login_school.dart';
import 'package:student_art_collection/features/list_art/domain/usecase/register_new_school.dart';
import 'package:student_art_collection/features/list_art/presentation/bloc/school_auth_event.dart';
import 'package:student_art_collection/features/list_art/presentation/bloc/school_auth_state.dart';
import 'package:meta/meta.dart';

class SchoolAuthBloc extends Bloc<SchoolAuthEvent, SchoolAuthState> {
  final LoginSchool loginSchool;
  final RegisterNewSchool registerNewSchool;

  SchoolAuthBloc({
    @required this.loginSchool,
    @required this.registerNewSchool,
  });

  @override
  SchoolAuthState get initialState => Unauthorized();

  @override
  Stream<SchoolAuthState> mapEventToState(
    SchoolAuthEvent event,
  ) async* {
    // TODO: Add Logic
  }
}
