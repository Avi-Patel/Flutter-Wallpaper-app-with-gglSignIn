import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:faker/faker.dart';
import 'personal_wallpapers.dart';

class Fullscreen extends StatefulWidget {
  String imgpath, uid, temp;
  Fullscreen(this.imgpath, this.uid, this.temp);

  @override
  _FullscreenState createState() => _FullscreenState();
}

class _FullscreenState extends State<Fullscreen> {
  bool downloading = false;
  var progress = "";
  int i = 0;

  final LinearGradient backgroundGradient = new LinearGradient(
    colors: [
      new Color(0x10000000),
      new Color(0x20000000),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  Future<void> _download(imgpath) async {
    Dio dio = Dio();
    try {
      var path = await getApplicationSupportDirectory();
      await dio
          .download(widget.imgpath, "${path.path}/${faker.person.name()}.jpg",
              onReceiveProgress: (rec, total) {
        print("Receive: $rec, Total: $total");
        setState(() {
          downloading = true;
          progress = ((rec / total) * 100).toStringAsFixed(0) + "%";
        });
      });
      GallerySaver.saveImage(imgpath);
    } catch (e) {
      print(e);
    }

    setState(() {
      progress = "Completed";
      downloading = false;
      i = 1;
    });
    print("Completed");
  }

  final scaffoldKey = new GlobalKey<ScaffoldState>();
  void show(String s1) {
    final snakbar = new SnackBar(
        content: new Text(s1),
        duration: Duration(
          seconds: 2,
        ));
    scaffoldKey.currentState.showSnackBar(snakbar);
  }

  void _delete() async {
    if (widget.temp == "1") {
      await Firestore.instance
          .collection('users')
          .document(widget.uid)
          .collection('personalWallpapers')
          .add({
        'url': widget.imgpath,
      });
      show("Wallpaper added to persnoal Wallpapers.");
    } else {
      QuerySnapshot images = await Firestore.instance
          .collection('users')
          .document(widget.uid)
          .collection('personalWallpapers')
          .where('url', isEqualTo: widget.imgpath)
          .getDocuments();
      var list = images.documents;
      for (var image in list) {
        await Firestore.instance
            .collection('users')
            .document(widget.uid)
            .collection('personalWallpapers')
            .document(image.documentID)
            .delete();
      }
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: new FloatingActionButton(
        onPressed: () => Navigator.of(context).pop(),
        child: new Icon(
          Icons.close,
          size: 30.0,
        ),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Image(
              image: new NetworkImage(widget.imgpath),
              // fit: BoxFit.fitWidth,
            ),
            new IconButton(
              icon: Icon(Icons.file_download, color: Colors.black),
              onPressed: () => _download(widget.imgpath),
            ),
            SizedBox(
              height: 20.0,
            ),
            downloading
                ? Text("Downloading image : ${progress}")
                : i == 1 ? new Text("Completed") : new SizedBox(height: 10.0),
            widget.uid != "a"
                ? OutlineButton(
                    clipBehavior: Clip.none,
                    child: new Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Icon(Icons.add_box),
                        new SizedBox(
                          width: 10.0,
                        ),
                        new Text(
                          widget.temp == "1"
                              ? "Save to personal Wallpapers"
                              : "Delete from personal Wallpapers",
                          style: new TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    onPressed: _delete,
                  )
                : new Container(),
          ],
        ),
      ),
    );
  }
}
