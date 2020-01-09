import 'package:flutter/material.dart';
import 'package:student_art_collection/core/util/theme_constants.dart';

InputDecoration getAuthInputDecoration(String hint) {
  return InputDecoration(
    hintText: hint,
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: accentColor,
      ),
    ),
    border: OutlineInputBorder(
      borderSide: BorderSide(
        color: accentColor,
      ),
    ),
  );
}
