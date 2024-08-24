import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_speech/flutter_speech.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_translate/extensions/string_extension.dart';
import 'package:http/http.dart' as http;

const languages = const [
  const Language('Hindi', 'hi'),
  const Language('Urdu', 'ur_PK'),
];

class Language {
  final String name;
  final String code;

  const Language(this.name, this.code);
}

class ImageQueryScreen extends StatefulWidget {
  final String space;
  const ImageQueryScreen({Key? key, required this.space}) : super(key: key);

  @override
  State<ImageQueryScreen> createState() => _ImageQueryScreenState();
}

class _ImageQueryScreenState extends State<ImageQueryScreen> {
  late SpeechRecognition _speech;
  FlutterTts flutterTts = FlutterTts();

  bool _speechRecognitionAvailable = false;
  bool _isListening = false;
  bool _isProcess = false;

  String transcription = '';
  String finalTranslation = '';

  String _currentLocale = 'hi';
  Language selectedLang = languages.first;

  @override
  initState() {
    super.initState();
    activateSpeechRecognizer();
    // updateUI(widget.locationWeather);
  }

  void playText(String text) async {
    await flutterTts.setLanguage("hi");
    await flutterTts.speak(text);
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  void activateSpeechRecognizer() {
    print('_MyAppState.activateSpeechRecognizer... ');
    _speech = SpeechRecognition();
    _speech.setAvailabilityHandler(onSpeechAvailability);
    _speech.setRecognitionStartedHandler(onRecognitionStarted);
    _speech.setRecognitionResultHandler(onRecognitionResult);
    _speech.setRecognitionCompleteHandler(onRecognitionComplete);
    _speech.setErrorHandler(errorHandler);
    _speech.activate(_currentLocale).then((res) {
      setState(() => _speechRecognitionAvailable = res);
    });
  }

  void getQuery(String query) async {
    setState(() {
      _isProcess = true;
    });
    await query.translate(sourceLanguage: 'hi', targetLanguage: 'en').then(
      (value) async {
        final apiUrl = "http://52.66.21.82/query";

        print(value);

        var response = await http.post(Uri.parse(apiUrl),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({"query": value, "context": widget.space}));

        print(response.body);

        var res = json.decode(response.body);

        print(res["message"]);
        String semiAns = res["message"];

        await semiAns
            .translate(sourceLanguage: 'en', targetLanguage: 'hi')
            .then((finalres) async {
          setState(() {
            finalTranslation = finalres;
            _isProcess = false;
          });
          playText(finalTranslation);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ask question by speaking"),
        backgroundColor: Color.fromARGB(255, 243, 33, 159),
        actions: [
          PopupMenuButton<Language>(
            icon: Icon(Icons.language),
            onSelected: _onLanguageSelected,
            itemBuilder: (BuildContext context) {
              return _buildLanguagesWidgets;
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                        height: 100,
                        padding: const EdgeInsets.all(8.0),
                        color: const Color.fromARGB(255, 238, 238, 238),
                        child: Text(transcription)),
                    _buildButton(onPressed: () {
                      if (_speechRecognitionAvailable && !_isListening) {
                        start();
                      }
                    }),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(
                child: _isProcess == true
                    ? SizedBox(
                        width: 28,
                        height: 28,
                        child: const CircularProgressIndicator(
                          color: Colors.blue,
                        ),
                      )
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            height: 400,
                            padding: const EdgeInsets.all(8.0),
                            color: const Color.fromARGB(255, 238, 238, 238),
                            child: new Expanded(
                              flex: 1,
                              child: new SingleChildScrollView(
                                child: Text(finalTranslation),
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<CheckedPopupMenuItem<Language>> get _buildLanguagesWidgets => languages
      .map((l) => CheckedPopupMenuItem<Language>(
            value: l,
            checked: selectedLang == l,
            child: Text(l.name),
          ))
      .toList();

  void _selectLangHandler(Language lang) {
    setState(() => selectedLang = lang);
  }

  Widget _buildButton({VoidCallback? onPressed}) => Padding(
      padding: EdgeInsets.all(12.0),
      child: IconButton(
        iconSize: 70,
        onPressed: onPressed,
        icon: Icon(
          Icons.mic,
          color: Color.fromARGB(255, 96, 196, 239),
        ),
      ));

  void start() => _speech.activate(selectedLang.code).then((_) {
        return _speech.listen().then((result) {
          print('_MyAppState.start => result $result');
          setState(() {
            _isListening = result;
          });
        });
      });

  void cancel() =>
      _speech.cancel().then((_) => setState(() => _isListening = false));

  void stop() => _speech.stop().then((_) {
        setState(() => _isListening = false);
      });

  void onSpeechAvailability(bool result) =>
      setState(() => _speechRecognitionAvailable = result);

  void onCurrentLocale(String locale) {
    print('_MyAppState.onCurrentLocale... $locale');
    setState(
        () => selectedLang = languages.firstWhere((l) => l.code == locale));
  }

  void onRecognitionStarted() {
    // Utils().toastMessage('Listening....',Colors.green);
    setState(() => _isListening = true);
  }

  void onRecognitionResult(String text) {
    print('_MyAppState.onRecognitionResult... $text');
    setState(() {
      transcription = text;
    });
  }

  void onRecognitionComplete(String text) {
    // Utils().toastMessage('Completed....',Colors.green);
    print('_MyAppState.onRecognitionComplete... $text');

    // Navigator.push(context, MaterialPageRoute(builder: (context)=> SearchWidget(search: transcription,)));
    if (_isListening) {
      getQuery(transcription);
    }

    setState(() {
      _isListening = false;
    });
  }

  void errorHandler() => activateSpeechRecognizer();

  void _onLanguageSelected(Language lang) {
    setState(() {
      selectedLang = lang;
      // You can also update the speech recognizer language here
      _speech.activate(selectedLang.code);
    });
  }
}
