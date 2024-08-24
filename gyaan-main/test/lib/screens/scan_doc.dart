import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:gyaan/screens/query_image.dart';
import 'package:gyaan/utils/utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;

class DocScreen extends StatefulWidget {
  const DocScreen({super.key});

  @override
  State<DocScreen> createState() => _DocScreenState();
}

class _DocScreenState extends State<DocScreen> {
  File? _image;
  final picker = ImagePicker();

  static const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  Future readTextFromImage() async {
    final inputImage = InputImage.fromFile(_image!);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage);
    String text = recognizedText.text;

    print(text + " lol");

    print(inputImage.filePath!.substring(0, 3) + " uoyo");

    var ctxid = getRandomString(5);

    var response = await http.post(Uri.parse('http://52.66.21.82/imagebot'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "data": text,
          "ctxname": ctxid,
        }));

    print(response.body);

    textRecognizer.close();

    showSnackBar(context, "image to text done!");

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ImageQueryScreen(
                space: ctxid ?? '',
              )),
    );
  }

  Future getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future getImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Talk with Doc"),
        backgroundColor: Color.fromARGB(255, 202, 30, 119),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 255, 255, 255),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 240,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                  ),
                  child: Container(
                    child: Lottie.asset('assets/animations/animation1.json'),
                  ),
                ),
                Text(
                  " बात कर\n सकते हैं \nअपने \nदस्तबेज़ो से",
                  style: TextStyle(
                    color: Colors.pink,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 60,
            ),
            GestureDetector(
              onTap: () {
                getImageFromGallery();
              },
              child: Container(
                height: 100,
                width: 280,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 202, 30, 119),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Icon(
                      Icons.image_rounded,
                      color: Colors.white,
                      size: 38,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Select From Gallery",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            GestureDetector(
              onTap: () {
                getImageFromCamera();
              },
              child: Container(
                height: 100,
                width: 280,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 202, 30, 119),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.white,
                      size: 38,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Take the Image",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            GestureDetector(
              onTap: () {
                readTextFromImage();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 202, 30, 119),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 20,
                        height: 40,
                      ),
                      Text(
                        'Submit the Doc',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
