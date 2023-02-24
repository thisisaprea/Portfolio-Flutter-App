import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:project_final/pages/history_daily.dart';

class report_static extends StatefulWidget {
  static const routeName = '/History';

  const report_static({Key? key}) : super(key: key);

  @override
  _report_staticState createState() => _report_staticState();
}

class _report_staticState extends State<report_static> {
  int number = 1;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent.shade200,
        title: const Text("ประวัติการกิน"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                OutlinedButton(
                  onPressed: () {
                    setState(() {
                      number = number + 1;
                    });
                  },
                  child: Text('add'),
                ),
                ListView.builder(
                  physics: ScrollPhysics(parent: null),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => history_daily()));
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 8),
                        padding:EdgeInsets.only(top: 15, left: 10, right: 10),
                        decoration: BoxDecoration(
                          color: Colors.blueAccent.shade100,
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),

                        child: ListTile(
                          trailing: Icon(Icons.person_add_alt_1_outlined),
                          title: Text("histiry today"),
                          subtitle: Text('24/02/2023'),
                          leading: Icon(Icons.add),
                        ),

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
