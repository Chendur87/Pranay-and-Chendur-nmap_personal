// ignore_for_file: prefer_const_constructors

/* Chendur's version that doesn't really work
import 'dart:async'; // new
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nmap_personal/model/user.dart';
import 'main.dart';
import "utils.dart";
import 'package:nmap_personal/utils/user_preferences.dart';

class SignUpWidget extends StatefulWidget {
  final VoidCallback onClickedSignIn;

  const SignUpWidget({
    Key? key,
    required this.onClickedSignIn,
  }) : super(key: key);

  @override
  _SignUpWidgetState createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final displayNameController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    displayNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 60),
              Text(
                "NMAP",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                "Sign Up",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 40),
              TextFormField(
                controller: emailController,
                cursorColor: Colors.white,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(labelText: "Email"),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (email) =>
                    email != null && !EmailValidator.validate(email)
                        ? "Enter a valid email"
                        : null,
              ),
              SizedBox(height: 4),
              TextFormField(
                controller: passwordController,
                cursorColor: Colors.white,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(labelText: "Password"),
                obscureText: true,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => value != null && value.length < 6
                    ? "Enter min 6 characters"
                    : null,
              ),
              SizedBox(height: 4),
              TextFormField(
                controller: displayNameController,
                cursorColor: Colors.white,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(labelText: "Full Name"),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => value != null && value.length < 3
                    ? "Enter your real name"
                    : null,
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size.fromHeight(50),
                ),
                icon: Icon(Icons.arrow_forward, size: 32),
                label: Text(
                  "Sign Up",
                  style: TextStyle(fontSize: 24),
                ),
                onPressed: signUp,
              ),
              SizedBox(height: 24),
              RichText(
                  text: TextSpan(
                      style: TextStyle(color: Colors.white, fontSize: 20),
                      text: "Already have an account? ",
                      children: [
                    TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = widget.onClickedSignIn,
                      text: "Log in",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ])),
            ],
          ),
        ),
      );

  MyUser? userFromFirebaseUser(User user) {
    if (user != null) {
      return MyUser(
          imagePath: 'null',
          name: user.displayName!,
          email: user.email!,
          about: 'null',
          isDarkMode: false);
    } else {
      return null;
    }
  }

  Future signUp() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

    try {
      UserCredential result =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      User? user = result.user;

      if (user != null) {
        MyUser? localUser = userFromFirebaseUser(user);
        //add display name for just created user
        user.updateDisplayName(displayNameController.text.trim());
        user.updatePhotoURL(
            "https://thumbs.dreamstime.com/b/default-avatar-profile-icon-trendy-flat-style-isolated-white-background-187477840.jpg");
        //get updated user
        await user.reload();
        user = await FirebaseAuth.instance.currentUser;
        FirebaseFirestore.instance
            .collection('Full Name')
            .doc(user?.uid)
            .set({'Display Name': user?.displayName});
        FirebaseFirestore.instance
            .collection('Email')
            .doc(user?.uid)
            .set({"email": user?.email});
        localUser = localUser?.copy(
          name: user?.displayName,
          email: user?.email,
        );
        UserPreferences.setUser(localUser!);
      }
    } on FirebaseAuthException catch (e) {
      print(e);
      Utils.showSnackBar(e.message);
    }

    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
} */

// ignore_for_file: prefer_const_constructors
// We import our firebase auth and email validator stuff for sign in
import 'dart:async'; // new
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
// Below used for flutter widgets and gesture detector
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
// SO we can call other methods
import 'main.dart';
import "utils.dart";

// We create our SignUp page
class SignUpWidget extends StatefulWidget {
  // This tells the RichText button to take us to the login screen when clicked
  final VoidCallback onClickedSignIn;

  // SignIn method link is required to make a signup page, which we get from Auth
  const SignUpWidget({
    Key? key,
    required this.onClickedSignIn,
  }) : super(key: key);

  // We create our state
  @override
  _SignUpWidgetState createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  // We create our text fields
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final displayNameController = TextEditingController();
  // We create our formkey for our form
  final formKey = GlobalKey<FormState>();

  // We dispose of our textfields when we are done
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    displayNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        // Edge padding
        padding: EdgeInsets.all(16),
        child: Form(
          // formKey from earlier
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Top Pixels are extra padding
              SizedBox(height: 60),
              // Our App Name, logo will replace later
              Text(
                "NMAP",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
              ),
              // Dividor
              SizedBox(height: 20),
              // Sign up Text
              Text(
                "Sign Up",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              // Dividor
              SizedBox(height: 40),
              // Our Email form field
              TextFormField(
                // Controller picks what text field we are using is
                controller: emailController,
                // White cursor
                cursorColor: Colors.white,
                textInputAction: TextInputAction.next,
                // Our Label for the field
                decoration: InputDecoration(labelText: "Email"),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                // We validtae that the input isn't null (something is entered)
                // and that the input is in the form of an email
                validator: (email) =>
                    email != null && !EmailValidator.validate(email)
                        // If it isn't valid, we ask them again
                        ? "Enter a valid email"
                        // If not, our validator is no longer needed
                        : null,
              ),
              // Next are our password and displayName fields
              SizedBox(height: 4),
              TextFormField(
                controller: passwordController,
                cursorColor: Colors.white,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(labelText: "Password"),
                obscureText: true,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => value != null && value.length < 6
                    ? "Enter min 6 characters"
                    : null,
              ),
              SizedBox(height: 4),
              TextFormField(
                controller: displayNameController,
                cursorColor: Colors.white,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(labelText: "Full Name"),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                // Has to have a name of at least 3 long so that we can get first and last name
                validator: (value) => value != null && value.length < 3
                    ? "Enter your real name"
                    : null,
              ),
              SizedBox(height: 20),
              // Our button to finsih signing up
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  // Min button size
                  minimumSize: Size.fromHeight(50),
                ),
                // Icon for button and text
                icon: Icon(Icons.arrow_forward, size: 32),
                label: Text(
                  "Sign Up",
                  style: TextStyle(fontSize: 24),
                ),
                // We can signUp method when pressed
                onPressed: signUp,
              ),
              SizedBox(height: 24),
              // Rich text to go to login page
              RichText(
                  text: TextSpan(
                      style: TextStyle(color: Colors.white, fontSize: 20),
                      text: "Already have an account? ",
                      children: [
                    TextSpan(
                      recognizer: TapGestureRecognizer()
                        // When our recognizers senses a tap, we go to login page
                        ..onTap = widget.onClickedSignIn,
                      text: "Log in",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ])),
            ],
          ),
        ),
      );

  // Here we sign up the user
  Future signUp() async {
    // If our formKey says that the form is valid, we continue
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      return;
    }

    // Displkays loading circle
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

    // We create user and store it in UserCredential
    try {
      UserCredential result =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        // .text.trim() used to get the text and remove and leading and ending whitespace
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      // We create our user object
      User? user = result.user;
      // If there is a user
      if (user != null) {
        //add display name for just created user
        user.updateDisplayName(displayNameController.text.trim());
        // We set up a default profile pic
        user.updatePhotoURL(
            "https://thumbs.dreamstime.com/b/default-avatar-profile-icon-trendy-flat-style-isolated-white-background-187477840.jpg");
        //get updated user
        await user.reload();
        user = await FirebaseAuth.instance.currentUser;
      }
    } on FirebaseAuthException catch (e) {
      // Show errors through snack bar
      Utils.showSnackBar(e.message);
    }
    // We move to verify email page
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
