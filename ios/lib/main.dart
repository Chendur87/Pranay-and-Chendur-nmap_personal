// ignore_for_file: prefer_const_declarations

// We import our firebase auth and core stuff
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
// This import is for google widgets
import 'package:flutter/material.dart';
// We import our other projects so we can use them
import 'package:nmap_personal/auth_page.dart';
import 'package:nmap_personal/utils.dart';
import 'package:nmap_personal/verify_email_page.dart';

Future main() async {
  // We set up Firebase and then run our app
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

// We set our navigatorKey instance field so we can naviagte places
final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  static final String title = "NMAP";

  // This widget is the root of our application.
  @override
  Widget build(BuildContext context) => MaterialApp(
        // The messanger key is for us to display messages through Utils.showSnackBar
        scaffoldMessengerKey: Utils.messengerKey,
        navigatorKey: navigatorKey,
        title: title,
        // Our theme is dark with green as our primary color and tealAccent is our secondary color
        theme: ThemeData.dark().copyWith(
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.green,
          ).copyWith(
            secondary: Colors.tealAccent,
          ),
        ),
        // We construct our main page
        home: MainPage(),
      );
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        // We use StreamBuilder so we can detect Firebase Authentication State changes
        body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            // If we are waiting for anything, we show a loading circle
            if (snapshot.connectionState == ConnectionState.waiting) {
              // ignore: prefer_const_constructors
              return Center(child: CircularProgressIndicator());
            }
            // If there is an  error, we tell the User
            else if (snapshot.hasError) {
              // ignore: prefer_const_constructors
              return Center(child: Text("Something went wrong!"));
            }
            // If we have logged in, we open our verify email page (which will
            // open our main page i f we have ever previouslly verified our email)
            else if (snapshot.hasData) {
              return VerifyEmailPage();
            }
            // Here we display our Auth page, which displays either our login or sign up page
            else {
              return AuthPage();
            }
          },
        ),
      );
}
