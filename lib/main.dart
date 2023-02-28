import 'package:flutter/material.dart';
import 'package:project_final/pages/bottom_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project_final/pages/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences perfs = await SharedPreferences.getInstance();
  var status_login = await perfs.getString("statusLogin") ?? "False";

  runApp(MyApp(status_login: await status_login));

  //runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  //const MyApp({super.key});
  var status_login;

  MyApp({required this.status_login});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var page;
    if (status_login == 'False') {
      page = login_page();
    } else {
      page = Bottom_Pages();
    }
    return MaterialApp(

      home: page,
    );
  }
}
