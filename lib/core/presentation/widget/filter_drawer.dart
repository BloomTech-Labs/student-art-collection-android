import 'package:flutter/material.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:student_art_collection/core/util/theme_constants.dart';

class FilterDrawer extends StatefulWidget {
  final Widget scaffold;
  GlobalKey _innerDrawerKey;

  FilterDrawer(GlobalKey key, {this.scaffold}) {
    _innerDrawerKey = key;
  }

  @override
  _FilterDrawerState createState() =>
      _FilterDrawerState(_innerDrawerKey, scaffold: scaffold);
}

class _FilterDrawerState extends State<FilterDrawer> {
  final Widget scaffold;
  GlobalKey _innerDrawerKey;

  _FilterDrawerState(GlobalKey key, {this.scaffold}) {
    _innerDrawerKey = key;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InnerDrawer(
          key: _innerDrawerKey,
          rightChild: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 16, right: 16, top: 32, bottom: 16),
              child: Column(
                children: <Widget>[
                  Text(
                    'Sort',
                    style: TextStyle(
                      inherit: false,
                      fontSize: 24,
                    ),
                  ),
                  Divider(
                    color: accentColorOnPrimary,
                  ),
                  RadioButtonGroup(
                    labelStyle: TextStyle(
                      color: accentColorOnPrimary,
                      fontSize: 16,
                    ),
                    activeColor: accentColorOnPrimary,
                    labels: <String>[
                      'Artwork Title Asc.',
                      'Artwork Title Desc.',
                    ],
                  ),
                  Divider(
                    color: accentColorOnPrimary,
                  ),
                  RadioButtonGroup(
                    labelStyle: TextStyle(
                      color: accentColorOnPrimary,
                      fontSize: 16,
                    ),
                    activeColor: accentColorOnPrimary,
                    labels: <String>[
                      'Artist Name Asc.',
                      'Artist Name Desc.',
                    ],
                  ),
                  Divider(
                    color: accentColorOnPrimary,
                  ),
                  RadioButtonGroup(
                    labelStyle: TextStyle(
                      color: accentColorOnPrimary,
                      fontSize: 16,
                    ),
                    activeColor: accentColorOnPrimary,
                    labels: <String>[
                      'Most Recent',
                      'Oldest',
                    ],
                  ),
                  Divider(
                    color: accentColorOnPrimary,
                  ),
                  RadioButtonGroup(
                    labelStyle: TextStyle(
                      color: accentColorOnPrimary,
                      fontSize: 16,
                    ),
                    activeColor: accentColorOnPrimary,
                    labels: <String>[
                      'Most expensive',
                      'Least Expensive',
                    ],
                  ),
                ],
              ),
            ),
          ),
          onTapClose: true,
          swipe: true,
          colorTransition: primaryColor,
          proportionalChildArea: true,
          borderRadius: 4,
          leftAnimationType: InnerDrawerAnimation.static,
          rightAnimationType: InnerDrawerAnimation.quadratic,
          backgroundColor: primaryColor,
          innerDrawerCallback: (a) => print(a),
          scaffold: scaffold),
    );
  }
}
