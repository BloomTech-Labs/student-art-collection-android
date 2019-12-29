import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_art_collection/features/list_art/presentation/bloc/school_auth_bloc.dart';

import '../../../../service_locator.dart';

class SchoolLoginPage extends StatelessWidget {
  static const String ID = "login";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
    );
  }

  BlocProvider<SchoolAuthBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SchoolAuthBloc>(),
    );
  }
}
