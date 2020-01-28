import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_art_collection/core/presentation/widget/empty_container.dart';
import 'package:student_art_collection/features/list_art/presentation/bloc/profile/school_profile_bloc.dart';
import 'package:student_art_collection/features/list_art/presentation/bloc/profile/school_profile_state.dart';
import 'package:student_art_collection/features/list_art/presentation/widget/horizontal_progress_bar.dart';

import '../../../../service_locator.dart';

class SchoolProfilePage extends StatefulWidget {
  static const String ID = "school_profile";

  @override
  _SchoolProfilePageState createState() => _SchoolProfilePageState();
}

class _SchoolProfilePageState extends State<SchoolProfilePage> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  BuildContext _blocContext;

  @override
  Widget build(BuildContext context) => BlocProvider<SchoolProfileBloc>(
        create: (context) => sl<SchoolProfileBloc>(),
        child: Scaffold(
          appBar: AppBar(
            bottom: PreferredSize(
              preferredSize: Size(double.infinity, 1.0),
              child: BlocBuilder<SchoolProfileBloc, SchoolProfileState>(
                builder: (context, state) {
                  _blocContext = context;
                  if (state is SchoolProfileLoading) {
                    return AppBarLoading();
                  }
                  return EmptyContainer();
                },
              ),
            ),
            centerTitle: true,
            title: BlocBuilder<SchoolProfileBloc, SchoolProfileState>(
              builder: (context, state) {
                if (state is SchoolProfileInitial) {
                  return Text(
                    state.school.schoolName,
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  );
                } else if (state is SchoolProfileUpdated) {
                  return Text(
                    state.school.schoolName,
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  );
                } else {
                  return Text(
                    'Profile',
                    style: TextStyle(fontSize: 24),
                  );
                }
              },
            ),
          ),
          body: Container(),
        ),
      );
}
