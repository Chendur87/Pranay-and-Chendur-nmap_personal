import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nmap_personal/page/home_page.dart';
// import 'package:nmap_personal/storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:nmap_personal/widget/appbar_widget.dart';
import 'package:nmap_personal/widget/profile_widget.dart';
import 'package:nmap_personal/widget/textfield_widget.dart';
import 'package:path/path.dart' as path;
import 'dart:io';
import 'package:nmap_personal/widget/button_widget.dart';
import 'package:nmap_personal/storage.dart';

// This page is when the User wants to change the data presented on the profile page
class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  _EditProfilePageState createState() => _EditProfilePageState();
}

// the state that is stored when changing the EditProfilePage
class _EditProfilePageState extends State<EditProfilePage> {
  // the getUser() method gets all of the data we need of a user
  User user = FirebaseAuth.instance.currentUser!;

  Future addUserDetails(User user) async {
    await FirebaseFirestore.instance.collection("users").doc(user.uid).set({
      'name': user.displayName!,
      'email': user.email!,
      'photoURL': user.photoURL!,
    });
  }

  // overall big widget that holds the editprofilepage
  @override
  Widget build(BuildContext build) => Scaffold(
        // the top appbar has the back button that is pressed to go back to the profile page (using Navigator.pop)
        appBar: AppBar(
          leading: BackButton(
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: Colors.transparent,
        ),
        // the body holds the change image and change email / name
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          physics: const BouncingScrollPhysics(),
          children: [
            // we call our ProfileWidget to format our image
            ProfileWidget(
              imagePath: user.photoURL!,
              // we want to edit on this page
              isEdit: true,
              // this onClicked makes it so when you click on the image, a new image is stored in the image bubble
              onClicked: () async {
                // chose new image from photo gallery
                final image =
                    await ImagePicker().pickImage(source: ImageSource.gallery);
                // don't continue if user didn't select any image
                if (image == null) return;
                final uploadName = 'images/${user.uid}profilepic.jpg';
                Reference ref =
                    FirebaseStorage.instance.ref().child(uploadName);
                await ref.putFile(File(image.path));
                ref.getDownloadURL().then((value) {
                  user.updatePhotoURL(value);
                });
                await user.reload();
                user = await FirebaseAuth.instance.currentUser!;
                setState(() {});
              },
            ),
            // The remain code are TextField widgets to change the name, email, and about section of the profile page
            // The
            const SizedBox(height: 24),
            TextFieldWidget(
                label: "Full Name",
                text: user.displayName!,
                onChanged: /*(name) => user = user.copy(name: name)*/
                    (name) async {
                  user.updateDisplayName(name);
                  await user.reload();
                  user = await FirebaseAuth.instance.currentUser!;
                }),
            const SizedBox(height: 24),
            ButtonWidget(
              text: 'Save',
              onClicked: () async {
                // once all of our stages
                await user.reload();
                user = await FirebaseAuth.instance.currentUser!;
                addUserDetails(user);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
}
