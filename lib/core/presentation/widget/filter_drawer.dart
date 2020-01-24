import 'package:flutter/material.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:student_art_collection/core/util/theme_constants.dart';
import 'package:student_art_collection/features/list_art/presentation/widget/auth_input_decoration.dart';

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
    String searchQuery;

    return Material(
      child: InnerDrawer(
        key: _innerDrawerKey,
        rightChild: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 32, bottom: 16),
            child: Column(
              children: <Widget>[
                Text(
                  'Filter',
                  style: TextStyle(
                    inherit: false,
                    fontSize: 24,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: 16,
                    bottom: 16,
                  ),
                  child: Stack(
                    children: <Widget>[
                      TextField(
                        style: TextStyle(
                          color: accentColorOnPrimary,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Search',
                          labelStyle: TextStyle(
                            color: accentColorOnPrimary,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: accentColorOnPrimary,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: accentColorOnPrimary,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        top: 1,
                        bottom: 1,
                        child: IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.clear,
                            color: accentColorOnPrimary,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
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
                Theme(
                  data: ThemeData(
                    unselectedWidgetColor: accentColorOnPrimary,
                  ),
                  child: RadioButtonGroup(
                    labelStyle: TextStyle(
                      color: accentColorOnPrimary,
                      fontSize: 16,
                    ),
                    activeColor: accentColorOnPrimary,
                    labels: <String>[
                      'Artwork Title Asc.',
                      'Artwork Title Desc.',
                      'Artist Name Asc.',
                      'Artist Name Desc.',
                      'Most Recent',
                      'Oldest',
                      'Most expensive',
                      'Least Expensive',
                    ],
                  ),
                ),
                Divider(
                  color: accentColorOnPrimary,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    OutlineButton(
                      highlightedBorderColor: primaryColor,
                      splashColor: accentColorOnPrimary,
                      child: Text(
                        'Apply',
                        style: TextStyle(
                          color: accentColorOnPrimary,
                        ),
                      ),
                      onPressed: () {},
                      borderSide: BorderSide(
                        color: accentColorOnPrimary,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ],
                )
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
        scaffold: scaffold,
      ),
    );
  }
}
