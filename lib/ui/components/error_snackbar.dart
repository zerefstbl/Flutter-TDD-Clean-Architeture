import 'package:flutter/material.dart';

void showErrorMessage(BuildContext context, String error) {
  if (error != null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red[900],
        content: Text(
          error,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
