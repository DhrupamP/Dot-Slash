import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:try_notif/pages/filespage.dart';
import 'package:try_notif/pages/homepage.dart';
import 'package:try_notif/pages/disease.dart';
import 'package:try_notif/pages/newspage.dart';

class SingleHome extends StatefulWidget {
  const SingleHome({Key? key}) : super(key: key);

  @override
  _SingleHomeState createState() => _SingleHomeState();
}

class _SingleHomeState extends State<SingleHome> {
  List<Widget> Pages = [HomePage(), DiseasePage(), NewsPage(), FilesPage()];
  int _selectedIndex = 0;
  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        iconSize: 30,
        showUnselectedLabels: false,
        showSelectedLabels: false,
        backgroundColor: Colors.white,
        selectedItemColor: Color(0xff021837),
        unselectedItemColor: Color(0xff021837),
        currentIndex: _selectedIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.camera_alt), label: ""),
          BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.newspaper), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.folder), label: "")
        ],
        onTap: onItemTapped,
      ),
      body: Pages[_selectedIndex],
    );
  }
}
