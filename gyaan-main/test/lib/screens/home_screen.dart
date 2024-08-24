import 'package:flutter/material.dart';
import 'package:gyaan/screens/createbot_screen.dart';
import 'package:gyaan/screens/intel_bots.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _currentIndex = 0;

  static const List<Widget> _pages = <Widget>[IntelBots(), CreateBot()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            "Consulting with Bots",
            style: TextStyle(
                color: Color.fromARGB(255, 255, 255, 255),
                fontWeight: FontWeight.w600),
          ),
          automaticallyImplyLeading: false,
          backgroundColor: Color.fromARGB(255, 105, 199, 240),
          actions: <Widget>[
            new IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                decoration:
                new InputDecoration(
                    prefixIcon: new Icon(Icons.search, color: Colors.white),
                    hintText: "Search...",
                    hintStyle: new TextStyle(color: Colors.white));
              },
            ),
          ]),
      body: Center(
        child: _pages.elementAt(_currentIndex),
      ),
      bottomNavigationBar: Container(
        height: 80,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(255, 255, 255, 255),
              spreadRadius: 5,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: SalomonBottomBar(
          // backgroundColor: Colors.white,
          unselectedItemColor: const Color.fromARGB(255, 105, 199, 240),
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          items: [
            ///bots
            SalomonBottomBarItem(
              icon: Icon(Icons.reddit),
              title: Text("Talk With Bot"),
              selectedColor: const Color.fromARGB(255, 105, 199, 240),
            ),

            /// create bots
            SalomonBottomBarItem(
              icon: Icon(Icons.create),
              title: Text("Create Bot"),
              selectedColor: const Color.fromARGB(255, 105, 199, 240),
            ),
          ],
        ),
      ),
    );
  }
}
