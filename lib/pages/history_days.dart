import 'package:flutter/material.dart';

class history_today extends StatefulWidget {
  const history_today({Key? key}) : super(key: key);

  @override
  _history_todayState createState() => _history_todayState();
}
var _start;
var _end;
DateTimeRange seledtedDates = DateTimeRange(
  start: DateTime.now(),
  end: DateTime.now(),
);

class _history_todayState extends State<history_today> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: Text('${_start} - ${_end}')),
            ElevatedButton(
                onPressed: () async{
                  final DateTimeRange? dateTimeRagne = await showDateRangePicker(
                      context: context,
                      firstDate: DateTime(2023),
                      lastDate: DateTime.now()
                  );
                  if(dateTimeRagne != null){
                    setState(() {
                      seledtedDates = dateTimeRagne;
                      _start = seledtedDates.toString().substring(0,10);
                      _end = seledtedDates.toString().substring(26,36);
                      print(seledtedDates);

                      print(_start.replaceAll('-','/'));
                      print(_end.replaceAll('-','/'));
                    });
                  }
                },
                child: Text('Choose Dates')),
          ],
        ),

      ),
    );
  }
}
