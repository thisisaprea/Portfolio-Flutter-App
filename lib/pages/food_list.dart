import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:multiple_search_selection/multiple_search_selection.dart';
import 'package:project_final/pages/Food_Rec.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/Api.dart';
import '../services/last_time.dart';
import 'FriendTextFields.dart';
import 'history_second.dart';

class ItemList extends StatefulWidget {
  static const routeName = '/FoodItem';

  const ItemList({Key? key}) : super(key: key);

  @override
  _ItemListState createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  var pref;
  var id_user;
  void getdataUser() async {
    pref = await SharedPreferences.getInstance();
    var restId = await pref.getString("token");

    setState(() {
      id_user = restId;

    });
  }

  @override
  void initState() {
    super.initState();
    getdataUser();
  }

  @override
  Future addLastTime(String food, String category) async {
    final lastTime = LastTime()
      ..food = food
      ..category = category
      ..createdDate = DateTime.now()
      ..timeStamp.add(DateTime.now());

    final box = Hive.box<LastTime>('lastTimes');
    box.add(lastTime);
    print('$box, $lastTime');
  }

  Widget build(BuildContext context) {
    /*final listview_field = StreamBuilder(stream: FirebaseFirestore.instance
        .collection('food_info')
        .snapshots(),
        builder: (context, snapshot) {
          if(!snapshot.hasData){
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Container(
            child: ListView(
                children: snapshot.data!.docs.map((snap){
                  return Card(
                    child: ListTile(
                      title: Text(snap.data()['Menu']),

                    ),
                  );
                }).toList()
            ),
          );
        });
*/
    return Scaffold(
      /*floatingActionButton: SizedBox(
        width: 75,
        height: 75,
        child: FittedBox(
          child: FloatingActionButton(
            backgroundColor: Colors.green.shade400,
            onPressed: () => showDialog(
              context: context,
              builder: (context) => history_second(onFinish: addLastTime),
            ),
            child: Icon(Icons.add),
          ),
        ),
      ),*/
      appBar: AppBar(
          title: Text('มื้ออาหารถัดไป'),
          backgroundColor: Colors.deepOrange.shade400),
      body: SafeArea(
        child: Column(
          children: [

          ],
        ),
      ),
    );
  }
  /*List<Widget> _getFriends(){
    List<Widget> friendsTextFields = [];
    for(int i=0; i<friendsList.length; i++){
      friendsTextFields.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              children: [
                Expanded(child: FriendTextFields(i)),
                SizedBox(width: 16,),
                // we need add button at last friends row
                _addRemoveButton(i == friendsList.length-1, i),
              ],
            ),
          )
      );
    }
    return friendsTextFields;
  }

  /// add / remove button
  Widget _addRemoveButton(bool add, int index){
    return InkWell(
      onTap: (){
        if(add){
          // add new text-fields at the top of all friends textfields
          friendsList.insert(0, "");
        }
        else friendsList.removeAt(index);
        setState((){});
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: (add) ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon((add) ? Icons.add : Icons.remove, color: Colors.white,),
      ),
    );
  }*/
}

