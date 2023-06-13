// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:emotion/main.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

class home extends StatefulWidget {
  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  bool textScanning = false;
  String? scannedtext = "";
  File? imagepicked;

  getimage(var source) async {
    final imagepick = await ImagePicker().pickImage(source: source);

    setState(() {
      if (imagepick != null) {
        imagepicked = File(imagepick.path);
        textScanning = true;
        getrecogonization(imagepick);
      } else {
        textScanning = false;

        return;
      }
    });
  }

  getrecogonization(XFile imag) async {
    final inputImage = InputImage.fromFilePath(imag.path);
    final textDetector = GoogleMlKit.vision.textRecognizer();
    RecognizedText recognizedText = await textDetector.processImage(inputImage);
    await textDetector.close();
    scannedtext = "";
    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        scannedtext = scannedtext! + line.text + "\n";
      }
    }
    textScanning = false;
    setState(() {
      // t = !t;
    });
  }

  bool t = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      backgroundColor: Colors.black,
      appBar: AppBar(
        actions: [Icon(Icons.more_vert,color: Colors.white,size: 25,)],
        leading: Icon(Icons.text_fields_outlined,color: Colors.white,size: 35,),
        centerTitle: true,
        title: Text(
          "Text Recogonizer",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.black,
        toolbarHeight: 80,
      ),
      // ignore: avoid_unnecessary_containers
      body: Card(
        color: Color.fromARGB(221, 28, 28, 28),
        child: SingleChildScrollView(
          child: Column(
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 350,
                width: 350,
                //  color: Colors.amber,
                child: textScanning
                    ? Center(child: CircularProgressIndicator())
                    : imagepicked == null
                        ? LottieBuilder.asset(
                            "assets/108979-image-scanning-finding-searching.json")
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.file(
                              File(
                                imagepicked!.path,
                              ),
                              // fit: BoxFit.cover,
                            ),
                          ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          width: 1,
                          color: const Color.fromARGB(201, 255, 255, 255))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(width: 1, color: Colors.white)),
                        child: IconButton(
                            onPressed: () {
                              getimage(ImageSource.camera);
                            },
                            icon: Icon(
                              Icons.camera,
                              color: Colors.white,
                            )),
                      ),
                      VerticalDivider(),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(width: 1, color: Colors.white)),
                        child: IconButton(
                            onPressed: () {
                              getimage(ImageSource.gallery);
                            },
                            icon: Icon(
                              Icons.photo_sharp,
                              color: Colors.white,
                            )),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              scannedtext == null
                  ? SizedBox()
                  : Container(
                      width: 355,
                      height: 355,
                      decoration: BoxDecoration(
                        border: Border.all(
                            width: 1,
                            color: Color.fromARGB(168, 255, 255, 255)),
                        borderRadius: BorderRadius.circular(20),
                        color: Color.fromARGB(88, 67, 68, 67),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(left: 20, top: 10),
                        child: Align(
                            alignment: Alignment.center,
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Text(
                                    scannedtext.toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      ))
              // : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
