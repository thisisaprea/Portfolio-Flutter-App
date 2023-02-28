import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/Api.dart';
class ItemList extends StatefulWidget {
  static const routeName = '/FoodItem';


  ItemList({Key? key}) : super(key: key);

  @override
  _ItemListState createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  var pref;
  var id_user;
  var dateTime;
  var showContentbasedFood;
  var titleActivity, titleFood;
  var dateFood, dateActivity;

  void getdataUser() async {
    Api restContent = await new Api();
    pref = await SharedPreferences.getInstance();
    String formattedDate = DateFormat('ddMMyyyy').format(dateTime);
    var restId = await pref.getString("token");
    var showContentbasedFood =
        await restContent.get_contentbased(restId, formattedDate);
    setState(() {
      print(showContentbasedFood);
        titleFood = showContentbasedFood['datauser']['ชื่อเมนู'] +
            showContentbasedFood['datauser']['น้ำตาล'];
        this.showContentbasedFood = showContentbasedFood;
    });
  }

  var number = 0;

  @override
  void initState() {
    super.initState();
    for (var i in showContentbasedFood) {
      number = number + 1;
    }
    getdataUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('มื้ออาหารถัดไป'),
          backgroundColor: Colors.deepOrange.shade400),
      body: SafeArea(
        child: Column(
          children: [
            ListView.builder(
              physics: ScrollPhysics(parent: null),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(bottom: 8),
                  padding: EdgeInsets.only(top: 15, left: 10, right: 10),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent.shade100,
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: ListTile(
                    trailing: Icon(Icons.person_add_alt_1_outlined),
                    title: Text(titleFood),
                    //subtitle: Text(subText),
                    leading: Icon(Icons.add),
                  ),
                );
              },
              itemCount: number,
            ),
          ],
        ),
      ),
    );
  }
}
