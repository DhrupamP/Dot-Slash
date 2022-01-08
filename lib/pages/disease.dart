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
  final picker= ImagePicker();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        centerTitle: true,
        title: Text('Crop Disease Identifier'),
      ),
      body: ListView(
        children: [
          GestureDetector(

          ),
        ],
      ),
    );
  }

}
