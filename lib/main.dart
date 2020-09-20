import 'package:flutter/material.dart';
import 'dart:async';
import 'Wallpaper/wall_screen.dart';
import 'package:flutter_wallpaper_gglsignin/services/user_management.dart';

void main() {
  runApp(new Myapp());
}

class Myapp extends StatefulWidget {
  @override
  _MyappState createState() => _MyappState();
}

class _MyappState extends State<Myapp> {
  User user = new User("a", "b", "c", "d");

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Google Signin",
      theme: new ThemeData(
        primarySwatch: Colors.green,
      ),
      home: new Wallscreen(user: user),
    );
  }
}
