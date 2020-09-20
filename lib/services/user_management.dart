import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wallpaper_gglsignin/Wallpaper/wall_screen.dart';

class UserManagement{
  storeNewUser(user, context) async{
    await Firestore.instance.collection('/users').document(user.uid).setData({
      'name': user.name,
      'email': user.email,
      'uid': user.uid,
    })
    .then((value){
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (context)=> new Wallscreen(user:user)));
    }).catchError((e){
      print(e);
    });
  }
}

class User
{
  String uid;
  String name;
  String email;
  String pass;
  User(String uid,String name, String email, String pass)
  {
    this.uid=uid;
    this.name=name;
    this.email=email;
    this.pass=pass;
  }
}