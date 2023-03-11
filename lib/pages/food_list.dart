import 'package:animated_button_bar/animated_button_bar.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:colours/colours.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/Api.dart';
import 'onBoading.dart';

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
  var titleText, titleFood, subText, colorBox;
  var dateFood, dateActivity, meal = 'เช้า';
  var mealController = TextEditingController();
  var statusChoose;
  bool loading = false, loadingContent = false, loadingColl = false;
  var number = 0;
  var iconActivity;
  var colorActivity;
  final List<String> categoryItems = ['เช้า', 'เที่ยง', 'เย็น'];

  Future getdataUser() async {
    Api restContent = await new Api();
    pref = await SharedPreferences.getInstance();
    String formattedDate = DateFormat('ddMMyyyy').format(dateTime);
    var restId = await pref.getString("token");
    var showContentbasedFood =
        await restContent.get_contentbased(restId, formattedDate, meal);
    loading = false;
    setState(() {
      print('111111111111111111111111111111111111');
      print(showContentbasedFood);
      print('111111111111111111111111111111111111');
      titleFood = showContentbasedFood['datauser'];
      print(titleFood);
      print('111111111111111111111111111111111111');
    });
  }

  void _onLoaing() {
    setState(() {
      loading = true;
      new Future.delayed(new Duration(seconds: 2), getdataUser);
    });
  }

  @override
  void initState() {
    super.initState();
    _onLoaing();
    getdataUser();
  }

  @override
  Widget build(BuildContext context) {
    final _buttonbarPage = AnimatedButtonBar(
      radius: 32.0,
      padding: const EdgeInsets.all(12.0),
      backgroundColor: Colours.burntSienna,
      foregroundColor: Colors.white54,
      elevation: 24,
      borderColor: Colors.white,
      borderWidth: 2,
      innerVerticalPadding: 16,
      children: [
        ButtonBarEntry(
          onTap: () async {
            statusChoose = 'contentbased';
            pref = await SharedPreferences.getInstance();
            String formattedDate = DateFormat('ddMMyyyy').format(dateTime);
            var restId = await pref.getString("token");
            Api restContentbased = await new Api();
            showContentbasedFood = await restContentbased.get_contentbased(
                restId, formattedDate, meal);

            setState(() {
              loading = false;
              titleFood.clear();
              titleFood = showContentbasedFood['datauser'];
              print('2222222222222222222222222222222222');
              print(titleFood);
            });
          },
          child: Text(
            'Content-based',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
        ),
        ButtonBarEntry(
            onTap: () async {
              statusChoose = 'collaboretive';
              pref = await SharedPreferences.getInstance();
              String formattedDate = DateFormat('ddMMyyyy').format(dateTime);
              var restId = await pref.getString("token");
              Api restContentbased = await new Api();
              showContentbasedFood = await restContentbased.get_collaboretive(
                  restId, formattedDate, meal);

              setState(() {
                loading = false;
                titleFood.clear();
                titleFood = showContentbasedFood['datauser'];
                print('3333333333333333333333333333333333333');
                print(titleFood);
              });
            },
            child: Text(
              'Collaboretive',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            )),
      ],
    );
    return Scaffold(
      backgroundColor: Colours.lightGoldenRodYellow.withOpacity(0.8),
      appBar: AppBar(
          title: Text('แนะนำอาหาร'), backgroundColor: Colours.burntSienna),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showDialog(
          context: context,
          builder: (context) => alertMeal(context),
        ),
        label: const Text('เลือกมื้ออาหาร'),
        icon: const Icon(Icons.add),
        backgroundColor: Colours.burntSienna.shade700,
      ),
      body: SafeArea(
        child: loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  Container(
                    height: 90,
                    color: Colours.white24.withOpacity(0.1),
                    child: _buttonbarPage,
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8, left: 8),
                      child: ListView.builder(
                        physics: ScrollPhysics(parent: null),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          if (statusChoose == 'contentbased') {
                            colorBox = Colours.darkGreen.withOpacity(0.6);
                          } else if (statusChoose == 'collaboretive') {
                            colorBox = Colours.cadetBlue;
                          } else {
                            colorBox = Colours.darkGreen.withOpacity(0.6);
                          }
                          return Container(
                            margin: EdgeInsets.only(bottom: 8),
                            padding: EdgeInsets.only(
                                top: 10, left: 10, right: 10, bottom: 10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black, //color of border
                                width: 2, //width of border
                              ),
                              color: colorBox,
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                            child: ListTile(
                              trailing: Text(
                                titleFood[index]['น้ำตาล'].toStringAsFixed(2),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 18,
                                ),
                              ),
                              title: Text(
                                titleFood[index]['ชื่อเมนู'],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 18,
                                ),
                              ),
                              //subtitle: Text(subText),
                              leading: Icon(
                                Icons.fastfood,
                                color: Colors.white,
                              ),
                            ),
                          );
                        },
                        itemCount: titleFood.length,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget MealButton() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const Text('มื้ออาหาร',
              style: TextStyle(fontWeight: FontWeight.bold)),
          DropdownButtonFormField(
            validator: (value) => value == null ? "กรุณาเลือกมื้อ" : null,
            onChanged: (String? newValue) {
              setState(() {
                mealController.text = newValue!;
              });
            },
            items: categoryItems.map<DropdownMenuItem<String>>(
              (String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              },
            ).toList(),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20, 5, 5, 10),
              hintText: "มื้ออาหาร",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              //textInputAction: TextInputAction.next,
            ),
          ),
        ]);
  }

  Widget AddButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        DateTime dateTime = DateTime.now();
        var meal = mealController.text;
        if (statusChoose == 'contentbased') {
          statusChoose = 'contentbased';
          pref = await SharedPreferences.getInstance();
          String formattedDate = DateFormat('ddMMyyyy').format(dateTime);
          var restId = await pref.getString("token");
          Api restContentbased = await new Api();
          showContentbasedFood = await restContentbased.get_contentbased(
              restId, formattedDate, meal);
          setState(() {
            titleFood.clear();
            titleFood = showContentbasedFood['datauser'];
            print('contentbasedcontentbasedcontentbasedcontentbased');
            print('มื้อ $meal');
            print(titleFood);
          });
        } else {
          statusChoose = 'collaboretive';
          pref = await SharedPreferences.getInstance();
          String formattedDate = DateFormat('ddMMyyyy').format(dateTime);
          var restId = await pref.getString("token");
          Api restContentbased = await new Api();
          showContentbasedFood = await restContentbased.get_collaboretive(
              restId, formattedDate, meal);
          setState(() {
            titleFood.clear();
            titleFood = showContentbasedFood['datauser'];
            print('collaboretivecollaboretivecollaboretivecollaboretive');
            print(titleFood);
          });
        }
        CircularProgressIndicator();
        Navigator.of(context).pop();
      },
      child: Text('Add'),
      style: ElevatedButton.styleFrom(
          primary: Colors.green,
          textStyle: TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  Widget CancelButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: Text('Cancel'),
      style: ElevatedButton.styleFrom(
          primary: Colors.black.withOpacity(0.8),
          textStyle: TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  Widget alertMeal(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Text(
        'มื้ออาหาร',
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
      buttonPadding: const EdgeInsets.only(right: 24),
      elevation: 24.0,
      content: Form(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            MealButton(),
          ],
        ),
      ),
      actions: <Widget>[
        CancelButton(context),
        AddButton(context),
      ],
    );
  }
}
