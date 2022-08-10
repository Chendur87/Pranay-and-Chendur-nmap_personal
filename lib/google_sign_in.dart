// ignore_for_file: prefer_const_constructors
// We import the proper firebase auth files
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// Here we import flutter material for google style widgets and gestures to use gesture detector
import 'package:flutter/material.dart';
// Then we import the below to sign in with google
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nmap_personal/signup_widget.dart';
import 'package:nmap_personal/utils.dart';

// We create our google login provider class
class GoogleSignInProvider extends ChangeNotifier {
  // We create our sign in object
  final googleSignIn = GoogleSignIn();
  // Here we have our user objects
  GoogleSignInAccount? _user;
  GoogleSignInAccount get user => _user!;

  // This is our login method
  Future googleLogin() async {
    try {
      // We get the google user from the sign in class and make sure it's not null
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return;
      // If not null,we set it to be our user
      _user = googleUser;
      // We then get our user credentials from google
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      // And here we use firebase to sign in with those credentials
      await FirebaseAuth.instance.signInWithCredential(credential);
      addUserDetails(FirebaseAuth.instance.currentUser!);
      // We notify our listneers we signed in
      notifyListeners();
    }
    // Here we catch any errors
    catch (e) {
      Utils.showSnackBar(e.toString());
    }
  }

  Future addUserDetails(User user) async {
    await FirebaseFirestore.instance.collection("users").doc(user.uid).set({
      'name': user.displayName!,
      'email': user.email!,
      'photoURL': user.photoURL!,
      "provider": "google",
    });
  }

  // Here we logout the current user
  Future logout() async {
    googleSignIn.isSignedIn().then((s) async {
      await googleSignIn.disconnect();
    });
    FirebaseAuth.instance.signOut();
  }

  Future<bool> isGoogleUser() async {
    return await googleSignIn.isSignedIn();
  }
}
