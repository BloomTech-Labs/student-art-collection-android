import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_art_collection/features/list_art/presentation/bloc/school_auth_bloc.dart';
import 'package:student_art_collection/features/list_art/presentation/bloc/school_auth_event.dart';
import 'package:student_art_collection/features/list_art/presentation/bloc/school_auth_state.dart';
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
          title: Text('Login'),
          bottom: PreferredSize(
            preferredSize: Size(double.infinity, 1.0),
            child: BlocBuilder<SchoolAuthBloc, SchoolAuthState>(
              builder: (context, state) {
                if (state is Loading) {
                  return AppBarLoading();
                }
                return Container(
                  width: 0,
                  height: 0,
                );
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
            SizedBox(
              height: 16,
            ),
            TextField(
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) {
                email = value;
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter email address',
              ),
            ),
            SizedBox(height: 10),
            TextField(
              keyboardType: TextInputType.visiblePassword,
              onChanged: (value) {
                password = value;
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter your password',
              ),
            ),
            SizedBox(height: 10),
            TextField(
              keyboardType: TextInputType.visiblePassword,
              onChanged: (value) {
                verifyPassword = value;
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter your password again',
              ),
            ),
            SizedBox(height: 10),
            TextField(
              keyboardType: TextInputType.text,
              onChanged: (value) {
                address = value;
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter your school\'s street address',
              ),
            ),
            SizedBox(height: 10),
            TextField(
              keyboardType: TextInputType.text,
              onChanged: (value) {
                schoolName = value;
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter your school\'s name',
              ),
            ),
            SizedBox(height: 10),
            TextField(
              keyboardType: TextInputType.text,
              onChanged: (value) {
                city = value;
              },
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter your school\'s city'),
            ),
            SizedBox(height: 10),
            TextField(
              keyboardType: TextInputType.text,
              onChanged: (value) {
                state = value;
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter your school\'s state',
              ),
            ),
            SizedBox(height: 10),
            TextField(
              keyboardType: TextInputType.text,
              onChanged: (value) {
                zipcode = value;
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter your school\'s zipcode',
              ),
            ),
            RaisedButton(
                child: Text(
                  'Register',
                ),
                onPressed: () {
                  BlocProvider.of<SchoolAuthBloc>(context)
                      .add(RegisterNewSchoolEvent(
                    email: email,
                    password: password,
                    verifyPassword: verifyPassword,
                    schoolName: schoolName,
                    address: address,
                    city: city,
                    state: state,
                    zipcode: zipcode,
                  ));
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
