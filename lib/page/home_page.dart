import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nmap_personal/google_sign_in.dart';
import 'package:nmap_personal/model/user.dart';
import 'package:nmap_personal/page/edit_profile_page.dart';
import 'package:nmap_personal/utils/user_preferences.dart';
import 'package:nmap_personal/widget/appbar_widget.dart';
import 'package:nmap_personal/widget/button_widget.dart';
import 'package:nmap_personal/widget/numbers_widget.dart';
import 'package:nmap_personal/widget/profile_widget.dart';
import 'package:nmap_personal/page/classes.dart';
import 'package:provider/provider.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final user = UserPreferences.getUser();
    final firebaseUser = FirebaseAuth.instance.currentUser!;

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
            imagePath: user.imagePath,
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
          Center(child: buildUpgradeButton(context)),
          /*const SizedBox(height: 24),
          NumbersWidget(),
          const SizedBox(height: 48),
          buildAbout(user), */
        ],
      ),
    );
  }

  Widget buildName(MyUser user) => Column(
        children: [
          Text(
            user.name,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 4),
          Text(
            user.email,
            style: TextStyle(color: Colors.grey),
          )
        ],
      );

  Widget buildUpgradeButton(BuildContext context) => ButtonWidget(
        text: "CLASSES!",
        onClicked: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const ClassesPage()),
          );
        },
      );

  Widget buildAbout(MyUser user) => Container(
        padding: EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              user.about,
              style: TextStyle(fontSize: 16, height: 1.4),
            ),
          ],
        ),
      );
}
