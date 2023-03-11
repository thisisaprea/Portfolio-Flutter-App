import 'package:colours/colours.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_final/services/Api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class FriendTextFields extends StatefulWidget {
  const FriendTextFields({Key? key}) : super(key: key);

  @override
  _FriendTextFieldsState createState() => _FriendTextFieldsState();
}

class _FriendTextFieldsState extends State<FriendTextFields> {
  List<DataList> getSection() {
    final List<DataList> chartdata = [
      DataList(
          name: 'Day1',
          percent: 12,
          percent2: 8,
          percent3: 25,
          colorChart: Colours.aliceBlue),
      DataList(
          name: 'Day2',
          percent: 15,
          percent2: -12,
          percent3: 12,
          colorChart: Colours.orange),
      DataList(
          name: 'Day3',
          percent: 24,
          percent2: 12,
          percent3: -36,
          colorChart: Colours.aqua),
      DataList(
          name: 'Day4',
          percent: 30,
          percent2: 8,
          percent3: 0,
          colorChart: Colours.navy),
      DataList(
          name: 'Day5',
          percent: 8,
          percent2: 36,
          percent3: 15,
          colorChart: Colours.orangeRed),
      /*DataList(name: 'Black', percent: 85, colorChart: Colours.black),
      DataList(name: 'Green', percent: 30, colorChart: Colours.limeGreen),
      DataList(name: 'Green', percent: 30, colorChart: Colours.limeGreen),
      DataList(name: 'Green', percent: 30, colorChart: Colours.limeGreen),*/
    ];
    return chartdata;
  }

  TooltipBehavior? _tooltipBehavior;
  TooltipBehavior? _tooltipBehavior1;
  late List<DataList> _chartData;
  String? formatStart;
  String? formatEnd;
  var _start;
  var nameAc;
  var sugar;
  var listHistory;
  var title = 'ประวัติกิจกรรมของวันนี้';
  var restListActivity;
  var subText, titleText, iconActivity, colorActivity, colorText;
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

  void getHistoryUser() async {
    Api restContent = await new Api();
    pref = await SharedPreferences.getInstance();
    String formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);
    var restId = await pref.getString("token");
    restListActivity =
        await restContent.get_history(restId, formattedDate, formattedDate);
    setState(() {
      print('111111111111111111111111111111111111');
      print(restListActivity['data_history'][0]);
      print('111111111111111111111111111111111111');
      listHistory = restListActivity['data_history'][0];
      print(listHistory);
      print('111111111111111111111111111111111111');
      print(dateStart);
      print(formattedDate);
    });
  }

  @override
  void initState() {
    _chartData = getSection();
    _tooltipBehavior = TooltipBehavior(enable: true);
    _tooltipBehavior1 = TooltipBehavior(enable: true);
    setDateStart();
    getHistoryUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              SfCircularChart(
                title: ChartTitle(text: 'Sugar Static'),
                tooltipBehavior: _tooltipBehavior1,
                legend: Legend(
                    isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
                series: <CircularSeries>[
                  DoughnutSeries<DataList, String>(
                    dataSource: _chartData,
                    xValueMapper: (DataList data, _) => data.name,
                    yValueMapper: (DataList data, _) => data.percent,
                    dataLabelSettings: DataLabelSettings(isVisible: true),
                    enableTooltip: true,
                  ),
                ],
              ),
              SizedBox(
                height: 24,
              ),
              Center(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      child: SfSparkLineChart(
                        axisLineWidth: 0,
                        data: [13, 8, 2, -15, -5, 8, 15, 35, 20],
                      ),
                    ),
                    SfCartesianChart(
                      legend: Legend(isVisible: true),
                      tooltipBehavior: _tooltipBehavior,
                      series: <ChartSeries>[
                        StackedLineSeries<DataList, String>(
                          dataSource: _chartData,
                          xValueMapper: (DataList data, _) => data.name,
                          yValueMapper: (DataList data, _) => data.percent,
                          markerSettings: MarkerSettings(isVisible: true),
                          name: 'Day1',
                        ),
                        StackedLineSeries<DataList, String>(
                          dataSource: _chartData,
                          xValueMapper: (DataList data, _) => data.name,
                          yValueMapper: (DataList data, _) => data.percent2,
                          markerSettings: MarkerSettings(isVisible: true),
                          name: 'Day2',
                        ),
                        StackedLineSeries<DataList, String>(
                          dataSource: _chartData,
                          xValueMapper: (DataList data, _) => data.name,
                          yValueMapper: (DataList data, _) => data.percent3,
                          markerSettings: MarkerSettings(isVisible: true),
                          name: 'Day3',
                        ),
                      ],
                      primaryXAxis: CategoryAxis(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DataList {
  late final String name;
  late final int percent;
  late final int percent2;
  late final int percent3;
  late final Color colorChart;

  DataList({
    required this.name,
    required this.colorChart,
    required this.percent,
    required this.percent2,
    required this.percent3,
  });
}
