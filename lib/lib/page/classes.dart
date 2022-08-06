import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nmap_personal/widget/appbar_widget.dart';
import 'package:nmap_personal/widget/button_widget.dart';

// This class is for the page that displays the different class ("Math", etc)
// create Stateful Widget extension
class ClassesPage extends StatefulWidget {
  const ClassesPage({Key? key}) : super(key: key);

  _ClassesPageState createState() => _ClassesPageState();
}

class _ClassesPageState extends State<ClassesPage> {
  // This is the big widget that stores the classes as buttons
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
        // the body of the page contains the holding buttons for each class
        body: ListView(
          physics: BouncingScrollPhysics(),
          // each button takes in the parameter of what the class name is
          children: [
            const SizedBox(height: 24),
            buildClassName('Math'),
            const SizedBox(height: 24),
            buildClassName('English'),
            const SizedBox(height: 24),
            buildClassName('Science'),
            const SizedBox(height: 14),
            buildClassName('History'),
          ],
        ),
      );

  // this Widget takes the name of the class, put's that name on the buttton, and the functionality of the button doesn't do anything (dummy class)
  Widget buildClassName(String name) => ButtonWidget(
        text: name,
        onClicked: () {},
      );
}
