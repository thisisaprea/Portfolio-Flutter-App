import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:project_final/pages/history_daily.dart';

class report_static extends StatefulWidget {
  static const routeName = '/History';
  var restListActivity;
  var title;
  report_static({required this.restListActivity,required this.title});
  //const report_static({Key? key}) : super(key: key);

  @override
  _report_staticState createState() => _report_staticState(restListActivity: this.restListActivity, title: this.title);
}

class _report_staticState extends State<report_static> {
  var restListActivity;
  var title;
  _report_staticState({required this.restListActivity,required this.title});
  var subText, titleText;
  @override
  void initState() {
    super.initState();
    for(var i in restListActivity){
      number = number + 1;
    }

  }

  int number = 0;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent.shade200,
        title: Text("ประวัติ"+ title.toString()),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                /*OutlinedButton(
                  onPressed: () {
                    setState(() {
                      number = number + 1;
                    });
                  },
                  child: Text('add'),
                ),*/
                ListView.builder(
                  physics: ScrollPhysics(parent: null),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    if(title == 'การกิน'){
                      titleText = restListActivity[index]['nameactivity'];
                      subText = 'มื้อที่กิน : '+restListActivity[index]['meal'] + " จำนวน : "
                          +restListActivity[index]['amount']+' น้ำตาล : '+restListActivity[index]['sugar'].toStringAsFixed(2)+'\nวันที่ '+(restListActivity[index]['datetime']).substring(0,11)
                      +' เวลา '+ (restListActivity[index]['datetime']).substring(11,restListActivity[index]['datetime'].length)+' น.';
                    }else{
                      titleText = restListActivity[index]['nameactivity'];
                      subText = 'ระยะเวลาออกกำลังกาย : '+restListActivity[index]['timestamp'] +' น้ำตาล : '+restListActivity[index]['sugar'].toStringAsFixed(2)+'\nวันที่ '+(restListActivity[index]['datetime']).substring(0,11)
                          +' เวลา '+ (restListActivity[index]['datetime']).substring(11,restListActivity[index]['datetime'].length)+' น.';
                    }
                    return Container(
                      margin: EdgeInsets.only(bottom: 8),
                      padding:EdgeInsets.only(top: 15, left: 10, right: 10),
                      decoration:BoxDecoration(
                        color: Colors.blueAccent.shade100,
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),

                      child: ListTile(

                        trailing: Icon(Icons.person_add_alt_1_outlined),
                        title: Text(titleText),
                        subtitle: Text(subText),
                        leading: Icon(Icons.add),
                      ),

                    );

                  },
                  itemCount: number,

                ),
            SizedBox(height: 10,),
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
      ),
    );
  }
}
