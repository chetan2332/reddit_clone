import 'package:flutter/cupertino.dart';

class ErrorText extends StatelessWidget {
  final String e;
  const ErrorText({super.key, required this.e});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(e),
    );
  }
}
