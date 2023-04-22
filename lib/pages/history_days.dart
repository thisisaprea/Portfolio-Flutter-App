import 'package:colours/colours.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
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
  var restListActivity, restList_;
  bool showDate = true;
  bool loading = false;
  bool texttitle = false;
  var indexAppend = [];
  var listAppend;
  var titleActivity, titleFood;
  var dateFood, dateActivity;
  var statusActivity;
  var indexAppendGraph = [];
  var sugar = [];

  var subText, titleText, iconActivity, colorActivity, colorText;
  DateTimeRange seledtedDates = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now(),
  );
  late SharedPreferences pref;
  DateTime dateTime = DateTime.now();
  String? dateStart;
  int number = 0;
  List<DataList> listChartData = [];
  var index = 0;

  @override
  void initState() {
    super.initState();
    _onLoading();
    getHistorydataUser();
    listChartData = [];
    //getGraphUser();
  }
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
        await restContent.get_history(restId, formattedDate, formattedDate);
    loading = false;
    setState(() {
      try {
        listHistory = restListActivity['data_history'][0];
        titleActivity = listHistory['datafood'][0]['nameactivity'];
      } catch (e) {
        titleActivity = 'คุณยังไม่มีกิจกรรมวันนี้';
        texttitle = true;
      }
      statusActivity = restListActivity;
      print(titleActivity);
      print('111111111111111111111111111111111111');
      print(listHistory);
      print('11111111bbbbbbbbbbbbbbb1111111111111');
      print(dateStart);
      print(formattedDate);
    });
  }

  /*void getGraphUser() async {
    Api restContent = await new Api();
    var pref = await SharedPreferences.getInstance();
    var restId = await pref.getString("token");
    restList_ = await restContent.get_data_graph(restId);
    setState(() {
      for (var i in restList_['datauser']) {
        indexAppendGraph.add(i);
      }
      print(indexAppendGraph);
      print('-------------------------');
      print(restList_['datauser'].length);
      print('11111111bbbbbbbbbbbbbbb111111111');
      for (int i = 0; i < restList_['datauser'].length - 1; i++) {
        listChartData.add(DataList(
            date: indexAppendGraph[i]['date'].toString().substring(0, 5),
            sugar: double.parse(
                indexAppendGraph[i]['sumdate_sugar'].toStringAsFixed(2))));
        //DataList(date: indexAppend[i]['date'], sugar: indexAppend[i]['sumdate_sugar'].toStringAsFixed(2)),
      }
      print(listChartData.length);
      print('111111111111111111111111111111111111');
    });
  }*/
  late Color colorBar;
  List<BarChartGroupData> _chartGroups() {
    List<BarChartGroupData> list =
        List<BarChartGroupData>.empty(growable: true);
    for (int i = 0; i < listChartData.length - 5; i++) {
      if (listChartData[i].sugar <= 8) {
        colorBar = Colours.darkSeagreen.shade700;
      } else {
        colorBar = Colours.lightCoral;
      }
      list.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: listChartData[i].sugar,
              color: colorBar,
              width: 25,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10), topLeft: Radius.circular(10)),
              backDrawRodData: BackgroundBarChartRodData(
                show: true,
                toY: 30,
                color: Colors.white54,
              ),
            ),
          ],
        ),
      );
      print(listChartData[i].sugar);
    }
    return list;
  }

 /* SideTitles get _bottomTitles => SideTitles(
      showTitles: true,
      getTitlesWidget: (value, meta) {
        String text = '';
        switch (value.toInt()) {
          case 0:
            text = 'จ.';
            break;
          case 1:
            text = 'อ.';
            break;
          case 2:
            text = 'พ.';
            break;
          case 3:
            text = 'พฤ.';
            break;
          case 4:
            text = 'ศ.';
            break;
          case 5:
            text = 'ส.';
            break;
          case 6:
            text = 'อ.';
            break;
          default:
            throw Error();
        }
        return Text(
          text,
          style: TextStyle(fontSize: 15),
        );
      });*/
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
        var restId = await pref.getString("token");
        showDate = false;
        restListActivity =
            await restContent.get_history(restId, formatStart, formatEnd);
        setState(() {
          indexAppend = [];
          for (var i in restListActivity['data_history']) {
            for (var j in i) {
              indexAppend.add(j);
            }
          }
          listHistory = indexAppend;
          print(indexAppend);
          print(indexAppend.length);
          print('---------------------------');
          for (var i = 0; i < listHistory.length; i++) {
            titleActivity = listHistory[i]['nameactivity'];
          }
          print(titleActivity);

          print('222222data_history2222222');
          listHistory = indexAppend;
          print(listHistory.length);
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
        child: loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                        selectDateButton,
                      ],
                    ),
                  ),
                  texttitle? Center(child: Text(titleActivity),):
                  Flexible(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12, left: 12),
                        child: Column(
                          children: [
                            /*Padding(
                              padding: const EdgeInsets.fromLTRB(12, 30, 12, 8),
                              child: Container(
                                color:
                                    Colours.lightGoldenRodYellow.withOpacity(0.8),
                                height: 200,
                                child: BarChart(
                                  BarChartData(
                                    maxY: 30,
                                    minY: 0,
                                    backgroundColor: Colours.beige,
                                    barGroups: _chartGroups(),
                                    borderData: FlBorderData(show: false),
                                    gridData: FlGridData(
                                      show: false,
                                    ),
                                    titlesData: FlTitlesData(
                                      bottomTitles:
                                          AxisTitles(sideTitles: _bottomTitles),
                                      leftTitles: AxisTitles(
                                          sideTitles: SideTitles(
                                        showTitles: false,
                                      )),
                                      topTitles: AxisTitles(
                                          sideTitles:
                                              SideTitles(showTitles: false)),
                                      rightTitles: AxisTitles(
                                          sideTitles:
                                              SideTitles(showTitles: false)),
                                    ),
                                  ),
                                ),
                              ),
                            ),*/
                            //Divider(),
                            ListView.builder(
                              physics: ScrollPhysics(parent: null),
                              shrinkWrap: true,
                              itemCount: listHistory.length,
                              itemBuilder: (context, index) {
                                print(
                                    '//////////////////////////////////////////////');
                                if (listHistory[index]['activity'] == 'food') {
                                  iconActivity = LineAwesomeIcons.hamburger;
                                  colorActivity = Colours.darkSeagreen;
                                  colorText = Colors.black;
                                  titleText = listHistory[index]['nameactivity'];
                                  subText = 'มื้อที่กิน : ' +
                                      listHistory[index]['meal'] +
                                      " จำนวน : " +
                                      listHistory[index]['amount'] +
                                      '\nวันที่ ' +
                                      (listHistory[index]['datetime'])
                                          .substring(0, 11) +
                                      ' เวลา ' +
                                      (listHistory[index]['datetime']).substring(
                                          11,
                                          listHistory[index]['datetime'].length) +
                                      ' น.';
                                  print(
                                      '//////////////////////////////////////////////');
                                } else {
                                  iconActivity = LineAwesomeIcons.biking;
                                  colorActivity = Colours.steelBlue;
                                  colorText = Colors.white;
                                  print(
                                      '//////////////////////////////////////////////');
                                  titleText = listHistory[index]['nameactivity'];
                                  subText = 'ระยะเวลา : ' +
                                      listHistory[index]['timestamp'] +
                                      '\nวันที่ ' +
                                      (listHistory[index]['datetime'])
                                          .substring(0, 11) +
                                      ' เวลา ' +
                                      (listHistory[index]['datetime']).substring(
                                          11,
                                          listHistory[index]['datetime'].length) +
                                      ' น.';
                                  print(
                                      '//////////////////////////////////////////////');
                                }
                                return Container(
                                  margin: EdgeInsets.only(bottom: 8),
                                  padding: EdgeInsets.only(
                                    left: 10,
                                    right: 10,
                                  ),
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
                                      listHistory[index]['sugar']
                                          .toStringAsFixed(2),
                                      style: TextStyle(
                                          fontSize: 18, color: colorText),
                                    ),
                                    title: Text(
                                      titleText,
                                      style: GoogleFonts.notoSerifThai(
                                        textStyle: TextStyle(
                                          color: colorText,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                    subtitle: Text(
                                      subText,
                                      style: GoogleFonts.notoSerifThai(
                                        textStyle: TextStyle(
                                          color: colorText,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 18,
                                        ),
                                      ),
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

class DataList {
  final date;
  final double sugar;

  //final Color colorChart;

  DataList({
    this.date,
    //required this.colorChart,
    required this.sugar,
  });
}
