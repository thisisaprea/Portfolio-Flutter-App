import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/Api.dart';

class history_today extends StatefulWidget {
  const history_today({Key? key}) : super(key: key);

  @override
  _history_todayState createState() => _history_todayState();
}

class _history_todayState extends State<history_today> {
  String? formatStart;
  String? formatEnd;
  var _start;
  var _end;
  var listHistory;
  var title = 'ประวัติกิจกรรมของวันนี้';
  var restListActivity;
  var subText, titleText, iconActivity, colorActivity;
  DateTimeRange seledtedDates = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now(),
  );
  late SharedPreferences pref;
  DateTime dateTime = DateTime.now();
  String? dateStart;
  int number = 0;
  void setDateStart() {
    setState(() {
      dateStart = '24/02/2023';
    });
  }
  void getHistorydataUser() async {
    Api restContent = await new Api();
    pref = await SharedPreferences.getInstance();
    String formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);
    var restId = await pref.getString("token");
    restListActivity = await restContent.get_history(restId, dateStart, formattedDate);
    setState(() {
      print('111111111111111111111111111111111111');
      print(restListActivity['data_history'][0]);
      print('111111111111111111111111111111111111');
      listHistory =restListActivity['data_history'][0];
      print(listHistory);
      print('111111111111111111111111111111111111');
    });
  }
  @override
  void initState() {
    super.initState();
    //restListActivity.clear();

    /*for (var i in listHistory) {
      number = number + 1;
    }*/
    setDateStart();
    getHistorydataUser();

  }
  @override
  Widget build(BuildContext context) {
    final selectDateButton = ElevatedButton(
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
              formatStart = DateFormat('dd/MM/yyyy').format(_start);
              formatEnd = DateFormat('dd/MM/yyyy').format(_end);
              print(seledtedDates);
              print(_start);
              print(formatStart);
              print(formatEnd);

            });
          }
          Api restContent = await new Api();
          pref = await SharedPreferences.getInstance();
          String formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);
          var restId = await pref.getString("token");
          restListActivity = await restContent.get_history(restId, dateStart, formattedDate);
          setState(() {
            print(restListActivity);
            print('222222222222222222222222222222222222');
            listHistory = restListActivity['data_history'][0];
            print(listHistory);
            print('2222222222222222222222222222222222222');
          });
        },
        child: Text('Choose Dates'));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade400,
        title: Text('รายงานกิจกรรม'),
      ),
      body: SafeArea(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              color: Colors.blue.shade400,
              child: Column(
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Center(child: Text('${formatStart} - ${formatEnd}')),
                  SizedBox(
                    height: 10,
                  ),
                  selectDateButton,
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  physics: ScrollPhysics(parent: null),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    print('//////////////////////////////////////////////');
                    if (listHistory[index]['activity'] == 'food') {
                      iconActivity = Icons.fastfood;
                      colorActivity = Colors.orange.shade200;
                      titleText = listHistory[index]['nameactivity'];
                      subText = 'มื้อที่กิน : ' +
                          listHistory[index]['meal'] +
                          " จำนวน : " +
                          listHistory[index]['amount'] +
                          ' น้ำตาล : ' +
                          listHistory[index]['sugar']
                              .toStringAsFixed(2) +
                          '\nวันที่ ' +
                          (listHistory[index]['datetime'])
                              .substring(0, 11) +
                          ' เวลา ' +
                          (listHistory[index]['datetime']).substring(
                              11,
                              listHistory[index]['datetime'].length) +
                          ' น.';
                      print('//////////////////////////////////////////////');
                    } else {
                      iconActivity = Icons.sports;
                      colorActivity = Colors.lightGreen.shade400;
                      print('//////////////////////////////////////////////');
                      titleText = listHistory[index]['nameactivity'];
                      subText = 'ระยะเวลาออกกำลังกาย : ' +
                          listHistory[index]['timestamp'] +
                          ' น้ำตาล : ' +
                          listHistory[index]['sugar']
                              .toStringAsFixed(2) +
                          '\nวันที่ ' +
                          (listHistory[index]['datetime'])
                              .substring(0, 11) +
                          ' เวลา ' +
                          (listHistory[index]['datetime']).substring(
                              11,
                              listHistory[index]['datetime'].length) +
                          ' น.';
                      print('//////////////////////////////////////////////');
                    }
                    return Container(
                      margin: EdgeInsets.only(bottom: 8),
                      padding:
                      EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
                      decoration: BoxDecoration(
                        color: colorActivity,
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      child: ListTile(
                        trailing: Text(listHistory[index]['sugar'].toStringAsFixed(2)),
                        title: Text(titleText),
                        subtitle: Text(subText),
                        leading: Icon(iconActivity),
                      ),
                    );
                  },
                  itemCount: listHistory.length,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),

      ),
    );
  }
}
