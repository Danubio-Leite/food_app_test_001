import 'package:flutter/material.dart';
import 'package:food_app_test_001/pages/assistant_test_page.dart';
import 'package:food_app_test_001/pages/firebase_test_page.dart';
import 'package:food_app_test_001/pages/mic_test_page.dart';
import 'package:food_app_test_001/pages/video_test_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    VideoPage(),
    MicPage(),
    FirebasePage(),
    AssistantPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.play_arrow),
            label: 'Video',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mic),
            label: 'Mic',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cloud),
            label: 'Firebase',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assistant),
            label: 'Assistant',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.grey[600],
        onTap: _onItemTapped,
      ),
    );
  }
}
