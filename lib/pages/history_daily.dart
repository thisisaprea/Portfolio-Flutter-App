import 'package:flutter/material.dart';

class history_daily extends StatefulWidget {
  const history_daily({Key? key}) : super(key: key);

  @override
  _history_dailyState createState() => _history_dailyState();
}

class _history_dailyState extends State<history_daily> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent.shade200,
        title: const Text("ประวัติการกินประจำวัน"),
      ),
    );
  }
}
