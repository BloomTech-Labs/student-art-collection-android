import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_art_collection/core/presentation/widget/custom_checkbox.dart';
import 'package:student_art_collection/core/util/theme_constants.dart';
import 'package:student_art_collection/features/buy_art/presentation/page/gallery_page.dart';
import 'package:student_art_collection/features/list_art/presentation/bloc/auth/school_auth_bloc.dart';
import 'package:student_art_collection/features/list_art/presentation/bloc/auth/school_auth_event.dart';
import 'package:student_art_collection/features/list_art/presentation/bloc/auth/school_auth_state.dart';
import 'package:student_art_collection/features/list_art/presentation/page/registration_page.dart';
import 'package:student_art_collection/features/list_art/presentation/page/school_gallery_page.dart';

import '../../../service_locator.dart';

class LoginPage extends StatelessWidget {
  static const String ID = "/";

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return BlocProvider<SchoolAuthBloc>(
      create: (context) => sl<SchoolAuthBloc>(),
      child: Scaffold(
        backgroundColor: primaryColor,
        body: Padding(
          padding: EdgeInsets.all(0),
          child: SingleChildScrollView(
            child: BlocListener<SchoolAuthBloc, SchoolAuthState>(
              listener: (context, state) {
                if (state is Authorized) {
                  Navigator.pushReplacementNamed(context, SchoolGalleryPage.ID);
                } else if (state is SchoolAuthError) {
                  final snackBar = SnackBar(content: Text(state.message));
                  Scaffold.of(context).showSnackBar(snackBar);
                }
              },
              child: LoginForm(
                screenHeight: screenHeight,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  final screenHeight;

  const LoginForm({Key key, @required this.screenHeight}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState(screenHeight: screenHeight);
}

class _LoginFormState extends State<LoginForm> {
  final screenHeight;
  String email, password;
  bool shouldRemember = false;

  _LoginFormState({@required this.screenHeight});

  void _onCheckboxChange() {
    setState(() {
      shouldRemember = !shouldRemember;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  height: screenHeight * .29,
                  padding: EdgeInsets.only(left: 12),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Welcome\nback!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                    ),
                  ),
                ),
                Container(
                  height: screenHeight * .25,
                  child: Column(
                    children: <Widget>[

                      textFieldWidgetNoBorderWhite(label: 'Email', onChanged: (value){email = value;}),
                      Center(child: SizedBox(height: 20)),
                      textFieldWidgetNoBorderWhite(label: 'Password', onChanged: (value){password = value;}),
                      Container(
                        padding: EdgeInsets.only(top: 16),
                        child: Row(
                          children: <Widget>[
                            Container(
                              color: Colors.white,
                              margin: EdgeInsets.only(right: 8),
                              child: CustomCheckbox(
                                value: shouldRemember,
                                activeColor: accentColor,
                                materialTapTargetSize: null,
                                onChanged: (value) {
                                  _onCheckboxChange();
                                },
                                useTapTarget: false,
                              ),
                            ),
                            Text(
                              'Remember Me?',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: screenHeight * .4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      GestureDetector(
                        onTap: dispatchLogin,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: accentColor,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                        ),
                      ),
                      Row(children: <Widget>[
                        Expanded(
                            child: Divider(
                          color: Colors.white,
                          thickness: 1.5,
                        )),
                        Container(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              "OR",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            )),
                        Expanded(
                            child: Divider(
                          color: Colors.white,
                          thickness: 1.5,
                        )),
                      ]),
                      Center(
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                              color: accentColor,
                              borderRadius:
                                  BorderRadiusDirectional.circular(5)),
                          child: Center(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, GalleryPage.ID);
                              },
                              child: Text(
                                'Continue as Guest',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: InkWell(
                          child: Text.rich(
                            TextSpan(
                                text: 'Not a member yet? \n    ',
                                style: TextStyle(color: Colors.white),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'Sign Up Here!',
                                    style: TextStyle(
                                        color: Colors.white,
                                        decoration: TextDecoration.underline,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  TextSpan(
                                      text: '\n     Schools Only',
                                      style: TextStyle(color: Colors.white))
                                ]),
                          ),
                          onTap: () {
                            dispatchGuest();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
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

  void dispatchGuest() {
    Navigator.pushNamed(context, SchoolRegistrationPage.ID);
  }

  Widget textFieldWidgetNoBorderWhite({String label, Function(String value) onChanged}) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 5, bottom: 5),
          alignment: Alignment.bottomLeft,
          child: Text(
            label,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
          ),
          child: Center(
            child: TextField(
              keyboardType: TextInputType.visiblePassword,
              onChanged:(value) => onChanged(value),
              decoration: InputDecoration.collapsed(hintText: ""),
            ),
          ),
        )
      ],
    );
  }
}
