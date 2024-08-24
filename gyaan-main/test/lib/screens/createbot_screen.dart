import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:gyaan/utils/utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CreateBot extends StatefulWidget {
  const CreateBot({super.key});

  @override
  State<CreateBot> createState() => _CreateBotState();
}

class _CreateBotState extends State<CreateBot> {
  static String url = 'https://kozjxvhnfeznacutgbsd.supabase.co';
  static String key =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imtvemp4dmhuZmV6bmFjdXRnYnNkIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY5ODUyMzQwMiwiZXhwIjoyMDE0MDk5NDAyfQ.7OC9_SSt8OIqsVjvF7uolv9opJFI2k1bybyAEFboJ_I';

  final SupabaseClient client = SupabaseClient(url, key);

  bool uploadFileStatus = false;
  bool uploadCoverstatus = false;
  bool deploystatus = false;
  var coverLine = "";
  var fileLine = "";
  var coverPath = "";

  TextEditingController _botName = TextEditingController();
  TextEditingController _botDesc = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<http.Response> createBotApi() {
    return http.post(
      Uri.parse('http://52.66.21.82/bot'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'name': _botName.text,
        'fileid': fileLine,
        'desc': _botDesc.text,
        'cover_link': coverPath
      }),
    );
  }

  Future uploadFile() async {
    var pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    // print(result!.files.first.path as String);
    if (pickedFile != null) {
      setState(() {
        uploadFileStatus = true;
      });
      File file = File(pickedFile.files.first.path as String);
      await client.storage
          .from("gyaan")
          .upload(pickedFile.files.first.name, file)
          .then((value) {
        print(value);
        setState(() {
          uploadFileStatus = false;
          fileLine = pickedFile.files.first.name;
        });
      });
    } else {
      setState(() {
        uploadFileStatus = false;
      });
      showSnackBar(context, "No files were picked");
    }
  }

  Future uploadCover() async {
    var pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png'],
    );

    // print(result!.files.first.path as String);
    if (pickedFile != null) {
      setState(() {
        uploadCoverstatus = true;
      });
      File file = File(pickedFile.files.first.path as String);
      final String path = await client.storage
          .from("gyaan_cover")
          .upload(pickedFile.files.first.name, file);

      final String publicUrl = client.storage
          .from("gyaan_cover")
          .getPublicUrl(pickedFile.files.first.name);

      setState(() {
        uploadCoverstatus = false;
        coverLine = pickedFile.files.first.name;
        coverPath = publicUrl;
      });

      print(publicUrl + " lol");
    } else {
      setState(() {
        uploadCoverstatus = false;
      });
      showSnackBar(context, "No Image were picked");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                height: 180,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 110, 217, 253),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(255, 125, 212, 249), //New
                      blurRadius: 2.0,
                    )
                  ],
                ),
                child: Center(
                  child: Stack(
                    children: [
                      GestureDetector(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 50),
                          child: uploadFileStatus == true
                              ? const CircularProgressIndicator(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                )
                              : Column(
                                  children: [
                                    Icon(
                                      Icons.upload_file,
                                      size: 54,
                                      color: Color.fromARGB(255, 255, 255, 255),
                                    ),
                                    Text(
                                      fileLine.length > 0
                                          ? fileLine
                                          : "Tap to add the file",
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.white),
                                    )
                                  ],
                                ),
                        ),
                        onTap: () async {
                          uploadFile();
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
                child: Container(
                  height: 180,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 110, 217, 253),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(255, 146, 146, 145), //New
                        blurRadius: 2.0,
                      )
                    ],
                  ),
                  child: Center(
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 50),
                          child: uploadCoverstatus == true
                              ? const CircularProgressIndicator(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                )
                              : Column(
                                  children: [
                                    Icon(
                                      Icons.image_outlined,
                                      size: 54,
                                      color: Color.fromARGB(255, 255, 255, 255),
                                    ),
                                    Text(
                                      coverLine.length > 0
                                          ? coverLine
                                          : "Tap to add the Cover Image",
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.white),
                                    )
                                  ],
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              onTap: () async {
                uploadCover();
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: TextField(
                controller: _botName,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter a Bot Name',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: TextField(
                controller: _botDesc,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter a Bot Description',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: ElevatedButton(
                onPressed: () async {
                  setState(() {
                    deploystatus = true;
                  });
                  final res = await createBotApi();
                  print(res);
                  setState(() {
                    showSnackBar(context, "Deployment completed!");
                    deploystatus = false;
                  });
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    Color.fromARGB(255, 105, 199, 240),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: deploystatus == true
                      ? SizedBox(
                          child: const CircularProgressIndicator(
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                          height: 28,
                          width: 28,
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.reddit_sharp),
                            SizedBox(
                              width: 20,
                              height: 40,
                            ),
                            Text(
                              'Deploy The Bot',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
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
