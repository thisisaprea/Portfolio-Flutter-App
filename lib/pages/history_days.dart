import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:in_date_range/in_date_range.dart';

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
            //Center(child: Text('${_start} - ${_end}')),
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
                      _start = seledtedDates.start;
                      _end = seledtedDates.end;
                      String formatStart = DateFormat('dd/MM/yyyy').format(_start);
                      String formatEnd = DateFormat('dd/MM/yyyy').format(_end);
                      print(seledtedDates);
                      print(_start);
                      print(formatStart);
                      print(formatEnd);

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
