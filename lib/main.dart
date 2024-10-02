import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hiveapp/moodle/modle.dart';
import 'package:hiveapp/screens/adding_userpage.dart';
import 'package:hiveapp/screens/login.dart';
import 'package:hiveapp/screens/saveddata.dart';
import 'package:hiveapp/screens/splashScreen.dart';

void main(List<String> args) async {
  await Hive.initFlutter();
  Hive.registerAdapter(notsAdapter());
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    routes: {
      '/': (context) => splashscreen(),
      '/login': (context) => login(),
      '/addinguser': (context) => AddingUserPage(),
      '/userdata': (context) => SavedDataPage(),
    },
  ));
}
