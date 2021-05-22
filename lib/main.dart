import 'dart:core';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:camera/camera.dart';
import 'dart:async';
import 'package:saveandretrieveimage/display_page.dart';
import 'package:saveandretrieveimage/camera_page.dart';


Future<void> main() async {

  //Ensuring plugin services are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Obtaining a list of the available cameras on the device.
  final cameras = await availableCameras();

  // Getting a specific camera from the list of available cameras.
  final secondCamera = cameras[1];

  //Ensuring screen orientation is only in portrait
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(SaveAndRetrieveImage(phoneCamera: secondCamera,)); //function to run the app
  });
}

class SaveAndRetrieveImage extends StatefulWidget {
  final phoneCamera;
  SaveAndRetrieveImage({Key key, this.phoneCamera}) : super(key: key);

  @override
  _SaveAndRetrieveImageState createState() => _SaveAndRetrieveImageState();
}

class _SaveAndRetrieveImageState extends State<SaveAndRetrieveImage> {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Prayditator',
      initialRoute: '/',
      routes: {
        '/': (context) => DisplayPage(),
        '/first': (context) => CameraPage(camera: widget.phoneCamera),
      },
    );
  }
}

