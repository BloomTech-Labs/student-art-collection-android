import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_art_collection/core/presentation/widget/custom_checkbox.dart';
import 'package:student_art_collection/core/presentation/widget/empty_container.dart';
import 'package:student_art_collection/core/util/theme_constants.dart';
import 'package:student_art_collection/features/list_art/presentation/bloc/auth/school_auth_bloc.dart';
import 'package:student_art_collection/features/list_art/presentation/bloc/auth/school_auth_event.dart';
import 'package:student_art_collection/features/list_art/presentation/bloc/auth/school_auth_state.dart';
import 'package:student_art_collection/features/list_art/presentation/page/registration_page.dart';
import 'package:student_art_collection/features/list_art/presentation/page/school_gallery_page.dart';
import 'package:student_art_collection/features/list_art/presentation/widget/auth_input_decoration.dart';
import 'package:student_art_collection/features/list_art/presentation/widget/horizontal_progress_bar.dart';

import '../../../../service_locator.dart';

class SchoolLoginPage extends StatelessWidget {
  static const String ID = "login";

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
              child: LoginForm(screenHeight: screenHeight,),
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
                  height: screenHeight*.29,
                  padding: EdgeInsets.only(left: 12),
                  alignment: Alignment.centerLeft,
                  child: Text('Welcome\nback!', style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                  ),),
                ),
                Container(
                  height: screenHeight*.25,
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(left: 5, bottom: 5),
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          'Email',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
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
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (value) {
                              email = value;
                            },
                            decoration: InputDecoration.collapsed(hintText: ""),
                          ),
                        ),
                      ),
                      Center(child: SizedBox(height: 20)),
                      Container(
                        alignment: Alignment.bottomLeft,
                        padding: EdgeInsets.only(left: 5, bottom: 5),
                        child: Text(
                          'Password',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
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
                            onChanged: (value) {
                              password = value;
                            },
                            decoration: InputDecoration.collapsed(hintText: ""),
                          ),
                        ),
                      ),

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
                                  color: Colors.white, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration:BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Icon(Icons.arrow_forward, color: Colors.white, size: 40,),
                  ),),

                Row(
                    children: <Widget>[
                      Expanded(
                          child: Divider(color: Colors.white,thickness: 1.5,)
                      ),

                      Container(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Text("OR", style: TextStyle(
                            color: Colors.white,
                            fontSize: 20
                          ),)),

                      Expanded(
                          child: Divider(color: Colors.white,thickness: 1.5,)
                      ),
                    ]
                ),
                InkWell(
                  child: Text(
                    'Not a member yet? \n    Sign Up Here!',
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, SchoolRegistrationPage.ID);
                  },
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
}
