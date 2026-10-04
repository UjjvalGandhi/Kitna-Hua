import 'package:flutter/material.dart';

/// Decoration for a [TextField] placed inside its own styled container:
/// drops the global input theme's fill, outline and padding so the text lines
/// up with neighbouring labels and values.
InputDecoration inlineInputDecoration({
  String? hintText,
  TextStyle? hintStyle,
}) {
  return InputDecoration(
    hintText: hintText,
    hintStyle: hintStyle,
    isDense: true,
    filled: false,
    border: InputBorder.none,
    enabledBorder: InputBorder.none,
    focusedBorder: InputBorder.none,
    contentPadding: EdgeInsets.zero,
  );
}
