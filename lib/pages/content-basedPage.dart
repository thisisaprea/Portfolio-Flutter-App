import 'package:flutter/material.dart';

class contentBasePage extends StatefulWidget {
  const contentBasePage({Key? key}) : super(key: key);

  @override
  _contentBasePageState createState() => _contentBasePageState();
}

class _contentBasePageState extends State<contentBasePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange.shade400,
        title: const Text("แนะนำแบบ Content-based"),
      ),
    );
  }
}
