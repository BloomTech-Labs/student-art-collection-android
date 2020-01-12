import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_art_collection/core/presentation/widget/empty_container.dart';
import 'package:student_art_collection/core/util/text_constants.dart';
import 'package:student_art_collection/core/util/theme_constants.dart';
import 'package:student_art_collection/features/list_art/presentation/bloc/auth/school_auth_bloc.dart';
import 'package:student_art_collection/features/list_art/presentation/bloc/auth/school_auth_event.dart';
import 'package:student_art_collection/features/list_art/presentation/bloc/auth/school_auth_state.dart';
import 'package:student_art_collection/features/list_art/presentation/page/school_gallery_page.dart';
import 'package:student_art_collection/features/list_art/presentation/widget/auth_input_decoration.dart';
import 'package:student_art_collection/features/list_art/presentation/widget/horizontal_progress_bar.dart';

import '../../../../app_localization.dart';
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
          title: Text(AppLocalizations.of(context).translate(TEXT_REGISTRATION_APP_BAR_TITLE)),
          bottom: PreferredSize(
            preferredSize: Size(double.infinity, 1.0),
            child: BlocBuilder<SchoolAuthBloc, SchoolAuthState>(
              builder: (context, state) {
                if (state is SchoolAuthLoading) {
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
                Navigator.pushReplacementNamed(context, SchoolGalleryPage.ID);
              } else if (state is SchoolAuthError) {
                final snackBar = SnackBar(content: Text(state.message));
                Scaffold.of(context).showSnackBar(snackBar);
              } else if (state is Unauthorized) {
                print(AppLocalizations.of(context).translate(TEXT_REGISTRATION_APP_BAR_ERROR_STATE_MESSAGE));
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
              decoration: getAuthInputDecoration(AppLocalizations.of(context).translate(TEXT_REGISTRATION_EMAIL_LABEL)),
            ),
            SizedBox(height: 10),
            TextField(
              keyboardType: TextInputType.visiblePassword,
              onChanged: (value) {
                password = value;
              },
              decoration: getAuthInputDecoration(AppLocalizations.of(context).translate(TEXT_REGISTRATION_PASSWORD_LABEL)),
            ),
            SizedBox(height: 10),
            TextField(
              keyboardType: TextInputType.visiblePassword,
              onChanged: (value) {
                verifyPassword = value;
              },
              decoration: getAuthInputDecoration(AppLocalizations.of(context).translate(TEXT_REGISTRATION_PASSWORD_CONFIRMATION_LABEL)),
            ),
            SizedBox(height: 10),
            TextField(
              keyboardType: TextInputType.text,
              onChanged: (value) {
                address = value;
              },
              decoration:
                  getAuthInputDecoration(AppLocalizations.of(context).translate(TEXT_REGISTRATION_STREET_ADDRESS_LABEL)),
            ),
            SizedBox(height: 10),
            TextField(
              keyboardType: TextInputType.text,
              onChanged: (value) {
                schoolName = value;
              },
              decoration: getAuthInputDecoration(AppLocalizations.of(context).translate(TEXT_REGISTRATION_SCHOOL_NAME_LABEL)),
            ),
            SizedBox(height: 10),
            TextField(
              keyboardType: TextInputType.text,
              onChanged: (value) {
                city = value;
              },
              decoration: getAuthInputDecoration(AppLocalizations.of(context).translate(TEXT_REGISTRATION_CITY_LABEL)),
            ),
            SizedBox(height: 10),
            TextField(
              keyboardType: TextInputType.text,
              onChanged: (value) {
                state = value;
              },
              decoration: getAuthInputDecoration(AppLocalizations.of(context).translate(TEXT_REGISTRATION_STATE_LABEL)),
            ),
            SizedBox(height: 10),
            TextField(
              keyboardType: TextInputType.text,
              onChanged: (value) {
                zipcode = value;
              },
              decoration:
                  getAuthInputDecoration(AppLocalizations.of(context).translate(TEXT_REGISTRATION_ZIPCODE_LABEL)),
            ),
            SizedBox(height: 10),
            RaisedButton(
                color: accentColor,
                child: Text(
                  'Register',
                  style: TextStyle(
                    color: Colors.white,
                  ),
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
