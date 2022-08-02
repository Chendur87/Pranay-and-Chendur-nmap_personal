import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:nmap_personal/storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:nmap_personal/widget/appbar_widget.dart';
import 'package:nmap_personal/widget/profile_widget.dart';
import 'package:nmap_personal/widget/textfield_widget.dart';
import 'package:path/path.dart' as path;
import 'dart:io';
import 'package:nmap_personal/widget/button_widget.dart';
import 'package:nmap_personal/storage.dart';
import '../model/user.dart';
import '../utils/user_preferences.dart';

// This page is when the User wants to change the data presented on the profile page
class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  _EditProfilePageState createState() => _EditProfilePageState();
}

// the state that is stored when changing the EditProfilePage
class _EditProfilePageState extends State<EditProfilePage> {
  // the getUser() method gets all of the data we need of a user
  MyUser user = UserPreferences.getUser();
  final User _user = FirebaseAuth.instance.currentUser!;

  //final Storage storage = Storage();

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
              imagePath: user.imagePath,
              // we want to edit on this page
              isEdit: true,
              // this onClicked makes it so when you click on the image, a new image is stored in the image bubble
              onClicked: () async {
                // chose new image from photo gallery
                final image =
                    await ImagePicker().pickImage(source: ImageSource.gallery);
                // don't continue if user didn't select any image
                if (image == null) return;

                // following lines of code get name and path of the new image from the directory
                final directory = await getApplicationDocumentsDirectory();
                final name = path.basename(image.path);
                final imageFile = File('${directory.path}/$name');
                final newImage = await File(image.path).copy(imageFile.path);
                /*final newImageName = path.basename(newImage.path);
                storage
                    .uploadFile(user.imagePath, name)
                    .then((value) => print('done'));*/

                // when we set the state, we are copying the newImage's path to the user to be displayed in the image bubble
                setState(() => user = user.copy(imagePath: newImage.path));
              },
            ),
            // The remain code are TextField widgets to change the name, email, and about section of the profile page
            // The
            const SizedBox(height: 24),
            TextFieldWidget(
              label: "Full Name",
              text: user.name,
              onChanged: /*(name) => user = user.copy(name: name)*/
                  (name) => FirebaseFirestore.instance
                      .collection('Full Name')
                      .doc(_user.uid)
                      .set({'name': user.copy(name: name)}),
            ),
            const SizedBox(height: 24),
            TextFieldWidget(
              label: "Email",
              text: user.email,
              onChanged: (email) => user = user.copy(email: email),
            ),
            const SizedBox(height: 24),
            TextFieldWidget(
              label: "About",
              text: user.about,
              maxLines: 5,
              onChanged: (about) => user = user.copy(about: about),
            ),
            const SizedBox(height: 24),
            ButtonWidget(
              text: 'Save',
              onClicked: () {
                // once all of our stages
                UserPreferences.setUser(user);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
}
