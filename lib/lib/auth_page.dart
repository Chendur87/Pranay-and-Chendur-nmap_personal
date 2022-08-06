/* This class is used to setup the authentication flow between the
sign up and sign in pages. Depending on the situation/user input,
authpage will display the correct page
*/
// We import material to display widgets
// We also import our own login and signup widget pages so auth can use them
import 'package:flutter/material.dart';
import 'package:nmap_personal/login_widget.dart';
import 'package:nmap_personal/signup_widget.dart';

// We create the AuthPage class and make it Stateful because it holds memory
// for which widget wneeds to be displayed
class AuthPage extends StatefulWidget {
  // We create our state
  @override
  AuthPageState createState() => AuthPageState();
}

class AuthPageState extends State<AuthPage> {
  // Here is our isLogin variable which determines whether the
  // login page should be displayed
  // By default, it is set to true so the login page is displayed
  bool isLogin = true;

  // If isLogin is true, we display the login page
  // If not, we display the signUp page
  @override
  Widget build(BuildContext context) => isLogin
      // The onclicked methods basically tell
      // dart whether the 'RichText button' in each file
      // should take one to the login or sign up widget
      ? LogInWidget(onClickedSignUp: toggle)
      : SignUpWidget(onClickedSignIn: toggle);

  // When a change happens, we change the status of isLogin
  void toggle() => setState(() => isLogin = !isLogin);
}
