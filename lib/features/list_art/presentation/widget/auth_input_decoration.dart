import 'package:flutter/material.dart';

InputDecoration getAuthInputDecoration(String hint) {
  return InputDecoration(
    hintText: hint,
    border: OutlineInputBorder(),
  );
}
