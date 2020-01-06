import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_art_collection/features/buy_art/presentation/page/gallery_screen.dart';
import 'package:student_art_collection/features/list_art/presentation/bloc/auth/school_auth_bloc.dart';
import 'package:student_art_collection/features/list_art/presentation/bloc/auth/school_auth_state.dart';
import 'package:student_art_collection/features/list_art/presentation/page/login_page.dart';

import '../../../service_locator.dart';

class StarterScreen extends StatelessWidget {
  static const ID = "/";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'ArtCo',
          ),
        ),
        body: StarterControls());
  }
}

class StarterControls extends StatelessWidget {
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
                Navigator.pushNamed(context, SchoolLoginPage.ID);
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
}
