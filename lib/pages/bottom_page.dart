import 'package:colours/colours.dart';
import 'package:flutter/material.dart';
import 'package:project_final/pages/FriendTextFields.dart';
import 'package:project_final/pages/onBoading.dart';
import 'package:project_final/pages/test.dart';
import 'HomePage.dart';
import 'Profile_Page.dart';
import 'food_list.dart';
import 'history_days.dart';

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
    history_today(),
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
              backgroundColor: Colours.darkGreen.withOpacity(0.8),
              ),
          BottomNavigationBarItem(
              icon: Icon(Icons.food_bank_outlined),
              label: 'แนะนำอาหาร',
            backgroundColor: Colours.darkGreen.withOpacity(0.8),),
          BottomNavigationBarItem(
              icon: Icon(Icons.auto_graph_outlined),
              label: 'รายงาน',
            backgroundColor: Colours.darkGreen.withOpacity(0.8),),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            label: 'โปรไฟล์',
            backgroundColor: Colours.darkGreen.withOpacity(0.8),
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
