import 'package:flutter/material.dart';
import 'package:gyaan/screens/consult.dart';

class BotCard extends StatefulWidget {
  final bot;
  BotCard({super.key, this.bot});

  @override
  State<BotCard> createState() => _BotCardState();
}

class _BotCardState extends State<BotCard> {
  @override
  Widget build(BuildContext context) {
    return Center(
      /** Card Widget **/
      child: Card(
        color: Color.fromARGB(255, 244, 243, 243),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.87,
          height: 350,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 350,
                  height: 150,
                  child: Image.network(widget.bot["cover_photo"]),
                ), //CircleAvatar
                const SizedBox(
                  height: 10,
                ), //SizedBox
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.bot["name"] ?? '',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontWeight: FontWeight.w600,
                      ), //Textstyle
                    ),
                    SizedBox(
                      height: 15,
                      width: 20,
                    ),
                    Text(
                      widget.bot["desc"] ?? '',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontWeight: FontWeight.w400,
                      ), //Textstyle
                    ),
                    SizedBox(
                      height: 15,
                      width: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ConsultScreen(
                                    space: widget.bot["fileid"] ?? '',
                                  )),
                        );
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Color.fromARGB(255, 105, 199, 240),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.reddit_sharp),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              'Talk With Bot',
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ), //Textext
                const SizedBox(
                  height: 10,
                ), //SizedBoxizedBox
              ],
            ), //Column
          ), //Padding
        ), //SizedBox
      ), //Card
    );
  }
}
