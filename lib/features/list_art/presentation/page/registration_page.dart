import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class SchoolRegistrationPage extends StatefulWidget {
  static const String ID = "registration";

  @override
  _SchoolRegistrationPageState createState() => _SchoolRegistrationPageState();
}

class _SchoolRegistrationPageState extends State<SchoolRegistrationPage> {
  String email,
      password,
      verifyPassword,
      schoolName,
      address,
      city,
      state,
      zipcode;

  BuildContext _blocContext;
  GlobalKey<ScaffoldState> _scaffoldKey =
      new GlobalKey<ScaffoldState>(); // The app's "state".

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SchoolAuthBloc>(
      create: (context) => sl<SchoolAuthBloc>(),
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomPadding: true,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            AppLocalizations.of(context)
                .translate(TEXT_REGISTRATION_APP_BAR_TITLE),
            style: TextStyle(),
          ),
          bottom: PreferredSize(
            preferredSize: Size(double.infinity, 1.0),
            child: BlocBuilder<SchoolAuthBloc, SchoolAuthState>(
              builder: (context, state) {
                _blocContext = context;
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
              showSnackBar(state.message);
            }
          },
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ListView(
                children: <Widget>[
                  TextField(
                    maxLength: 40,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) {
                      email = value;
                    },
                    decoration: getAuthInputDecoration(
                        AppLocalizations.of(context)
                            .translate(TEXT_REGISTRATION_EMAIL_LABEL)),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    maxLength: 64,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    onChanged: (value) {
                      password = value;
                    },
                    decoration: getAuthInputDecoration(
                        AppLocalizations.of(context)
                            .translate(TEXT_REGISTRATION_PASSWORD_LABEL)),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    maxLength: 64,
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                    onChanged: (value) {
                      verifyPassword = value;
                    },
                    decoration: getAuthInputDecoration(
                        AppLocalizations.of(context).translate(
                            TEXT_REGISTRATION_PASSWORD_CONFIRMATION_LABEL)),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    maxLength: 80,
                    keyboardType: TextInputType.text,
                    onChanged: (value) {
                      address = value;
                    },
                    decoration: getAuthInputDecoration(
                        AppLocalizations.of(context)
                            .translate(TEXT_REGISTRATION_STREET_ADDRESS_LABEL)),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    maxLength: 64,
                    keyboardType: TextInputType.text,
                    onChanged: (value) {
                      schoolName = value;
                    },
                    decoration: getAuthInputDecoration(
                        AppLocalizations.of(context)
                            .translate(TEXT_REGISTRATION_SCHOOL_NAME_LABEL)),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    maxLength: 64,
                    keyboardType: TextInputType.text,
                    onChanged: (value) {
                      city = value;
                    },
                    decoration: getAuthInputDecoration(
                        AppLocalizations.of(context)
                            .translate(TEXT_REGISTRATION_CITY_LABEL)),
                  ),
                  SizedBox(height: 10),
                  SizedBox(height: 10),
                  TextField(
                    maxLength: 5,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      zipcode = value;
                    },
                    decoration: getAuthInputDecoration(
                        AppLocalizations.of(context)
                            .translate(TEXT_REGISTRATION_ZIPCODE_LABEL)),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      FloatingActionButton(
                        onPressed: () {
                          dispatchRegistration();
                        },
                        child: Icon(
                          Icons.arrow_forward,
                          size: 40,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showSnackBar(String message) {
    final snackBar = SnackBar(content: Text(message));
    _scaffoldKey.currentState.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  void dispatchRegistration() {
    BlocProvider.of<SchoolAuthBloc>(_blocContext).add(RegisterNewSchoolEvent(
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
