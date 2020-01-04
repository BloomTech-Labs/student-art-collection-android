import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_art_collection/core/presentation/widget/empty_container.dart';
import 'package:student_art_collection/features/list_art/presentation/bloc/school_auth_bloc.dart';
import 'package:student_art_collection/features/list_art/presentation/bloc/school_auth_event.dart';
import 'package:student_art_collection/features/list_art/presentation/bloc/school_auth_state.dart';
import 'package:student_art_collection/features/list_art/presentation/widget/auth_input_decoration.dart';
import 'package:student_art_collection/features/list_art/presentation/widget/horizontal_progress_bar.dart';

import '../../../../service_locator.dart';

class SchoolLoginPage extends StatelessWidget {
  static const String ID = "login";
  @override
  Widget build(BuildContext context) {
    return BlocProvider<SchoolAuthBloc>(
      create: (context) => sl<SchoolAuthBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Login',
          ),
          bottom: PreferredSize(
            preferredSize: Size(double.infinity, 1.0),
            child: BlocBuilder<SchoolAuthBloc, SchoolAuthState>(
              builder: (context, state) {
                if (state is Loading) {
                  return AppBarLoading();
                }
                return EmptyContainer();
              },
            ),
          ),
        ),
        body: BlocListener<SchoolAuthBloc, SchoolAuthState>(
          listener: (context, state) {
            if (state is Authorized) {
              final snackBar = SnackBar(
                content: Text(state.school.email),
                duration: Duration(seconds: 10),
              );
              Scaffold.of(context).showSnackBar(snackBar);
            } else if (state is Error) {
              final snackBar = SnackBar(content: Text(state.message));
              Scaffold.of(context).showSnackBar(snackBar);
            }
          },
          child: LoginForm(),
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  String email, password;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: <Widget>[
            TextField(
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) {
                email = value;
              },
              decoration: getAuthInputDecoration('Enter school email address'),
            ),
            SizedBox(height: 10),
            TextField(
              keyboardType: TextInputType.visiblePassword,
              onChanged: (value) {
                password = value;
              },
              decoration: getAuthInputDecoration('Enter your password'),
            ),
            RaisedButton(
                child: Text(
                  'Login',
                ),
                onPressed: () {
                  dispatchLogin();
                })
          ],
        ),
      ),
    );
  }

  void dispatchLogin() {
    BlocProvider.of<SchoolAuthBloc>(context).add(LoginSchoolEvent(
      email: email,
      password: password,
    ));
  }
}
