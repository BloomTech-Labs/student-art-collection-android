import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_art_collection/features/buy_art/presentation/page/gallery_screen.dart';
import 'package:student_art_collection/features/list_art/presentation/bloc/school_auth_bloc.dart';
import 'package:student_art_collection/features/list_art/presentation/bloc/school_auth_event.dart';
import 'package:student_art_collection/features/list_art/presentation/bloc/school_auth_state.dart';
import 'package:student_art_collection/features/list_art/presentation/page/login_page.dart';

import '../../../service_locator.dart';

class StarterScreen extends StatefulWidget {
  static const ID = "/";

  @override
  _StarterScreenState createState() {
    return _StarterScreenState();
  }
}

class _StarterScreenState extends State<StarterScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<SchoolAuthBloc>(
      create: (context) => sl<SchoolAuthBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'ArtCo',
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
              } else {
                Navigator.pushReplacementNamed(context, SchoolLoginPage.ID);
              }
            },
            child: StarterControls()),
      ),
    );
  }
}

class StarterControls extends StatefulWidget {
  @override
  _StarterControlsState createState() => _StarterControlsState();
}

class _StarterControlsState extends State<StarterControls> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            RaisedButton(
              onPressed: () {
                dispatchLoginOnReturn();
              },
              child: Text('Login as School Admin'),
            ),
            SizedBox(
              height: 16,
            ),
            RaisedButton(
              onPressed: () {
                Navigator.pushNamed(context, GalleryScreen.ID);
              },
              child: Text('Continue as Guest'),
            ),
          ],
        ),
      ),
    );
  }

  void dispatchLoginOnReturn() {
    BlocProvider.of<SchoolAuthBloc>(context).add(LoginOnReturnEvent());
  }
}
