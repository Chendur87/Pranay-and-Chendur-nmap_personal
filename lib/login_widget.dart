// ignore_for_file: prefer_const_constructors
// We import the proper firebase auth files
import 'dart:async'; // new
import 'package:firebase_auth/firebase_auth.dart';
// Here we import flutter material for google style widgets and gestures to use gesture detector
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'google_sign_in.dart';
import 'package:provider/provider.dart';
// We import our other pages so our login page can call their methods
import 'forgot_password_page.dart';
import 'main.dart';
import 'utils.dart';

// We create our login page
class LogInWidget extends StatefulWidget {
  // This tells the RichText button to take us to the signup screen when clicked
  final VoidCallback onClickedSignUp;

  // This is what is required to make a login page, which we get from Auth
  const LogInWidget({
    Key? key,
    required this.onClickedSignUp,
  }) : super(key: key);

  // We create our state
  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LogInWidget> {
  // We create our text fields
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Have our dispose method again to delete them
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Top 60 pixels are just the background
            SizedBox(height: 60),
            // Our name, could be changed later to be a logo or app name
            Text(
              "NMAP",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
            ),
            // Dividor
            SizedBox(height: 20),
            Text(
              "Sign In",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 40),
            // Our email and password textfields are next, both use white cursors and are labeled
            TextField(
                controller: emailController,
                cursorColor: Colors.white,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(labelText: "Email")),
            SizedBox(height: 4),
            TextField(
              controller: passwordController,
              cursorColor: Colors.white,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            SizedBox(height: 20),
            // Our button for users to sign in with
            ElevatedButton.icon(
              // Min button size is 50
              style: ElevatedButton.styleFrom(
                minimumSize: Size.fromHeight(50),
              ),
              // Icon of the button is an open lock
              icon: Icon(Icons.lock_open, size: 32),
              label: Text(
                "Sign in",
                style: TextStyle(fontSize: 24),
              ),
              // When it's pressed, we call our signIn method
              onPressed: signIn,
            ),
            SizedBox(height: 24),
            // Google Sign Up Button
            ElevatedButton.icon(
              // Makes button white
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                onPrimary: Colors.black,
                minimumSize: Size(double.infinity, 50),
              ),
              // Makes google icon and makes it red
              icon: FaIcon(FontAwesomeIcons.google, color: Colors.red),
              // Button label
              label: Text("Sign In with Google"),
              onPressed: () {
                // When pressed we create an instance of our google sign in class and then ask it
                // to log in
                final provider =
                    Provider.of<GoogleSignInProvider>(context, listen: false);
                provider.googleLogin();
              },
            ),
            SizedBox(height: 24),
            // Our gesture detector to move to our forgot password page
            GestureDetector(
              child: Text(
                'Forgot password?',
                style: TextStyle(
                  // Underlined text
                  decoration: TextDecoration.underline,
                  // Our secondary color from main
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 20,
                ),
              ),
              // When it's tapped, we go to out Forgot Password Page
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: ((context) => ForgotPasswordPage()),
              )),
            ),
            // Our no account button to take users to the sign in page
            RichText(
              text: TextSpan(
                style: TextStyle(color: Colors.white, fontSize: 20),
                text: "No account? ",
                children: [
                  TextSpan(
                    // When we recognize a tap, we call our sign up method
                    recognizer: TapGestureRecognizer()
                      ..onTap = widget.onClickedSignUp,
                    text: "Sign Up",
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  // This is our sign in method
  Future signIn() async {
    // This showDialog shows a loading circle while we wait for Firebase to send the email
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

    // We try to sign in with out email and password
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        // We use .text.trim() to get the text from the text fields and remove leading and ending whitespace
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      // We display any error messages
      Utils.showSnackBar(e.message);
    }
    // When we are done, we chnage the route to the home screen
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}

/* Chendur's edition that doesn't really work

// ignore_for_file: prefer_const_constructors
// We import the proper firebase auth files
import 'dart:async'; // new
import 'package:firebase_auth/firebase_auth.dart';
// Here we import flutter material for google style widgets and gestures to use gesture detector
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
// We import our other pages so our login page can call their methods
import 'forgot_password_page.dart';
import 'main.dart';
import 'utils.dart';

// We create our login page
class LogInWidget extends StatefulWidget {
  // This tells the RichText button to take us to the signup screen when clicked
  final VoidCallback onClickedSignUp;

  // This is what is required to make a login page, which we get from Auth
  const LogInWidget({
    Key? key,
    required this.onClickedSignUp,
  }) : super(key: key);

  // We create our state
  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LogInWidget> {
  // We create our text fields
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Have our dispose method again to delete them
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Top 60 pixels are just the background
            SizedBox(height: 60),
            // Our name, could be changed later to be a logo or app name
            Text(
              "NMAP",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
            ),
            // Dividor
            SizedBox(height: 20),
            Text(
              "Sign In",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 40),
            // Our email and password textfields are next, both use white cursors and are labeled
            TextField(
                controller: emailController,
                cursorColor: Colors.white,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(labelText: "Email")),
            SizedBox(height: 4),
            TextField(
              controller: passwordController,
              cursorColor: Colors.white,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            SizedBox(height: 20),
            // Our button for users to sign in with
            ElevatedButton.icon(
              // Min button size is 50
              style: ElevatedButton.styleFrom(
                minimumSize: Size.fromHeight(50),
              ),
              // Icon of the button is an open lock
              icon: Icon(Icons.lock_open, size: 32),
              label: Text(
                "Sign in",
                style: TextStyle(fontSize: 24),
              ),
              // When it's pressed, we call our signIn method
              onPressed: signIn,
            ),
            SizedBox(height: 24),
            // Our gesture detector to move to our forgot password page
            GestureDetector(
              child: Text(
                'Forgot password?',
                style: TextStyle(
                  // Underlined text
                  decoration: TextDecoration.underline,
                  // Our secondary color from main
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 20,
                ),
              ),
              // When it's tapped, we go to out Forgot Password Page
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: ((context) => ForgotPasswordPage()),
              )),
            ),
            // Our no account button to take users to the sign in page
            RichText(
              text: TextSpan(
                style: TextStyle(color: Colors.white, fontSize: 20),
                text: "No account? ",
                children: [
                  TextSpan(
                    // When we recognize a tap, we call our sign up method
                    recognizer: TapGestureRecognizer()
                      ..onTap = widget.onClickedSignUp,
                    text: "Sign Up",
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  // This is our sign in method
  Future signIn() async {
    // This showDialog shows a loading circle while we wait for Firebase to send the email
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

    // We try to sign in with out email and password
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        // We use .text.trim() to get the text from the text fields and remove leading and ending whitespace
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      // We display any error messages
      Utils.showSnackBar(e.message);
    }
    // When we are done, we chnage the route to the home screen
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
*/