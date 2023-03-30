import 'package:chart_components/bar_chart_component.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../services/Api.dart';

class Graph extends StatefulWidget {
  const Graph({Key? key}) : super(key: key);

  @override
  _GraphState createState() => _GraphState();
}

var restListActivity, listHistory, titleActivity, statusActivity;
var indexAppend = [];
var sugar = [];
List<DataList> listChartData = [];
TooltipBehavior _tooltipBehavior = TooltipBehavior(enable: true);
class _GraphState extends State<Graph> {
  void getHistorydataUser() async {
    Api restContent = await new Api();
    var pref = await SharedPreferences.getInstance();
    var restId = await pref.getString("token");
    restListActivity = await restContent.get_data_graph(restId);
    setState(() {
      for (var i in restListActivity['datauser']) {
        indexAppend.add(i);
      }
      print(indexAppend);
      print('-------------------------');
      listHistory = indexAppend;
      print(restListActivity['datauser'].length);
      print('11111111bbbbbbbbbbbbbbb1111111111111');
      for (int i = 0; i < restListActivity['datauser'].length - 1; i++) {
        listChartData.add(DataList(
            date: indexAppend[i]['date'].toString().substring(0,5),
            sugar: double.parse(indexAppend[i]['sumdate_sugar'].toStringAsFixed(2))));
        //DataList(date: indexAppend[i]['date'], sugar: indexAppend[i]['sumdate_sugar'].toStringAsFixed(2)),
      }
      print('111111111111111111111111111111111111');
    });
  }


 /* void loadChartData() {
    for (int i = 0; i < restListActivity['datauser'].length - 1; i++) {
      listChartData.add(DataList(
          date: indexAppend[i]['date'],
          sugar: indexAppend[i]['sumdate_sugar'].toStringAsFixed(2)));
      //DataList(date: indexAppend[i]['date'], sugar: indexAppend[i]['sumdate_sugar'].toStringAsFixed(2)),
    }
  }*/

  var index = 0;

  @override
  void initState() {
    super.initState();
    listChartData = [];
    getHistorydataUser();
    //loadChartData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
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
    required this.date,
    //required this.colorChart,
    required this.sugar,
  });
}
