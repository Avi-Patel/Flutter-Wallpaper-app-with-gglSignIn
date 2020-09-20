import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_wallpaper_gglsignin/Wallpaper/full_screen_image.dart';
import 'dart:async';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:connectivity/connectivity.dart';

class Personalwall extends StatefulWidget {

  String email,status,uid;
  Personalwall(this.email,this.uid,this.status);

  @override
  _PersonalwallState createState() => _PersonalwallState();
}


class _PersonalwallState extends State<Personalwall>{

  @override
  Widget build(BuildContext context) {
    print(widget.uid);
    print(widget.status);
    return Scaffold(
      body: widget.status=="ConnectivityResult.none"?
      new Center(
        child:new Text(
          "Please check that you have stable internet connection. \n",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight:FontWeight.bold),
        ),
      )
      : widget.email=="c"?
      new Center(
        child:new Text(
          "Please check that you are signed in. \n",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight:FontWeight.bold),
        ),
      ):
      StreamBuilder(
        stream: Firestore.instance.collection('users')
                .document(widget.uid)
                .collection('personalWallpapers')
                .snapshots(),
                
        builder: (context, snapshot) {
          if(!snapshot.hasData)
          {
            return Center(
              child: new CircularProgressIndicator(
                backgroundColor: Colors.black,
              ),
            );
          }
          return new StaggeredGridView.countBuilder(
            padding: const EdgeInsets.all(8.0),
            crossAxisCount: 6,
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context,index)
            {
              String imgpath=snapshot.data.documents[index].data['url'];
              return new Material(
                elevation: 8.0,
                child: new InkWell(
                  borderRadius: new BorderRadius.all(Radius.circular(10.0)),
                  onTap: ()=> Navigator.push(
                    context,
                    new MaterialPageRoute(builder: (context)
                    => new Fullscreen(imgpath,widget.uid,"0"))
                  ),
                  child: new Hero(
                    tag: imgpath+"$index",
                    child: new FadeInImage(
                      image: NetworkImage(imgpath),
                      fit: BoxFit.cover,
                      placeholder: new AssetImage('assets/horse.jpg'),
                    ),
                  ),
                ),
              );
            },
            staggeredTileBuilder: (index)=> new StaggeredTile.count(2,index.isEven?2:3),
            mainAxisSpacing: 8.0,
            crossAxisSpacing: 8.0,
          );
        },
      ),
    );
  }
}