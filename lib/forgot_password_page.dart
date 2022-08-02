// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, library_private_types_in_public_api

// We import the appropriate firebase packages and our own utils.dart
// utils.dart is here so we can display snackBar errors
import 'dart:async'; // new
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import "utils.dart";

// We create our page, whcih has state since it holds memory
// and then we create our state through the _ForgotPasswordPageState class
class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  // This is our form key so we can use the Form widget later
  final formKey = GlobalKey<FormState>();
  // We use text editing controller to create an editable text field
  final emailController = TextEditingController();

  // This method is used to delete our controller when we dispose
  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  // Here we build the page
  @override
  Widget build(BuildContext context) => Scaffold(
        // The appBar is created here for the top
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text("Reset password"),
        ),
        // The body of the text is a form where the user enters their email and is sent a verification code.
        body: Padding(
          // We provide padding on the edges
          padding: EdgeInsets.all(16),
          child: Form(
            // We use our formKey field from earlier
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // The Text appears first in the column
                Text(
                  'Receive an email to\nreset your password',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24),
                ),
                // A divider of height 20.
                SizedBox(height: 20),
                // This is our form field where the user can enter their email
                TextFormField(
                  // The "controller" is basically just the input box
                  controller: emailController,
                  cursorColor: Colors.white,
                  // This means that it gets finalized
                  textInputAction: TextInputAction.done,
                  // Labels the textfield
                  decoration: InputDecoration(labelText: "Email"),
                  // Validates the the email entered isn't null
                  // and is in the form of an email through EmailValidator (not just a bunch of random characters)
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (email) =>
                      email != null && !EmailValidator.validate(email)
                          // If it'snot valid, we ask for them to reenter
                          ? "Enter a valid email"
                          // If it is our validator is done
                          : null,
                ),
                // Divider of height 20
                SizedBox(height: 20),
                // Button for user to request email
                ElevatedButton.icon(
                  // Sets min button size.
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size.fromHeight(50),
                  ),
                  // CHooses the email icon for the button
                  icon: Icon(Icons.email_outlined),
                  // The Text for what the button says which is next to the email icon
                  label: Text(
                    "Reset password",
                    style: TextStyle(fontSize: 24),
                  ),
                  // When the button is pressed, we reset the password through our method
                  onPressed: resetPassword,
                ),
              ],
            ),
          ),
        ),
      );

  // Here we reset the user password
  // The Future async stuff is here so we can do Firebase stuff
  Future resetPassword() async {
    // This showDialog shows a loading circle while we wait for Firebase to send the email
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );
    // We use a try catch to catch any errors
    try {
      // We use Firebase to send the reset email
      // .text.trim() is used to get the text and remove the leading and follow whitespace
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      // We then tell the user that it has been
      Utils.showSnackBar('Password Reset Email Sent');
      // We then close the route (back to signin) once the user resets their password
      Navigator.of(context).popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      // If we have an error, we send it out and then close the  route (back to signin)
      Utils.showSnackBar(e.message);
      Navigator.of(context).pop();
    }
  }
}
