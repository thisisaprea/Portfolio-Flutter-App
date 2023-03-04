import 'package:flutter/material.dart';

class testPage extends StatefulWidget {
  const testPage({Key? key}) : super(key: key);

  @override
  _testPageState createState() => _testPageState();
}

class _testPageState extends State<testPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ListView'),
      ),
      body: Column(
        children: [
          Container(
            height: 150,
            color: Colors.deepOrange.shade400,
            child: Center(
              child: Text('Widgets'),
            ),
          ),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: 30,
                itemBuilder: (context, index) => ListTile(
                  title: Text('Item ${index +1}'),
                )),
          )
        ],
      ),
    );
  }
}
