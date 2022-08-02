import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

// This class stores all of the data for the User of the Application
class MyUser {
  // fields of data we need to store
  final String imagePath;
  final String name;
  final String email;
  final String about;
  final bool isDarkMode;

  // when creating a User these fields are required
  const MyUser({
    required this.imagePath,
    required this.name,
    required this.email,
    required this.about,
    required this.isDarkMode,
  });

  // this method copys User data gathered from else where to restore User data
  MyUser copy({
    String? imagePath,
    String? name,
    String? email,
    String? about,
    bool? isDarkMode,
  }) =>
      MyUser(
        // if these fields are null, then take data what was initially given in UserPreferences, else fetch the data
        imagePath: imagePath ?? this.imagePath,
        name: name ?? this.name,
        email: email ?? this.email,
        about: about ?? this.about,
        isDarkMode: isDarkMode ?? this.isDarkMode,
      );

  // stores new User data (felds) in the json format
  static MyUser fromJson(Map<String, dynamic> json) => MyUser(
        imagePath: json['imagePath'],
        name: json['name'],
        email: json['email'],
        about: json['about'],
        isDarkMode: json['isDarkMode'],
      );

  // this is a Map that pairs the String keys that represent the data to the values of the actual data themselves
  Map<String, dynamic> toJson() => {
        'imagePath': imagePath,
        'name': name,
        'email': email,
        'about': about,
        'isDarkMode': isDarkMode,
      };
}
