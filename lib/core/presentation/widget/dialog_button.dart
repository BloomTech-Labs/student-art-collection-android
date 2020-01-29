import 'package:flutter/material.dart';
import 'package:student_art_collection/core/util/theme_constants.dart';

class DialogButton extends StatelessWidget {
  final String text;

  DialogButton({
    this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 6,
      child: Container(
        color: accentColor,
        width: 88.0,
        height: 36.0,
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
