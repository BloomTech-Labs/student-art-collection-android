import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_art_collection/core/presentation/widget/empty_container.dart';
import 'package:student_art_collection/features/list_art/presentation/bloc/school_auth_bloc.dart';
import 'package:student_art_collection/features/list_art/presentation/bloc/school_auth_event.dart';
import 'package:student_art_collection/features/list_art/presentation/bloc/school_auth_state.dart';
import 'package:student_art_collection/features/list_art/presentation/widget/auth_input_decoration.dart';
import 'package:student_art_collection/features/list_art/presentation/widget/horizontal_progress_bar.dart';

import '../../../../service_locator.dart';

class SchoolRegistrationPage extends StatelessWidget {
  static const String ID = "registration";

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SchoolAuthBloc>(
      create: (context) => sl<SchoolAuthBloc>(),
      child: Scaffold(
        resizeToAvoidBottomPadding: true,
        appBar: AppBar(
          title: Text('Register'),
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
              } else if (state is Unauthorized) {
                print('Error');
              }
            },
            child: RegistrationForm()),
      ),
    );
  }
}

class RegistrationForm extends StatefulWidget {
  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  String email,
      password,
      verifyPassword,
      schoolName,
      address,
      city,
      state,
      zipcode;

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
              decoration: getAuthInputDecoration('Enter your email'),
            ),
            SizedBox(height: 10),
            TextField(
              keyboardType: TextInputType.visiblePassword,
              onChanged: (value) {
                password = value;
              },
              decoration: getAuthInputDecoration('Enter your password'),
            ),
            SizedBox(height: 10),
            TextField(
              keyboardType: TextInputType.visiblePassword,
              onChanged: (value) {
                verifyPassword = value;
              },
              decoration: getAuthInputDecoration('Enter your password again'),
            ),
            SizedBox(height: 10),
            TextField(
              keyboardType: TextInputType.text,
              onChanged: (value) {
                address = value;
              },
              decoration:
                  getAuthInputDecoration('Enter your school\'s street address'),
            ),
            SizedBox(height: 10),
            TextField(
              keyboardType: TextInputType.text,
              onChanged: (value) {
                schoolName = value;
              },
              decoration: getAuthInputDecoration('Enter your school\'s name'),
            ),
            SizedBox(height: 10),
            TextField(
              keyboardType: TextInputType.text,
              onChanged: (value) {
                city = value;
              },
              decoration: getAuthInputDecoration('Enter your school\'s city'),
            ),
            SizedBox(height: 10),
            TextField(
              keyboardType: TextInputType.text,
              onChanged: (value) {
                state = value;
              },
              decoration: getAuthInputDecoration('Enter your school\'s state'),
            ),
            SizedBox(height: 10),
            TextField(
              keyboardType: TextInputType.text,
              onChanged: (value) {
                zipcode = value;
              },
              decoration:
                  getAuthInputDecoration('Enter your school\'s zipcode'),
            ),
            SizedBox(height: 10),
            RaisedButton(
                child: Text(
                  'Register',
                ),
                onPressed: () {
                  dispatchRegistration();
                })
          ],
        ),
      ),
    );
  }

  void dispatchRegistration() {
    BlocProvider.of<SchoolAuthBloc>(context).add(RegisterNewSchoolEvent(
      email: email,
      password: password,
      verifyPassword: verifyPassword,
      schoolName: schoolName,
      address: address,
      city: city,
      state: state,
      zipcode: zipcode,
    ));
  }
}
