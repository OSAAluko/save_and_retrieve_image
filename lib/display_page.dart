import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:saveandretrieveimage/camera_page.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';

class DisplayPage extends StatefulWidget {

  @override
  _DisplayPageState createState() => _DisplayPageState();
}

class _DisplayPageState extends State<DisplayPage> {

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
    future: getImagePref(),
    builder: (BuildContext context, AsyncSnapshot<String> imageSnapshot) {
      ImageProvider imageWidget;
      if (imageSnapshot.hasData && imageSnapshot.data != null) {
        imageWidget = FileImage(File(imageSnapshot.data));
        print('Future Image AVAILABLE as ${imageSnapshot.data}');
      }
      else if (imageSnapshot.hasError && imageSnapshot.data != null) {
        imageWidget = FileImage(File(imageSnapshot.data));
        print('Future Image has ERROR - ${imageSnapshot.error}');
      }
      else {
        imageWidget =
            AssetImage('lib_image/fis_asset_image.JPG');
      }

      return Scaffold(
        appBar: AppBar(
          textTheme: TextTheme(
              headline6: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontFamily: headingFontFam,
                  fontSize: 24.0)),
          centerTitle: true,
          title: Text('Image From Assets/SF'),
          backgroundColor: mainAppColour,
          elevation: 20.0,
        ),
        body: Container(
            child: Column(
              children: [
                Expanded(child: Container(decoration: BoxDecoration(
                  image: DecorationImage(image: imageWidget,
                  fit: BoxFit.cover,
                  )
                ) )),
                SizedBox(
                    height: 30.0
                ),

              ],
            )),

        bottomNavigationBar: BottomAppBar(
          child: Container(
            decoration: BoxDecoration(
              color: mainAppColour,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/first');
                  },
                  child: IconButton(
                    icon: Icon(
                      Icons.person_outline,
                      color: bottomBarIconColour,
                      size: 27,
                    ),
                    tooltip: 'Edit Picture',
                    onPressed: null,
                  ),
                ),

              ],
            ),
          ),
        ),

      );

    }
    );

  }
}
