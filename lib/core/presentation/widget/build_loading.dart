import 'package:flutter/material.dart';
import 'package:student_art_collection/core/util/theme_constants.dart';

class BuildLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
        ),
      ),
    );
  }
}
