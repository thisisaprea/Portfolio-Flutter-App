

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:project_final/pages/history.dart';
import 'package:project_final/services/Api.dart';

import '../controller/user_model.dart';
import 'HomePage.dart';
import 'Profile_User.dart';
import 'food_list.dart';
import 'history_first.dart';


class Bottom_Pages extends StatefulWidget {
  static const routeName = '/Bottom_Page';

  const Bottom_Pages({Key? key}) : super(key: key);

  @override
  _Bottom_PagesState createState() => _Bottom_PagesState();
}

class _Bottom_PagesState extends State<Bottom_Pages> {

  int _selectedIndex = 0;

  final screens = [
    HomePage(),
    ItemList(),
    report_static(),
    profile_user(),
  ];

  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white70,
        //type: BottomNavigationBarType.fixed,
        selectedFontSize: 20,
        selectedIconTheme: IconThemeData(color: Colors.white, size: 29),
        selectedItemColor: Colors.white,
        selectedLabelStyle:
            TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),
        unselectedItemColor: Colors.white,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_max_outlined),
              label: 'หน้าหลัก',
              backgroundColor: Colors.green.shade400),
          BottomNavigationBarItem(
              icon: Icon(Icons.food_bank_outlined),
              label: 'มื้ออาหาร',
              backgroundColor: Colors.deepOrange.shade400),
          BottomNavigationBarItem(
              icon: Icon(Icons.auto_graph_outlined),
              label: 'รายงาน',
              backgroundColor: Colors.blueAccent.shade200),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            label: 'โปรไฟล์',
            backgroundColor: Colors.deepPurple.shade400,
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) {
          /*Api apiRest = new Api();
          restActivity = await apiRest.get_activity();*/

          setState(() {
            _selectedIndex = index;
          });
        },
      ),

      //floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: screens[_selectedIndex],
    );
  }
}
