import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:project_final/pages/food_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/Api.dart';
import '../services/last_time.dart';

class history_second extends StatefulWidget {
  static const routeName = '/history_second';
  final LastTime? lastTime;
  final Function onFinish;


  history_second({
    Key? key,
    this.lastTime,
    required this.onFinish,
  }) : super(key: key);

  @override
  _history_secondState createState() => _history_secondState();
}

class _history_secondState extends State<history_second> {
  final foodController = TextEditingController();
  var _selectedMenu;
  var mealController = TextEditingController();
  var mealAmountController = TextEditingController();
  final List<String> categoryItems = [
    'เช้า',
    'เที่ยง',
    'เย็น',
    'อื่นๆ'

  ];
  var id_user;
  void getdataUser() async {
    pref = await SharedPreferences.getInstance();
    var restId = await pref.getString("token");

    setState(() {
      id_user = restId;

    });
  }

  DateTime dateLast = DateTime.now();
  late String _selectedCategory;
  var listFood;
  late SharedPreferences pref;

  void getdataFood() async {
    Api restActivity = new Api();
    var restfood = await restActivity.get_food();
    setState(() {
      listFood = restfood;
    });
  }

  @override
  void initState() {
    super.initState();
    getdataFood();
    _selectedCategory = categoryItems.elementAt(0);
    getdataUser();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.lastTime != null;
    final title = isEditing ? 'Edit LastTime' : 'Add LastTime';
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
      buttonPadding: const EdgeInsets.only(right: 24),
      elevation: 24.0,
      content: Form(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            foodField(),
            SizedBox(height: 10),
            mealDropdown(),
            SizedBox(height: 10),
            mealField(),
          ],
        ),
      ),
      actions: <Widget>[
        micButton(context),
        SizedBox(
          width: 30,
        ),
        cancelButton(context),
        addButton(context, isEditing: isEditing),
      ],
    );
  }

  Widget mealDropdown() {
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

  Widget foodField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Food', style: TextStyle(fontWeight: FontWeight.bold)),
        DropdownButtonFormField2(
          validator: (value) => value == null ? "กรุณาเลือกเมนู" : null,
          onChanged: (menuValue) {
            setState(() {
              foodController.text = menuValue! as String;
            });
          },
          items: listFood.map<DropdownMenuItem<String>>(
            (String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            },
          ).toList(),
          buttonHeight: 40,
          buttonWidth: 300,
          itemHeight: 40,
          dropdownMaxHeight: 200,
          searchController: foodController,
          searchInnerWidget: Padding(
            padding: EdgeInsets.only(
              top: 15,
              bottom: 10,
              right: 15,
              left: 15,
            ),
            child: TextFormField(
              controller: foodController,
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                hintText: 'ค้นหาเมนู...',
                hintStyle: const TextStyle(fontSize: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          searchMatchFn: (menuItems, searchValue) {
            return (menuItems.value.toString().contains(searchValue));
          },
          onMenuStateChange: (isOpen) {
            if (!isOpen) {
              foodController.clear();
            }
          },
          value: _selectedMenu,
          isExpanded: true,
          hint: Text(
            "เลือกเมนูโปรด",
          ),
          decoration: InputDecoration(
            //prefixIcon: Icon(Icons.fastfood),
            contentPadding: EdgeInsets.fromLTRB(20, 5, 5, 10),
            hintText: "เมนู",
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.deepPurple),
              borderRadius: BorderRadius.circular(10),
            ),
            //textInputAction: TextInputAction.next,
          ),
        ),
      ],
    );
  }

  Widget mealField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('จำนวนมื้ออาหาร', style: TextStyle(fontWeight: FontWeight.bold)),
        TextFormField(
          autofocus: false,
          controller: mealAmountController,
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value!.isEmpty) {
              return ("กรุณาใส่จำนวนมื้ออาหาร");
            }
            return null;
          },
          onSaved: (value) {
            mealAmountController.text = value!;
          },
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.numbers),
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "จำนวนมื้ออาหาร",
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.deepPurple),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }

  Widget micButton(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.mic),
      onPressed: () {
        AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text(
            'พูดได้เลย',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        );
      },
    );
  }

  Widget cancelButton(BuildContext context) {
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

  Widget addButton(BuildContext context, {required bool isEditing}) {
    final text = isEditing ? 'Save' : 'Add';
    return ElevatedButton(
      child: Text(text),
      onPressed: () async {
        final food = foodController.text;
        final mealtime = mealAmountController.text;
        String formattedDateTime = DateFormat('dd/MM/yyyy H:m:s').format(dateLast);
        String formattedDate = DateFormat('ddMMyyyy').format(dateLast);
        print('food name $food');
        print('cateogry $_selectedCategory');
        print('meal amount $mealtime');
        print('Datetime $formattedDateTime');
        print('Datetime $formattedDate');
        Api setDataToApi = await new Api();
        var setData = await setDataToApi.add_foodinput(id_user, formattedDate, formattedDateTime, food, mealtime, _selectedCategory);
        if(await setData["message"] == 'success'){
          //Navigator.of(context).pop();
          //var getLastmeal = await setDataToApi.show_food(id_user, formattedDate)
          var suGar = await setDataToApi.get_sugar(id_user, formattedDate);
          print('น้ำตาล ${suGar['sugar']['sugar']}');
          var callContentbased = await setDataToApi.get_contentbased(id_user, formattedDate);
          if(await callContentbased["message"] == 'success'){
            print("------------------------------------------");
            print(callContentbased["datauser"]);

            print("------------------------------------------");
            ///////push to next page///
            MaterialPageRoute materialPageRoute = MaterialPageRoute(
                builder: (BuildContext context) => ItemList());
            Navigator.of(this.context).push(materialPageRoute);
          }
        }
        //widget.onFinish(food, _selectedCategory, mealtime);

       
      },
      style: ElevatedButton.styleFrom(
          primary: Colors.green,
          textStyle: TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}
