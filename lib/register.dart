import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_wallpaper_gglsignin/services/user_management.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'main.dart';

class register extends StatefulWidget {

  @override
  _registerState createState() => _registerState();
}

class _registerState extends State<register> {
  String _pass;
  String _email;
  String _name;

  Widget _body()
  {
    return new Padding(
      padding: EdgeInsets.all(16.0),
      child: Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new TextFormField(
              keyboardType: TextInputType.text,
              decoration: new InputDecoration(
                hintText: "Enter full name",
                labelText: "Name",
              ),
              onChanged: (value){
                setState(() {
                  _name=value;
                });
              },
            ),
            new TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: new InputDecoration(
                hintText: "Enter gmail id",
                labelText: "Email",
              ),
              validator: ( value){
                print(value);
                if(value.substring(value.length-10, value.length)!="@gmail.com")
                {
                  return "enter valid email";
                }
                if(value.length<11)
                {
                  return "enter valid email";
                }
                return "saa";
              },
              onChanged: (String value){
                _email=value;
                print(_email);
              },
              
            ),
            new TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: new InputDecoration(
                hintText: "Enter Pass",
                labelText: "Password",
              ),
              obscureText: true,
              onChanged: (value){
                setState(() {
                  _pass=value;
                });
              },
            ),

            SizedBox(height: 10.0,),
            new OutlineButton(
              child: new Text(
                "Register",
              ),
              color: Colors.green,
              onPressed: () async {
                if(_name==null)
                {
                  print("null name");
                }
                else 
                await FirebaseAuth.instance.createUserWithEmailAndPassword(
                  email: _email, 
                  password: _pass
                )
                .then((registeredUser){
                  print("aqqsw");
                  User user=new User(registeredUser.user.uid,_name, _email, _pass);
                  print(user.name);
                  print(user.email);
                  print(user.uid);
                  UserManagement().storeNewUser(user, context);
                })
                .catchError((e){
                  print(e);
                });
              }
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
        title: new Text("Register"),
      ),
      body:_body(),
    );
  }
}

  