import 'package:colours/colours.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../services/Api.dart';

class Graph extends StatefulWidget {
  const Graph({Key? key}) : super(key: key);

  @override
  _GraphState createState() => _GraphState();
}
class _GraphState extends State<Graph> {
  var restList_, titleActivity, statusActivity;
  var indexAppendGraph = [];
  var sugar = [];
  List<DataList> listChartData = [];
  TooltipBehavior _tooltipBehavior = TooltipBehavior(enable: true);
  void getGraphUser() async {
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
      print('11111111bbbbbbbbbbbbbbb1111111111111');
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
  }
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

  SideTitles get _bottomTitles => SideTitles(
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
      });

  /*BarTouchData get barTouchData => BarTouchData(
        enabled: true,
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.transparent,
          tooltipPadding: EdgeInsets.zero,
          tooltipMargin: 0,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            return BarTooltipItem(
              rod.toY.round().toString(),
              const TextStyle(
                color: Colours.black,
                fontWeight: FontWeight.bold,
                fontSize: 10
              ),
            );
          },
        ),
      );*/
  @override
  void initState() {
    super.initState();
    listChartData = [];
    getGraphUser();
    //loadChartData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colours.lightGoldenRodYellow.withOpacity(0.8),
      body: SafeArea(
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 65,
                ),
                /*Container(
                  padding: EdgeInsets.all(8),
                  child: SfCartesianChart(
                    //legend: Legend(isVisible: true),
                    tooltipBehavior: _tooltipBehavior,
                    primaryXAxis: CategoryAxis(),
                    series: <ChartSeries>[
                      BarSeries(
                        dataSource: listChartData,
                        xValueMapper: (data, _) => data.date,
                        yValueMapper: (data, _) => data.sugar,
                        markerSettings: MarkerSettings(isVisible: true),
                      ),
                    ],
                  ),
                ),*/
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Container(
                    color: Colours.lightGoldenRodYellow.withOpacity(0.8),
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
                          bottomTitles: AxisTitles(sideTitles: _bottomTitles),
                          leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                            showTitles: false,
                          )),
                          topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                        ),
                      ),
                    ),
                  ),
                ),
                Divider(),
              ],
            ),
          ),
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
