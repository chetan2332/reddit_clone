import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

void showSnackBar(String e, BuildContext context) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(content: Text(e)),
    );
}

Future<FilePickerResult?> pickImage() async {
  final image = await FilePicker.platform.pickFiles(type: FileType.image);
  return image;
}
