import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_wallpaper_gglsignin/Wallpaper/wall_screen.dart';
import 'package:flutter_wallpaper_gglsignin/register.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'main.dart';
import 'package:flutter_wallpaper_gglsignin/services/user_management.dart';

class login extends StatefulWidget {
  @override
  _loginState createState() => _loginState();
}

class _loginState extends State<login> {
  String _pass;
  String _email;

  Widget _body() {
    return new Padding(
      padding: EdgeInsets.all(16.0),
      child: Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new TextField(
              keyboardType: TextInputType.emailAddress,
              decoration: new InputDecoration(
                hintText: "Enter Email",
                labelText: "Email",
              ),
              onChanged: (value) {
                setState(() {
                  _email = value;
                });
              },
            ),
            new TextField(
              keyboardType: TextInputType.visiblePassword,
              decoration: new InputDecoration(
                hintText: "Enter Pass",
                labelText: "Password",
              ),
              obscureText: true,
              onChanged: (value) {
                setState(() {
                  _pass = value;
                });
              },
            ),
            SizedBox(
              height: 10.0,
            ),
            new OutlineButton(
                child: new Text(
                  "Login",
                ),
                color: Colors.green,
                onPressed: () async {
                  await FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: _email, password: _pass)
                      .then((user) async {
                    String name;
                    await Firestore.instance
                        .collection('users')
                        .document(user.user.uid)
                        .get()
                        .then((doc) {
                      name = doc["name"].toString();
                      print(name);
                    });
                    User user1 = new User(user.user.uid, name, _email, _pass);
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacement(new MaterialPageRoute(
                      builder: (context) => new Wallscreen(user: user1),
                    ));
                  }).catchError((e) {
                    print(e);
                  });
                }),
            SizedBox(
              height: 15.0,
            ),
            new Text(
              "Don't have a account? ",
            ),
            SizedBox(
              height: 10.0,
            ),
            new OutlineButton(
              child: new Text(
                "Register",
              ),
              color: Colors.green,
              onPressed: () => Navigator.of(context).push(
                  new MaterialPageRoute(builder: (context) => new register())),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Login"),
      ),
      body: _body(),
    );
  }
}
