import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nmap_personal/auth_page.dart';
import 'package:nmap_personal/login_widget.dart';

AppBar buildAppBar(BuildContext context) {
  const icon = CupertinoIcons.moon_stars;

  return AppBar(
    leading: BackButton(
      color: Colors.white,
      onPressed: () => FirebaseAuth.instance.signOut(),
    ),
    backgroundColor: Colors.transparent,
    elevation: 0,
    actions: [
      IconButton(
        icon: const Icon(icon),
        color: Colors.white,
        onPressed: () async {},
      ),
    ],
  );
}
