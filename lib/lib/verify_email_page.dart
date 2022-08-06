// ignore_for_file: prefer_const_declarations, use_key_in_widget_constructors, prefer_const_constructors
// Import firebase files
import 'dart:async'; // new
import 'package:firebase_auth/firebase_auth.dart';
// Import flutter widget files
import 'package:flutter/material.dart';
// Import files from other pages in our project
import 'package:nmap_personal/page/home_page.dart';
import 'package:nmap_personal/utils.dart';

// We create our page and our state
class VerifyEmailPage extends StatefulWidget {
  @override
  _VerifyEmailPageState createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  // We set up our instance fields
  bool isEmailVerified = false;
  // canResendEmail and timer are used to give 5 second delays between email requests
  bool canResendEmail = false;
  Timer? timer;

  // We override initState
  @override
  void initState() {
    super.initState();
    // We check if the email is verified
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    // if not, we call send verification email
    if (!isEmailVerified) {
      sendVerificationEmail();

      timer = Timer.periodic(
        Duration(seconds: 3),
        (_) => checkEmailVerified(),
      );
    }
  }

  // We check if the email is verified here every 5 seconds
  Future checkEmailVerified() async {
    // We get the current user's new state
    await FirebaseAuth.instance.currentUser!.reload();
    // We check if it's verified in our state
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    // If it is, we cancel the timer
    if (isEmailVerified) timer?.cancel();
  }

  // We dispose of the timer here
  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  // Here we send the verification email
  Future sendVerificationEmail() async {
    try {
      // We get the user and send the email
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
      // We then disable the verification button for 5 seconds and then reenable
      setState(() => canResendEmail = false);
      await Future.delayed(Duration(seconds: 5));
      setState(() => canResendEmail = true);
    } catch (e) {
      // We show error messages here
      Utils.showSnackBar(e.toString());
    }
  }

  // here is our main widget
  @override
  Widget build(BuildContext context) => isEmailVerified
      // If the email is verified, we show our home page. If not, we create the verification page
      ? HomePage()
      : Scaffold(
          appBar: AppBar(
            title: Text('Verify Email'),
          ),
          body: Padding(
            // Outside padding
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                // We tell the user an email has been sent
                Text(
                  'A verification email has been sent to your email',
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                // Dividor
                SizedBox(height: 24),
                // We create our send verification email button
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size.fromHeight(50),
                  ),
                  // We use the email icon
                  icon: Icon(Icons.email, size: 32),
                  label: Text(
                    // We then add text to explain
                    "Resend email",
                    style: TextStyle(fontSize: 24),
                  ),
                  // If we press the button and we can resend the email (no 5 sec delay active), we send the email
                  onPressed: canResendEmail ? sendVerificationEmail : null,
                ),
                // Dividor
                SizedBox(height: 8),
                // Here is our button to sign out of the page and cancel the verification process
                TextButton(
                  style: ElevatedButton.styleFrom(
                    // Min button size if 50 from the height of the page
                    minimumSize: Size.fromHeight(50),
                  ),
                  child: Text(
                    'Cancel/Sign out',
                    style: TextStyle(fontSize: 24),
                  ),
                  // When pressed, we sign out the user
                  onPressed: () => FirebaseAuth.instance.signOut(),
                ),
              ],
            ),
          ),
        );
}
