import 'package:flutter/material.dart';

void showSnackBar(String e, BuildContext context) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(content: Text(e)),
    );
}
