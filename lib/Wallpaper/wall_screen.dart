import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../login.dart';
import 'general_wallpapers.dart';
import 'personal_wallpapers.dart';
import 'dart:async';
import 'package:flutter_wallpaper_gglsignin/services/user_management.dart';
import 'package:connectivity/connectivity.dart';


class Wallscreen extends StatefulWidget {
  User user;
  Wallscreen({this.user});
  @override
  _WallscreenState createState() => _WallscreenState();
}

class _WallscreenState extends State<Wallscreen> with
 SingleTickerProviderStateMixin{


  TabController _tabController;

  final scaffoldKey= new GlobalKey<ScaffoldState>();
  var _connectionStatus="ConnectivityResult.none";
  Connectivity connectivity;
  StreamSubscription<ConnectivityResult> subscription1;


  void show(String s1)
  {
    final snakbar=new SnackBar(
      content: new Text(s1),
      duration:Duration(
        seconds: 2,
      )
    );
    scaffoldKey.currentState.showSnackBar(snakbar);
  }

  

  void _signOut() async 
  {
    await FirebaseAuth.instance.signOut().then((value){}
    ).catchError((e){
      print(e);
    });
    print("User logged out");
    Navigator.of(context).pop();
    setState(() {
      widget.user.email="c";
      print(widget.user.email);
      widget.user.name="b";
      widget.user.uid="a";
    });
    show("You are logged out");
  }



  @override
  void initState() {
    connectivity=new Connectivity();
    subscription1=connectivity.onConnectivityChanged.listen(
      (ConnectivityResult result)
      {
        setState(() {
          _connectionStatus=result.toString(); 
          print(_connectionStatus);
        });
        // print(_connectionStatus);
      }
    ); 
    connectivity.checkConnectivity().then((ConnectivityResult result){
      setState(() {
        _connectionStatus=result.toString();
      });
    });
    _tabController=new TabController(
      length: 2, 
      vsync: this,
      initialIndex: 0,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  

  @override
  Widget build(BuildContext context) {
    print(widget.user.name);
    print(widget.user.email);
    print(widget.user.uid);
    return new Scaffold(
      key: scaffoldKey,
      appBar: new AppBar(
        title: new Text("Wallify"),
        bottom: new TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: <Widget>[
            new Tab(text: "General Wallpapers"),
            new Tab(text: "Personal Wallpapers"),
          ],
        ),
      ),

      drawer: new Drawer(        
        child: Container(
          color: Colors.black,
          child: new ListView(
            children: <Widget>[

              widget.user.email!="c"?
              new UserAccountsDrawerHeader(
                accountName: new Text(
                  widget.user.name,
                  style:new TextStyle(color:Colors.black,),
                ),
                accountEmail: new Text(
                  widget.user.email,
                  style:new TextStyle(color:Colors.black,),
                ),
                currentAccountPicture: new CircleAvatar(
                  backgroundColor: Colors.black,
                  child: new Text(
                    widget.user.name[0],
                    style: TextStyle(fontSize:40.0)
                  ),
                ),
              )
              :
              new Container(),

              new Container(
                color: Colors.black,
                child: Column(
                  children: <Widget>[
                    new ListTile(
                      title: new Text(
                        widget.user.email!="c"?"Logout": "Login",
                        style: TextStyle(color: Colors.white),
                      ),
                      // trailing: new Icon(Icons.settings),
                      leading:new Icon(
                        Icons.account_box,
                        color: Colors.white,
                      ),
                      onTap: ()=> widget.user.email=="c"?
                      Navigator.of(context).push(new MaterialPageRoute(builder: (context)=> new login()))
                      :_signOut(),
                    ),
                    new Divider(
                      color: Colors.green,
                    ),
                    new ListTile(
                      title: new Text(
                        "Settings",
                        style: TextStyle(color:Colors.white),
                      ),
                      // trailing: new Icon(Icons.settings),
                      leading:new Icon(
                        Icons.settings,
                        color: Colors.white,
                      ),
                      onTap: (){},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      body: new TabBarView(
        controller: _tabController,
        children: <Widget>[
          new Generalwall(widget.user.uid,_connectionStatus),
          new Personalwall(widget.user.email,widget.user.uid,_connectionStatus),
        ],
      ),
      
    );
  }
}
