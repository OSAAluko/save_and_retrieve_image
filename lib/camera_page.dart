import 'package:saveandretrieveimage/display_page.dart';
import 'dart:core';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:camera/camera.dart';
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';


Color mainAppColour = Colors.blueGrey;
Color medTextBgColour = Colors.black.withOpacity(0.9);
Color medTextIconColour = Colors.white54;
Color bottomBarIconColour = Colors.white70;

var headingFontFam = 'Raleway';
var subHeadingFontFam = 'Courier';

var dataPromptStyle = TextStyle(
  fontSize: 21.0,
  color: mainAppColour,
  fontWeight: FontWeight.w100,
  fontFamily: subHeadingFontFam,
);

var dataLabelStyle = TextStyle(
  fontSize: 12.0,
  color: mainAppColour,
  fontWeight: FontWeight.w100,
  fontFamily: subHeadingFontFam,
);

//Functions for setting, getting user image from SharedPreferences
//void setImagePref(data) async {
//  SharedPreferences prefs = await SharedPreferences.getInstance();
//  String encodedImage = base64Encode(data);
//  await prefs.setString('cameraImage', encodedImage);
//}
//Future<Uint8List> getImagePref() async {
//  SharedPreferences prefs = await SharedPreferences.getInstance();
//  Uint8List decodedImage = base64Decode(prefs.getString('cameraImage'));
//  return decodedImage ?? null;
//}


void setImagePref(data) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String imageFilePath = data?.path;
  await prefs.setString('imageFilePath', imageFilePath);
}
Future<String> getImagePref() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String imageFilePath = prefs.getString('imageFilePath');
  return imageFilePath ?? null;
}


class CameraPage extends StatefulWidget {

  final CameraDescription camera;

  const CameraPage({
    Key key,
    @required this.camera,
  }) : super(key: key);


  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {

  // Variables to store the CameraController & the Future.
  CameraController _controller;
  Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // To display the current output from the camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          textTheme: TextTheme(
              headline6: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 24.0)),
          centerTitle: true,
          title: Text('Camera Page'),
          backgroundColor: mainAppColour,
          elevation: 20.0,
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 5),
                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: medTextBgColour,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Using camera to create an image object...',
                          style: TextStyle(
                            fontSize: 21.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w100,
                            fontFamily: subHeadingFontFam,
                          ),
                        ),
                        SizedBox(
                          height: 24.0,
                        ),
                        Text(
                          'Take a pose and snap a picture...',
                          style: dataPromptStyle,
                        ),
                        SizedBox(
                          height: 12.0,
                        ),

                        Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              FutureBuilder<void>(
                                future: _initializeControllerFuture,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.done) {
                                    // If the Future is complete, display the preview.
                                    return AspectRatio(
                                        aspectRatio: _controller.value.aspectRatio,
                                        child: CameraPreview(_controller));
                                  } else {
                                    // Otherwise, display a loading indicator.
                                    return Center(child: CircularProgressIndicator());
                                  }
                                },
                              ),

                              Center(
                                child: FloatingActionButton(
                                  onPressed: () {},
                                  backgroundColor: Colors.transparent,
                                  splashColor: Colors.white,
                                  mini: true,
                                  child: GestureDetector(
                                    onTap: () async {
                                      // Taking a picture in a try-catch block
                                      try {
                                        // Ensuring that the camera is initialized.
                                        await _initializeControllerFuture;

                                        // Taking the picture and then getting the location where image file is saved.
                                        final cameraImage = await _controller.takePicture();
                                        setImagePref(cameraImage); //Saving image to Shared Preferences as Base64


                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => CameraPicture(imageFilePath: cameraImage?.path)));

                                      } catch (e) {
                                        // If an error occurs, log the error to the console.
                                        print(e);
                                      }
                                    },
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.camera_alt,
                                        color: medTextIconColour,
                                        size: 50,
                                      ),
                                      tooltip:
                                      'Prayditator Snaps Picture',
                                      onPressed: null,
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(
                                height: 30.0,
                              ),

                            ])

                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Container(
            decoration: BoxDecoration(
              color: mainAppColour,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );


  }
}

// A widget that displays the picture taken by the user.
class CameraPicture extends StatelessWidget {
  final String imageFilePath;

  const CameraPicture({Key key, this.imageFilePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
          appBar: AppBar(
            textTheme: TextTheme(
                headline6: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontFamily: headingFontFam,
                    fontSize: 24.0)),
            centerTitle: true,
            title: Text('Created Image'),
            backgroundColor: mainAppColour,
            elevation: 20.0,
          ),
          body: Container(
              child: Column(
                children: [
                  Image.file(File(imageFilePath)),
                  SizedBox(
                      height: 30.0
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 3.0,
                      primary: mainAppColour,
                      onPrimary: Colors.white,
                    ),
                    child: Text('Done'),
                    onPressed: () {


                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DisplayPage()));
                    },
                  ),

                ],
              )),

        );




}}