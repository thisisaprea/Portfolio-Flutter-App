import 'package:animated_button_bar/animated_button_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/Api.dart';

class ItemList extends StatefulWidget {
  static const routeName = '/FoodItem';

  /*var restListFood;
  ItemList({required this.restListFood});*/

  ItemList({Key? key}) : super(key: key);

  @override
  _ItemListState createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  /*var restListFood;
  _ItemListState({required this.restListFood});*/
  var pref;
  var id_user;
  DateTime dateTime = DateTime.now();
  var showContentbasedFood;
  var titleActivity, titleFood;
  var dateFood, dateActivity, meal = 'เช้า';
  var statusChoose = 'contentbased';
  List<String> lables = ['Content-based', 'Collaboretive'];

  void getdataUser() async {
    Api restContent = await new Api();
    pref = await SharedPreferences.getInstance();
    String formattedDate = DateFormat('ddMMyyyy').format(dateTime);
    var restId = await pref.getString("token");
    var showContentbasedFood = await restContent.get_contentbased(restId, formattedDate, meal);
    setState(() {
      print('111111111111111111111111111111111111');
      print(showContentbasedFood);
      print('111111111111111111111111111111111111');
      titleFood = showContentbasedFood['datauser'];
      print(titleFood);
      print('111111111111111111111111111111111111');
    });
  }

  var number = 0;

  @override
  void initState() {
    super.initState();
    /*for (var i in showContentbasedFood) {
      number = number + 1;*/
    //}
    getdataUser();
  }

  @override
  Widget build(BuildContext context) {
    final buttonbarPage = AnimatedButtonBar(
      radius: 32.0,
      padding: const EdgeInsets.all(16.0),
      backgroundColor: Colors.deepOrange.shade400,
      foregroundColor: Colors.white54,
      elevation: 24,
      borderColor: Colors.white,
      borderWidth: 2,
      innerVerticalPadding: 16,
      children: [
        ButtonBarEntry(

            onTap: () async{
              /*if(statusChoose == 'contentbased'){
                statusChoose = 'contentbased';
                pref = await SharedPreferences.getInstance();
                String formattedDate = DateFormat('ddMMyyyy').format(dateTime);
                var restId = await pref.getString("token");
                Api restContentbased = await new Api();
                showContentbasedFood =
                await restContentbased.get_contentbased(restId, formattedDate,meal);
              }
              else{

              }*/ //onTap add meal;
              statusChoose = 'contentbased';
              pref = await SharedPreferences.getInstance();
              String formattedDate = DateFormat('ddMMyyyy').format(dateTime);
              var restId = await pref.getString("token");
              Api restContentbased = await new Api();
              showContentbasedFood =
              await restContentbased.get_contentbased(restId, formattedDate,meal);
              setState(() {
                titleFood.clear();
                titleFood = showContentbasedFood['datauser'];
                print('2222222222222222222222222222222222');
                print(titleFood);
              });
            },
            child: Text('Content-based')),
        ButtonBarEntry(
            onTap: () async{
              statusChoose = 'collaboretive';
              pref = await SharedPreferences.getInstance();
              String formattedDate = DateFormat('ddMMyyyy').format(dateTime);
              var restId = await pref.getString("token");
              Api restContentbased = await new Api();
              showContentbasedFood =
              await restContentbased.get_contentbased(restId, formattedDate,meal);
              setState(() {
                titleFood.clear();
                titleFood = showContentbasedFood['datauser'];
                print('2222222222222222222222222222222222');
                print(titleFood);
              });

            },
            child: Text('Collaboretive')),
      ],
    );
    return Scaffold(
      appBar: AppBar(
          title: Text('มื้ออาหารถัดไป'),
          backgroundColor: Colors.deepOrange.shade400),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              buttonbarPage,
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
                      title: Text(titleFood[index]['ชื่อเมนู']),
                      //subtitle: Text(subText),
                      leading: Icon(Icons.add),
                    ),
                  );
                },

                itemCount: titleFood.length,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
