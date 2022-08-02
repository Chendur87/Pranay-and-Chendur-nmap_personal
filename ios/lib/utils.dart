// We get flutter google style widgets
import 'package:flutter/material.dart';

class Utils {
  // We create our messanger key
  // Methods are statck because every message is displayed the same
  static final messengerKey = GlobalKey<ScaffoldMessengerState>();
  static showSnackBar(String? text) {
    // If no text, we exit method
    if (text == null) {
      return;
    }
    // If there is text, we create our snackbar with a red background
    final snackBar = SnackBar(content: Text(text), backgroundColor: Colors.red);
    // We then show it
    messengerKey.currentState!
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
