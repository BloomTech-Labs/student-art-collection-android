import 'package:flutter/material.dart';
import 'package:student_art_collection/core/util/text_constants.dart';
import 'package:student_art_collection/core/util/theme_constants.dart';
import 'package:student_art_collection/features/list_art/presentation/page/school_gallery_page.dart';
import 'package:student_art_collection/features/list_art/presentation/page/school_profile_page.dart';
import 'package:titled_navigation_bar/titled_navigation_bar.dart';

import '../../../../app_localization.dart';

class SchoolHomePage extends StatefulWidget {
  static const String ID = "school_home";

  @override
  _SchoolHomePaState createState() => _SchoolHomePaState();
}

class _SchoolHomePaState extends State<SchoolHomePage> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    SchoolGalleryPage(),
    SchoolProfilePage(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        child: BottomNavigationBar(
          selectedItemColor: actionColor,
          unselectedItemColor: accentColorOnPrimary,
          backgroundColor: primaryColor,
          currentIndex: _currentIndex,
          // Use this to update the Bar giving a position
          onTap: (index) {
            onTabTapped(index);
          },
          items: [
            BottomNavigationBarItem(
              title: Text(
                displayLocalizedString(
                  TEXT_SCHOOL_GALLERY_HOME_TAG,
                ),
              ),
              icon: Icon(Icons.photo),
            ),
            BottomNavigationBarItem(
              title: Text(
                displayLocalizedString(
                  TEXT_SCHOOL_GALLERY_PROFILE_TAG,
                ),
              ),
              icon: Icon(Icons.person),
            ),
          ],
        ),
        notchMargin: 4.0,
      ),
    );
  }

  String displayLocalizedString(String label) {
    return AppLocalizations.of(context).translate(label);
  }
}
