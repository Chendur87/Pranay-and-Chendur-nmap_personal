import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nmap_personal/google_sign_in.dart';
import 'package:nmap_personal/page/edit_profile_page.dart';
import 'package:nmap_personal/widget/appbar_widget.dart';
import 'package:nmap_personal/widget/button_widget.dart';
import 'package:nmap_personal/widget/numbers_widget.dart';
import 'package:nmap_personal/widget/profile_widget.dart';
import 'package:nmap_personal/page/classes.dart';
import 'package:provider/provider.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'messages.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    var user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
            color: Colors.white,
            onPressed: () {
              final googleProvider =
                  Provider.of<GoogleSignInProvider>(context, listen: false);
              googleProvider.logout();
            }),
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          ProfileWidget(
            imagePath: user.photoURL!,
            onClicked: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => EditProfilePage()),
              );
              setState(() {});
            },
          ),
          const SizedBox(height: 24),
          buildName(user),
          const SizedBox(height: 24),
          Center(child: buildClassesButton(context)),
          const SizedBox(height: 24),
          Center(child: buildMessagesButton(context)),
        ],
      ),
    );
  }

  Widget buildName(User user) => Column(
        children: [
          Text(
            user.displayName!,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 4),
          Text(
            user.email!,
            style: TextStyle(color: Colors.grey),
          )
        ],
      );

  Widget buildClassesButton(BuildContext context) => ButtonWidget(
        text: "Classes!",
        onClicked: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const ClassesPage()),
          );
        },
      );

  Widget buildMessagesButton(BuildContext context) => ButtonWidget(
        text: "Messages!",
        onClicked: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const MessagesPage()),
          );
        },
      );
}
