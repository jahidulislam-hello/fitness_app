import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppIcons{

  static var base="assets/icons";
  static const String  path ="assets/icons";
  //====================>Auth Screen Icons<=================

  static const String cheloperIcon = "$path/cheloperIcon.svg";
  static const String profiles = "$path/profiles.svg";
  static const Icon profile = Icon(Icons.person,);
  static const Icon email = Icon(Icons.email_outlined);
  static const Icon key = Icon(Icons.key);
  static const Icon visibility = Icon(Icons.visibility_off);
  static const Icon cart = Icon(Icons.shopping_cart,color: Colors.black,);
  static const Icon fire = Icon(Icons.local_fire_department_outlined,color: Colors.red,);


  //====================>Home Screen Icons<=================
  static String home="$base/home.svg";
  static String workout="$base/gym.svg";
  static String meal="$base/meal.svg";
  static String football="$base/football.svg";
  static String activityIcon ="$base/activity_icon.svg";
  static String badges ="$base/badges.svg";
  static String chatIcon ="$base/chat_icons.svg";
  static String chicken ="$base/chicken.svg";
}