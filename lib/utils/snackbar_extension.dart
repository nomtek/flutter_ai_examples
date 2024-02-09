import 'package:flutter/material.dart';

extension SnackBarExtension on BuildContext {
  void showMessageSnackBar(String message) {
    final context = this;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        // limit the width of the snackbar to 500 if the screen is wider
        width: MediaQuery.of(context).size.width > 500 ? 460 : null,
        behavior: SnackBarBehavior.floating,
        content: Text(message),
      ),
    );
  }
}
