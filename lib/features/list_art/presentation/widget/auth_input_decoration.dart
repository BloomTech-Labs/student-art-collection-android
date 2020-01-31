import 'package:flutter/material.dart';
import 'package:student_art_collection/core/util/theme_constants.dart';

InputDecoration getAuthInputDecoration(String hint) {
  return InputDecoration(
    counterText: '',
    labelText: hint,
    labelStyle: TextStyle(
      color: Colors.black54,
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: actionColor,
      ),
    ),
    border: OutlineInputBorder(
      borderSide: BorderSide(
        color: actionColor,
      ),
    ),
  );
}
