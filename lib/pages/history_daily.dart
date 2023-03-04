import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/Api.dart';

class history_daily extends StatefulWidget {
  //const history_daily({Key? key}) : super(key: key);
  var restListActivity;
  var title;

  history_daily({required this.restListActivity});

  @override
  _history_dailyState createState() =>
      _history_dailyState(restListActivity: this.restListActivity);
}

class _history_dailyState extends State<history_daily> {
  var restListActivity;
  var title = 'ประวัติกิจกรรมของวันนี้';
  var subText, titleText, iconActivity, colorActivity;

  _history_dailyState({required this.restListActivity});
  late SharedPreferences pref;

  int number = 0;
  bool select = false;
  var showSelectAcitivityFood;
  String? formatStart;
  String? formatEnd;
  @override
  void initState() {
    super.initState();
    for (var i in restListActivity) {
      number = number + 1;
    }
  }

  var _start;
  var _end;
  DateTimeRange seledtedDates = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now(),
  );

  @override
  Widget build(BuildContext context) {
    final selectButton = ElevatedButton(
        onPressed: () async {

          final DateTimeRange? dateTimeRagne =
          await showDateRangePicker(
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
              print(seledtedDates);
              print(_start);
              print(formatStart);
              print(formatEnd);
              select = true;
            });
          }
          if(select){
            print('+++++++++++selcet----------');
            Api restContent = await new Api();
            pref = await SharedPreferences.getInstance();
            var restId = await pref.getString("token");
            showSelectAcitivityFood = await restContent.get_history(
                restId, formatStart, formatEnd);
            print(showSelectAcitivityFood);
          }
        },
        child: Text('Choose Dates'));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent.shade200,
        title: Text(title),
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Center(child: Text('${formatStart} - ${formatEnd}')),
              selectButton,
              SizedBox(
                height: 10,
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    physics: ScrollPhysics(parent: null),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      /*if(select = true){
                        if (showSelectAcitivityFood[index]['activity'] == 'food') {
                          iconActivity = Icons.fastfood;
                          colorActivity = Colors.orange.shade200;
                          titleText = showSelectAcitivityFood[index]['nameactivity'];
                          subText = 'มื้อที่กิน : ' +
                              showSelectAcitivityFood[index]['meal'] +
                              " จำนวน : " +
                              showSelectAcitivityFood[index]['amount'] +
                              ' น้ำตาล : ' +
                              showSelectAcitivityFood[index]['sugar']
                                  .toStringAsFixed(2) +
                              '\nวันที่ ' +
                              (showSelectAcitivityFood[index]['datetime'])
                                  .substring(0, 11) +
                              ' เวลา ' +
                              (showSelectAcitivityFood[index]['datetime']).substring(
                                  11,
                                  showSelectAcitivityFood[index]['datetime'].length) +
                              ' น.';
                        } else {
                          iconActivity = Icons.sports;
                          colorActivity = Colors.lightGreen.shade400;
                          titleText = showSelectAcitivityFood[index]['nameactivity'];
                          subText = 'ระยะเวลาออกกำลังกาย : ' +
                              showSelectAcitivityFood[index]['timestamp'] +
                              ' น้ำตาล : ' +
                              showSelectAcitivityFood[index]['sugar']
                                  .toStringAsFixed(2) +
                              '\nวันที่ ' +
                              (showSelectAcitivityFood[index]['datetime'])
                                  .substring(0, 11) +
                              ' เวลา ' +
                              (showSelectAcitivityFood[index]['datetime']).substring(
                                  11,
                                  showSelectAcitivityFood[index]['datetime'].length) +
                              ' น.';
                        }
                      }else{*/
                        if (restListActivity[index]['activity'] == 'food') {
                          iconActivity = Icons.fastfood;
                          colorActivity = Colors.orange.shade200;
                          titleText = restListActivity[index]['nameactivity'];
                          subText = 'มื้อที่กิน : ' +
                              restListActivity[index]['meal'] +
                              " จำนวน : " +
                              restListActivity[index]['amount'] +
                              ' น้ำตาล : ' +
                              restListActivity[index]['sugar']
                                  .toStringAsFixed(2) +
                              '\nวันที่ ' +
                              (restListActivity[index]['datetime'])
                                  .substring(0, 11) +
                              ' เวลา ' +
                              (restListActivity[index]['datetime']).substring(
                                  11,
                                  restListActivity[index]['datetime'].length) +
                              ' น.';
                        } else {
                          iconActivity = Icons.sports;
                          colorActivity = Colors.lightGreen.shade400;
                          titleText = restListActivity[index]['nameactivity'];
                          subText = 'ระยะเวลาออกกำลังกาย : ' +
                              restListActivity[index]['timestamp'] +
                              ' น้ำตาล : ' +
                              restListActivity[index]['sugar']
                                  .toStringAsFixed(2) +
                              '\nวันที่ ' +
                              (restListActivity[index]['datetime'])
                                  .substring(0, 11) +
                              ' เวลา ' +
                              (restListActivity[index]['datetime']).substring(
                                  11,
                                  restListActivity[index]['datetime'].length) +
                              ' น.';
                        }
                      return Container(
                        margin: EdgeInsets.only(bottom: 8),
                        padding:
                            EdgeInsets.only(top: 15, left: 10, right: 10),
                        decoration: BoxDecoration(
                          color: colorActivity,
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                        child: ListTile(
                          trailing: Text(restListActivity[index]['sugar']
                              .toStringAsFixed(2)),
                          title: Text(titleText),
                          subtitle: Text(subText),
                          leading: Icon(iconActivity),
                        ),
                      );
                    },
                    itemCount: number,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              /*InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => report_static()));
                },
                child: Padding(
                  padding: EdgeInsets.only(top: 24, left: 10, right: 10),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 5,
                    decoration: BoxDecoration(
                      color: Colors.blueAccent.shade100,
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(top: 5, left: 24, right: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '24/02/2023',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 30.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),*/
            ],
          ),
        ),
      ),
    );
  }
}
