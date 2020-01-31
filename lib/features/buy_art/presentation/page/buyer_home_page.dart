import 'package:flutter/material.dart';
import 'package:student_art_collection/core/util/text_constants.dart';
import 'package:student_art_collection/core/util/theme_constants.dart';
import 'package:student_art_collection/features/buy_art/presentation/page/buyer_cart_page.dart';
import 'package:student_art_collection/features/buy_art/presentation/page/gallery_page.dart';

import '../../../../app_localization.dart';

class BuyerHomePage extends StatefulWidget {
  static const String ID = "buyer_home";

  @override
  _BuyerHomePageState createState() => _BuyerHomePageState();
}

class _BuyerHomePageState extends State<BuyerHomePage> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    GalleryPage(),
    BuyerCartPage(),
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
                  TEXT_SCHOOL_GALLERY_CART_TAG,
                ),
              ),
              icon: Icon(Icons.shopping_cart),
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
