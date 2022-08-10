import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nmap_personal/widget/appbar_widget.dart';
import 'package:nmap_personal/widget/button_widget.dart';

// This class is for the page that displays the different class ("Math", etc)
// create Stateful Widget extension
class MessagesPage extends StatefulWidget {
  const MessagesPage({Key? key}) : super(key: key);

  _MessagesPageState createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
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
            buildPersonName('Person 1'),
            const SizedBox(height: 24),
            buildPersonName('Person 2'),
            const SizedBox(height: 24),
            buildPersonName('Person 3'),
            const SizedBox(height: 14),
            buildPersonName('Person 4'),
          ],
        ),
      );

  // this Widget takes the name of the person, put's that name on the buttton, and the functionality of the button doesn't do anything (dummy class)
  Widget buildPersonName(String name) => ButtonWidget(
        text: name,
        onClicked: () {},
      );
}
