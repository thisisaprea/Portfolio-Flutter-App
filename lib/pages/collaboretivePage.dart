import 'package:flutter/material.dart';

class collaborePage extends StatefulWidget {
  const collaborePage({Key? key}) : super(key: key);

  @override
  _collaborePageState createState() => _collaborePageState();
}

class _collaborePageState extends State<collaborePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange.shade400,
        title: const Text("แนะนำแบบ Collaboretive"),
      ),
    );
  }
}
