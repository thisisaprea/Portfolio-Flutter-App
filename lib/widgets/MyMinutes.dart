import 'package:flutter/material.dart';

class MyMinutes extends StatelessWidget {
  int mins;
  //const MyMinutes({Key? key}) : super(key: key);
  MyMinutes({required this.mins});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        child: Center(
          child: Text(
            mins < 10 ? '0' + mins.toString() : mins.toString(),
            style: TextStyle(
              fontSize: 40,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
