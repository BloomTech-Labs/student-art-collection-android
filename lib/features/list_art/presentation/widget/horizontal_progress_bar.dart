import 'package:flutter/material.dart';
import 'package:student_art_collection/core/util/theme_constants.dart';

class AppBarLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: LinearProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(indicatorColorInactive),
        backgroundColor: backgroundColor,
      ),
    );
  }
}
