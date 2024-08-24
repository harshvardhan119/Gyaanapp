import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gyaan/widgets/bot_card.dart';
import 'package:http/http.dart' as http;

class IntelBots extends StatefulWidget {
  const IntelBots({super.key});

  @override
  State<IntelBots> createState() => _IntelBotsState();
}

class _IntelBotsState extends State<IntelBots> {
  List data = [];

  @override
  void initState() {
    super.initState();
    fetchBots();
  }

  fetchBots() async {
    final response = await http.get(Uri.parse('http://52.66.21.82/getbot'));

    if (response.statusCode == 201) {
      List res = json.decode(response.body);
      setState(() {
        data = res;
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 20),
        child: ListView.builder(
          itemCount: data.length,
          itemBuilder: ((context, index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: BotCard(
                  bot: data[index],
                ),
              )),
        ),
      ),
    );
  }
}
