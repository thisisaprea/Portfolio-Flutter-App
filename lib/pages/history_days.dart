import 'package:colours/colours.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
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
  var textToast;
  var restListActivity;
  bool showDate = true;
  bool loading = false;
  var subText, titleText, iconActivity, colorActivity, colorText;
  DateTimeRange seledtedDates = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now(),
  );
  late SharedPreferences pref;
  DateTime dateTime = DateTime.now();
  String? dateStart;
  int number = 0;

  void _onLoading() {
    setState(() {
      loading = true;
      new Future.delayed(new Duration(seconds: 2),getHistorydataUser);
    });
  }

  void getHistorydataUser() async {
    Api restContent = await new Api();
    pref = await SharedPreferences.getInstance();
    String formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);
    var restId = await pref.getString("token");
    restListActivity = await restContent.get_history(restId, "", "");
    loading = false;
    setState(() {
      try {
        listHistory = restListActivity['data_history'][0];
      } catch (e) {
        textToast = 'คุณยังไม่มีกิจกรรมวันนี้';
      }
      print('111111111111111111111111111111111111');
      print(restListActivity['data_history'][0]);
      print('***********1111111111//////////////');

      print(listHistory);
      print('11111111bbbbbbbbbbbbbbb1111111111111');
      print(dateStart);
      print(formattedDate);
    });
  }

  @override
  void initState() {
    super.initState();
    _onLoading();
    getHistorydataUser();
  }

  @override
  Widget build(BuildContext context) {
    final selectDateButton = ElevatedButton(
      onPressed: () async {
        final DateTimeRange? dateTimeRagne = await showDateRangePicker(
            context: context,
            firstDate: DateTime(2023),
            lastDate: DateTime.now());
        if (dateTimeRagne != null) {
          setState(() {
            seledtedDates = dateTimeRagne;
            _start = seledtedDates.start;
            _end = seledtedDates.end;
            formatStart = DateFormat('dd/MM/yyyy').format(_start);
            formatEnd = DateFormat('dd/MM/yyyy').format(_end);
            print(formatStart);
            print(formatEnd);
          });
        }

        Api restContent = await new Api();
        pref = await SharedPreferences.getInstance();
        //String formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);
        var restId = await pref.getString("token");
        showDate = false;
        restListActivity = await restContent.get_history(restId, formatStart, formatEnd);
        setState(() {
          print('222222222222222222222222222222222222');
          print(restListActivity);
          print('222222222222222222222222222222222222');
          listHistory = restListActivity['data_history'][0];
          print(listHistory);
          print('2222222222222222222222222222222222222');
          print(formatStart);
          print(formatEnd);
        });
      },
      child: Text('เลือกวันที่'),
      style: ElevatedButton.styleFrom(
          backgroundColor: Colours.cornFlowerBlue.withOpacity(0.7),
          side: BorderSide.none,
          shape: StadiumBorder()),
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colours.cornFlowerBlue.withOpacity(0.7),
        title: Text('รายงานกิจกรรม'),
      ),
      backgroundColor: Colours.lightGoldenRodYellow.withOpacity(0.8),
      body: SafeArea(
        child: loading? Center(child: CircularProgressIndicator(),) :
        Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.only(right: 20, left: 20),
              color: Colours.white24.withOpacity(0.1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [ showDate? Center(child: Text('',),)
                    : Center(
                    child: Text(
                      '${formatStart} - ${formatEnd}',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 15),
                    ),
                  ),
                  selectDateButton,
                ],
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(right: 12, left: 12),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ListView.builder(
                        physics: ScrollPhysics(parent: null),
                        shrinkWrap: true,
                        itemCount: listHistory.length,
                        itemBuilder: (context, index) {
                          print('//////////////////////////////////////////////');
                          if (listHistory[index]['activity'] == 'food') {
                            iconActivity = Icons.fastfood;
                            colorActivity = Colours.skyBlue;
                            colorText = Colors.black;
                            titleText = listHistory[index]['nameactivity'];
                            subText = 'มื้อที่กิน : ' +
                                listHistory[index]['meal'] +
                                " จำนวน : " +
                                listHistory[index]['amount'] +
                                ' น้ำตาล : ' +
                                listHistory[index]['sugar'].toStringAsFixed(2) +
                                '\nวันที่ ' +
                                (listHistory[index]['datetime']).substring(0, 11) +
                                ' เวลา ' +
                                (listHistory[index]['datetime']).substring(
                                    11, listHistory[index]['datetime'].length) +
                                ' น.';
                            print('//////////////////////////////////////////////');
                          } else {
                            iconActivity = Icons.sports;
                            colorActivity = Colours.steelBlue;
                            colorText = Colors.white;
                            print('//////////////////////////////////////////////');
                            titleText = listHistory[index]['nameactivity'];
                            subText = 'ระยะเวลาออกกำลังกาย : ' +
                                listHistory[index]['timestamp'] +
                                ' น้ำตาล : ' +
                                listHistory[index]['sugar'].toStringAsFixed(2) +
                                '\nวันที่ ' +
                                (listHistory[index]['datetime']).substring(0, 11) +
                                ' เวลา ' +
                                (listHistory[index]['datetime']).substring(
                                    11, listHistory[index]['datetime'].length) +
                                ' น.';
                            print('//////////////////////////////////////////////');
                          }
                          return Container(
                            margin: EdgeInsets.only(bottom: 8),
                            padding: EdgeInsets.only(
                                top: 10, left: 10, right: 10, bottom: 10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black, //color of border
                                width: 2, //width of border
                              ),
                              color: colorActivity,
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                            child: ListTile(
                              trailing: Text(
                                  listHistory[index]['sugar'].toStringAsFixed(2),style: TextStyle(fontSize: 18, color: colorText),),
                              title: Text(
                                titleText,
                                style: TextStyle(fontSize: 18, color: colorText),
                              ),
                              subtitle: Text(
                                subText,
                                style: TextStyle(fontSize: 18, color: colorText),
                              ),
                              leading: Icon(iconActivity),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
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
