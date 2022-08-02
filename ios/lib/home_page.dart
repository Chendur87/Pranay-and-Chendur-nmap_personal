// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors
// We import firebase auth and material so we an use firebase authentication functionality and google widgets
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  // We get the current user because they have logged in
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 8),
            Text(
              "Hello ${user.displayName!}!",
              style: TextStyle(fontSize: 30),
            ),
            SizedBox(height: 8),
            Text(
              'You are signed in as',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(user.email!,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 40),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: Size.fromHeight(50),
              ),
              icon: Icon(Icons.arrow_back, size: 32),
              label: Text(
                "Sign out",
                style: TextStyle(fontSize: 24),
              ),
              onPressed: () => FirebaseAuth.instance.signOut(),
            ),
          ],
        ),
      ),
    );
  }
}
