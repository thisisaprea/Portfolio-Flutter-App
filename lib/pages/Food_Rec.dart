
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:dropdown_search/dropdown_search.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class food_list extends StatefulWidget {
  static const routeName = '/Food_list';

  const food_list({Key? key}) : super(key: key);

  @override
  _food_listState createState() => _food_listState();
}

class _food_listState extends State<food_list> {
  @override
  final List<String> items = [
    'A_Item1',
    'A_Item2',
    'A_Item3',
    'A_Item4',
    'B_Item1',
    'B_Item2',
    'B_Item3',
    'B_Item4',
  ];

  //String? selectedValue;
  var jobs;
  var selectedjobs;
  final TextEditingController textEditingController = TextEditingController();

  void initState() {
    super.initState();
    //retrieveData();
  }

  /*void retrieveData() {
    FirebaseFirestore.instance.collection('Occu').get().then((value) => {
          value.docs.forEach((info) {
            print(info.data()['List_Occu']);
            if (info.exists) {
              setState(() {
                jobs = info.data()["List_Occu"];
              });
            }
          }),
        });
  }*/

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange.shade400,
        title: Text('มื้ออาหาร'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              /*StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Occu')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<DropdownMenuItem> jobItems = [];
                      for (int i = 0; i < snapshot.data!.docs.length; i++) {
                        DocumentSnapshot snap = snapshot.data!.docs[i];
                        jobItems.add(
                          DropdownMenuItem(
                            child: Text(
                              snap['List_Occu'],
                            ),
                            value: '${snap['List_Occu']}',
                          ),
                        );
                      }
                      return Row(
                        children: [
                          SizedBox(width: 50.0),
                          DropdownButton(
                            items: jobItems,
                            onChanged: (jobValue) {
                              setState(() {
                                selectedjobs = jobValue;
                              });
                            },
                            value: selectedjobs,
                            isExpanded: false,
                            hint: new Text(
                              "Choose Currency Type",
                              style: TextStyle(color: Color(0xff11b719)),
                            ),
                          ),
                        ],
                      );
                    }
                    return CircularProgressIndicator();
                  }),*/
            ],
          ),
        ),
      ),
    );
  }
}
