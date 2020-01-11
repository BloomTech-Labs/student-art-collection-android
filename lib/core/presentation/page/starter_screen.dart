import 'package:flutter/material.dart';
import 'package:student_art_collection/core/util/text_constants.dart';
import 'package:student_art_collection/core/util/theme_constants.dart';
import 'package:student_art_collection/features/buy_art/presentation/page/gallery_page.dart';
import 'package:student_art_collection/features/list_art/presentation/page/login_page.dart';

import '../../../app_localization.dart';


class StarterScreen extends StatelessWidget {
  static const ID = "/";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: Text(
            AppLocalizations.of(context).translate(AppLocalizations.of(context).translate(TEXT_STARTER_APP_NAME))
            //TEXT_STARTER_APP_NAME,
          ),
        ),
        body: StarterControls());
  }
}

class StarterControls extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(

      child: Center(
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
                child: Text(AppLocalizations.of(context).translate(TEXT_STARTER_LOGIN_BUTTON)),
              ),
              SizedBox(
                height: 16,
              ),
              RaisedButton(
                onPressed: () {
                  Navigator.pushNamed(context, GalleryPage.ID);
                },
                child: Text(AppLocalizations.of(context).translate(TEXT_STARTER_GUEST_BUTTON)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
