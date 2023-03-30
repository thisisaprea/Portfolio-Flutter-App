import 'package:colours/colours.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:project_final/pages/FriendTextFields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

import '../services/Api.dart';

class test extends StatefulWidget {
  const test({Key? key}) : super(key: key);

  @override
  _testState createState() => _testState();
}

class _testState extends State<test> {
  String? formatStart;
  String? formatEnd;
  var _start;
  var _end;
  var listHistory;
  var textToast;
  var restListActivity;
  bool showDate = true;
  bool loading = false;
  var indexAppend = [];
  var indexAppend2 = [];
  var indexAppend3 = [];
  var listAppend;
  var listSugar = [];
  var listStrDate = [];
  var strDate;
  var sum = 0.0;
  List listWrap = [];
  late List<DataList> _chartData;
  List<num> listSugarWrap = [];
  double listNum = 0;
  List<String> listdayWrap = [];
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
      new Future.delayed(new Duration(seconds: 2), getHistorydataUser);
    });
  }

  void getHistorydataUser() async {
    Api restContent = await new Api();
    pref = await SharedPreferences.getInstance();
    String formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);
    var restId = await pref.getString("token");
    restListActivity =
    await restContent.get_history(restId, '12/03/2023', formattedDate);
    loading = false;
    setState(() {
      try {
        for(var i in restListActivity['data_history']){
          for(var j in i){
            indexAppend.add(j);
          }
        }
        print(restListActivity['data_history']);
        print('---------------------------');
        print(indexAppend);
        print('---------------------------');
        listAppend = indexAppend[0];
        print(indexAppend[0]);
        print('---------------------------');
        for(var i in indexAppend){
          listSugar.add(i);
        }
        for(var i = 0; i<listSugar.length;i++){
          if(listSugar[i]['activity'] == 'food'){
            sum = sum+double.parse(listSugar[i]['sugar'].toStringAsFixed(2));
          }
          listSugarWrap.add(double.parse(listSugar[i]['sugar'].toStringAsFixed(2)));
          strDate = listSugar[i]['dateformat'];
          listdayWrap.add(strDate);
        }
        listWrap = [{'sugar' : listSugarWrap},{'date':listdayWrap}];
        print(sum);
        print(listWrap[0]['sugar']);
        print(listWrap[1]);
        print(listSugarWrap);
        print(listdayWrap);
        //listHistory = restListActivity['data_history'][0];
      } catch (e) {
        textToast = 'คุณยังไม่มีกิจกรรมวันนี้';
      }
      print('111111111111111111111111111111111111');
      print(restListActivity['data_history'][0]);
      print('***********1111111111//////////////');


      print('11111111bbbbbbbbbbbbbbb1111111111111');
      print(formattedDate);
    });
  }

  var index = 0;

  @override
  void initState() {
    super.initState();
    _onLoading();
    getHistorydataUser();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colours.cornFlowerBlue.withOpacity(0.7),
        title: Text('รายงานกิจกรรม'),
      ),
      backgroundColor: Colours.lightGoldenRodYellow.withOpacity(0.8),
      body: SafeArea(
        child: loading
            ? Center(
          child: CircularProgressIndicator(),
        )
            : Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /*Container(
              padding: EdgeInsets.all(8),
              child: SfCartesianChart(
                series: <ChartSeries>[
                  StackedLineSeries<DataList, List>(
                    dataSource: _chartData,
                    xValueMapper: (DataList data, _) => listWrap[0]['date'],
                    yValueMapper: (DataList data, _) => num.parse(listWrap[1]['sugar']),
                    markerSettings: MarkerSettings(isVisible: true),
                    name: 'Day1',
                  ),
                ],
              ),
            ),*/
            /*SfCartesianChart(
              legend: Legend(isVisible: true),
              //tooltipBehavior: _tooltipBehavior,
              series: <ChartSeries>[
                StackedLineSeries<DataList, String>(
                  dataSource: _chartData,
                  xValueMapper: (DataList data, _) => data.name,
                  yValueMapper: (DataList data, _) => data.percent,
                  markerSettings: MarkerSettings(isVisible: true),
                  name: 'Day1',
                ),
              ],
              primaryXAxis: CategoryAxis(),
            ),*/
            Container(
              padding: EdgeInsets.only(right: 20, left: 20),
              color: Colours.white24.withOpacity(0.1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  showDate
                      ? Center(
                    child: Text(
                      '',
                    ),
                  )
                      : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color:
                        Colours.cornFlowerBlue.withOpacity(0.3),
                        borderRadius:
                        BorderRadius.all(Radius.circular(30)),
                      ),
                      child: Center(
                        child: Text(
                          '${formatStart} - ${formatEnd}',
                          style: GoogleFonts.notoSerifThai(
                            textStyle: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
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
class DataList {
  late final List<String> date;
  late final List<num> sugar;
  late final Color colorChart;
  DataList({
    required this.date,
    required this.colorChart,
    required this.sugar,
  });
}
