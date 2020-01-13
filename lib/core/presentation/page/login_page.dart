import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_art_collection/core/presentation/widget/custom_checkbox.dart';
import 'package:student_art_collection/core/util/theme_constants.dart';
import 'package:student_art_collection/features/buy_art/presentation/page/gallery_page.dart';
import 'package:student_art_collection/features/list_art/presentation/bloc/auth/school_auth_bloc.dart';
import 'package:student_art_collection/features/list_art/presentation/bloc/auth/school_auth_event.dart';
import 'package:student_art_collection/features/list_art/presentation/bloc/auth/school_auth_state.dart';
import 'package:student_art_collection/features/list_art/presentation/page/registration_page.dart';
import 'package:student_art_collection/features/list_art/presentation/page/school_gallery_page.dart';

import '../../../features/buy_art/presentation/page/gallery_page.dart';
import '../../../features/list_art/presentation/bloc/auth/school_auth_bloc.dart';
import '../../../features/list_art/presentation/bloc/auth/school_auth_state.dart';
import '../../../features/list_art/presentation/bloc/auth/school_auth_state.dart';
import '../../../service_locator.dart';
import '../../util/theme_constants.dart';
import '../../util/theme_constants.dart';

class LoginPage extends StatelessWidget {
  static const String ID = "/";

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SchoolAuthBloc>(
      create: (context) => sl<SchoolAuthBloc>(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: primaryColor,
        body: BlocListener<SchoolAuthBloc, SchoolAuthState>(
          listener: (context, state) {
            if (state is Authorized) {
              Navigator.pushReplacementNamed(context, SchoolGalleryPage.ID);
            } else if (state is SchoolAuthError) {
              final snackBar = SnackBar(content: Text(state.message));
              Scaffold.of(context).showSnackBar(snackBar);
            }
          },
          child: LayoutBuilder(builder:
              (BuildContext context, BoxConstraints viewportConstraints) {
            return LoginForm(screenHeight: viewportConstraints.maxHeight);
          }),
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  final double screenHeight;

  const LoginForm({Key key, this.screenHeight}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState(screenHeight);
}

class _LoginFormState extends State<LoginForm> {
  final double screenHeight;
  String email, password;
  bool shouldRemember = false;

  _LoginFormState(this.screenHeight);

  void _onCheckboxChange() {
    setState(() {
      shouldRemember = !shouldRemember;
    });
  }

  void dispatchLogin() {
    BlocProvider.of<SchoolAuthBloc>(context).add(LoginSchoolEvent(
      email: email,
      password: password,
    ));
  }

  void dispatchRegistration() {
    Navigator.pushNamed(context, SchoolRegistrationPage.ID);
  }

  void dispatchGuest() {
    Navigator.pushNamed(context, GalleryPage.ID);
  }

  @override
  Widget build(BuildContext context) {
    double positionTopBanner = screenHeight * (.77);
    double positionTopTextField = screenHeight * (.62);
    double positionBottomTextField = screenHeight * (.50);
    double positionCheckBox = screenHeight * (.45);
    double positionMiddleButton = screenHeight * (.37);
    double positionDivider = screenHeight * (.31);
    double positionBottomButton = screenHeight * (.18);

    return Stack(
      children: <Widget>[
        topBanner(
            position: positionTopBanner,
            text: 'Welcome \n back!',
            fontSize: 40),
        textFieldWidget(
            position: positionTopTextField,
            text: 'Email',
            onChanged: (value) {
              email = value;
            }),
        textFieldWidget(
            position: positionBottomTextField,
            text: 'Password',
            onChanged: (value) {
              password = value;
            }),
        checkBoxWithLabel(
          position: positionCheckBox,
          label: 'Remember Me?',
          onChanged: (value) {
            _onCheckboxChange();
          },
        ),
        BlocBuilder<SchoolAuthBloc, SchoolAuthState>(
             builder: (BuildContext context, state) {
               if(state is SchoolAuthLoading){
                 return  middleButton(position: positionMiddleButton, onTap: (){}, icon: CircularProgressIndicator(
                   valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                 ));
               }
              return middleButton(position: positionMiddleButton, onTap: dispatchLogin, icon: Icon(
                Icons.arrow_forward,
                color: Colors.white,
                size: 45,
              ));
             },),
        divider(position: positionDivider, text: 'OR'),
        bottomButton(
          position: positionBottomButton,
          label: 'Continue as Guest',
          onTap: () {
            Navigator.pushNamed(context, GalleryPage.ID);
          },
        ),
        footerWidget(
            textSpan: TextSpan(
                text: 'Not a member yet? \n    Sign Up ',
                style: TextStyle(color: Colors.black),
                children: <TextSpan>[
                  TextSpan(
                    text: 'Here!',
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                  TextSpan(
                      text: '\n     Schools Only',
                      style: TextStyle(color: Colors.black))
                ]),
            onTap: dispatchRegistration)
      ],
    );
  }

  Widget textFieldWidgetNoBorderWhite(
      {String label, Function(String value) onChanged}) {
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
              onChanged: (value) => onChanged(value),
              decoration: InputDecoration.collapsed(hintText: ""),
            ),
          ),
        )
      ],
    );
  }

  Widget topBanner(
      {@required double position,
      @required String text,
      @required double fontSize}) {
    return Positioned(
      bottom: position,
      left: 24,
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget textFieldWidget(
      {@required double position,
      @required String text,
      @required Function(String) onChanged}) {
    return Positioned(
        bottom: position,
        left: 16,
        right: 16,
        child: textFieldWidgetNoBorderWhite(label: text, onChanged: onChanged));
  }

  Widget checkBoxWithLabel(
      {@required double position,
      @required String label,
      Function(bool) onChanged}) {
    return Positioned(
      left: 16,
      bottom: position,
      child: Container(
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
                onChanged: (value) => onChanged(value),
                useTapTarget: false,
              ),
            ),
            Text(
              label,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }

  Widget middleButton({@required double position, Function onTap, Widget icon}) {
    return Positioned(
      right: 16,
      bottom: position,
      child: Container(
        child: RaisedButton(
          padding: EdgeInsets.all(8),
          onPressed: onTap,
          elevation: 10,
          color: accentColor,
          shape: CircleBorder(),
          child: icon,
        ),
      ),
    );
  }

  Widget divider({@required double position, String text}) {
    return Positioned(
      bottom: position,
      left: 0,
      right: 0,
      child: Row(children: <Widget>[
        Expanded(
            child: Divider(
          color: Colors.white,
          thickness: 1.5,
        )),
        Container(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              text,
              style: TextStyle(color: Colors.white, fontSize: 20),
            )),
        Expanded(
            child: Divider(
          color: Colors.white,
          thickness: 1.5,
        )),
      ]),
    );
  }

  Widget bottomButton(
      {@required double position, @required String label, Function onTap}) {
    return Positioned(
      left: 16,
      right: 16,
      bottom: position,
      child: Container(
        height: 50,
        child: RaisedButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          onPressed: onTap,
          color: accentColor,
          elevation: 10,
          textTheme: ButtonTextTheme.primary,
          child: Center(child: Text(label)),
        ),
      ),
    );
  }

  Widget footerWidget({TextSpan textSpan, Function onTap}) {
    return Positioned(
      bottom: 24,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          child: InkWell(
            child: Text.rich(textSpan),
            onTap: () {
              dispatchRegistration();
            },
          ),
        ),
      ),
    );
  }
}
