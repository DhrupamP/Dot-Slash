import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class DiseasePage extends StatefulWidget {
  const DiseasePage({Key? key}) : super(key: key);

  @override
  _DiseasePageState createState() => _DiseasePageState();
}

class _DiseasePageState extends State<DiseasePage> {
  late File _image;
  late List _output;
  final picker = ImagePicker();
  bool _loading = true;

  loadModel() async {
    await Tflite.loadModel(
        model: "assets/crop_model.tflite", labels: "assets/labels.txt");
  }

  classifyImage(File image) async {
    var output = await Tflite.runModelOnImage(
        path: image.path,
        numResults: 39,
        threshold: 0.8,
        imageMean: 127.5,
        imageStd: 127.5);
    setState(() {
      _output = output!;
      _loading = false;
    });
    print(_output[0]["index"].runtimeType);
  }

  pickImage() async {
    var image = await picker.pickImage(source: ImageSource.camera);
    if (image == null) {
      return null;
    } else {
      setState(() {
        _image = File(image.path);
      });
    }
    classifyImage(_image);
  }

  pickGalleryImage() async {
    var image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) {
      return null;
    } else {
      setState(() {
        _image = File(image.path);
      });
    }
    classifyImage(_image);
  }

  Color colordecider(int idx) {
    if (idx == 4) {
      return Colors.black;
    }
    if (idx == 3 ||
        idx == 5 ||
        idx == 7 ||
        idx == 11 ||
        idx == 15 ||
        idx == 18 ||
        idx == 20 ||
        idx == 22 ||
        idx == 24 ||
        idx == 25 ||
        idx == 28 ||
        idx == 38) {
      return Colors.green;
    }
    return Colors.red;
  }

  String textDecider(Color color) {
    if (color == Colors.black) {
      return "No Leaf Found";
    }
    if (color == Colors.green) {
      return "This crop is Healthy!!!";
    }
    if (color == Colors.red) {
      return "This crop is Diseased!!!";
    }
    return "";
  }

  @override
  void initState() {
    super.initState();
    loadModel().then((value) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Tflite.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff021837),
          centerTitle: true,
          title: Text('Crop Disease Identifier'),
        ),
        body: Container(
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Center(
                    child: _loading == true
                        ? null
                        : Container(
                            child: Column(
                              children: [
                                Container(
                                  height:
                                      MediaQuery.of(context).size.width * 0.75,
                                  width:
                                      MediaQuery.of(context).size.width * 0.75,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(30),
                                    child: Image.file(_image, fit: BoxFit.fill),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                _output != null
                                    ? Text(
                                        textDecider(
                                            colordecider(_output[0]["index"])),
                                        textAlign: TextAlign.center,
                                        softWrap: true,
                                        style: TextStyle(
                                          fontSize: 20,
                                          color:
                                              colordecider(_output[0]["index"]),
                                        ),
                                      )
                                    : Container(),
                                _output != null
                                    ? Text(
                                        "${_output[0]["label"]}",
                                        textAlign: TextAlign.center,
                                        softWrap: true,
                                        style: TextStyle(
                                          fontSize: 20,
                                          color:
                                              colordecider(_output[0]["index"]),
                                        ),
                                      )
                                    : Container(),
                                Divider(
                                  height: 25,
                                  thickness: 1,
                                )
                              ],
                            ),
                          ),
                  ),
                ),
                Container(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: pickImage,
                        child: Container(
                          width: MediaQuery.of(context).size.width - 200,
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(
                              horizontal: 24, vertical: 17),
                          decoration: BoxDecoration(
                              color: Color(0xff021837),
                              borderRadius: BorderRadius.circular(15)),
                          child: Text(
                            "Take a Photo",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      GestureDetector(
                        onTap: pickGalleryImage,
                        child: Container(
                          width: MediaQuery.of(context).size.width - 200,
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(
                              horizontal: 24, vertical: 17),
                          decoration: BoxDecoration(
                              color: Color(0xff021837),
                              borderRadius: BorderRadius.circular(15)),
                          child: Text(
                            "Pick from Gallery",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
