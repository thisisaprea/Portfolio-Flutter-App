import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:colours/colours.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:project_final/pages/SpeechToText.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/Api.dart';
import '../services/last_time.dart';
import 'bottom_page.dart';

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
  final TextEditingController textEditingController = TextEditingController();
  final TextEditingController sugarEditingController = TextEditingController();
  final TextEditingController timeEditingController = TextEditingController();
  TimeOfDay time = TimeOfDay(hour: 10, minute: 30);
  final List<String> categoryItems = [
    'เช้า',
    'เที่ยง',
    'เย็น',
  ];
  var id_user;
  bool loading = true;

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


  Future getdataFood() async {
    Api restActivity = new Api();
    var restfood = await restActivity.get_food();
    loading = false;
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
    return SingleChildScrollView(
      child: AlertDialog(
        backgroundColor: Colours.beige,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        buttonPadding: const EdgeInsets.only(right: 24),
        elevation: 24.0,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colours.snow,
              ),
              child: Column(
                children: [
                  mealDropdown(),
                  SizedBox(height: 10),
                  foodField(),
                  SizedBox(height: 10),
                  mealField(),
                ],
              ),
            ),
            Divider(height: 24,color: Colours.white),
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colours.snow,
              ),
              child: Column(
                children: [
                  sugarField(),
                ],
              ),
            ),

          ],
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Row(
              children: [
                Container(
                    width: 95,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colours.darkGreen.shade400,
                    ),
                    child: micButton(context)),
                SizedBox(
                  width: 24,
                ),
                cancelButton(context),
                SizedBox(
                  width: 10,
                ),
                addButton(context, isEditing: isEditing),
              ],
            ),
          ),

        ],
      ),
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
                borderSide: BorderSide(color: Colors.black, width: 2),
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
        loading? Center(child: CircularProgressIndicator(),)
            :DropdownButtonFormField2(
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
          searchInnerWidgetHeight: 50,
          searchInnerWidget: Padding(
            padding: EdgeInsets.only(
              top: 8,
              bottom: 4,
              right: 8,
              left: 8,
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
                  borderSide: BorderSide(color: Colors.deepPurple),
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
              borderSide: BorderSide(color: Colors.black, width: 2),
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
              borderSide: BorderSide(color: Colors.black, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }

  Widget micButton(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.mic, color: Colors.white,),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => SpeechToText(),
        );
      },
    );
  }
  Widget _TimePicker(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('ใส่เวลาย้อนหลัง(ถ้ามี)', style: TextStyle(fontWeight: FontWeight.bold)),
        TextFormField(
          autofocus: false,
          controller: timeEditingController,
          validator: (value) {
            if (value!.isEmpty) {
              return ("");
            }
            return null;
          },
          onSaved: (value) {
            timeEditingController.text = value!;
          },
          decoration: InputDecoration(
            labelText: 'ใส่เวลาย้อนหลัง',
            prefixIcon: Icon(LineAwesomeIcons.clock),
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "เวลาย้อนหลัง",
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          readOnly: true,
          onTap: () async {
            TimeOfDay? pickedTime = await showTimePicker(
              context: context,
              initialTime: time,
            );
            if (pickedTime != null) {
              print(pickedTime);
              String timeTrim = pickedTime.toString().substring(10,15);
              print(timeTrim);
              String date = DateFormat('dd/MM/yyyy').format(dateLast);
              String formattedDate = DateFormat('ddMMyyyy').format(dateLast);
              String dateAndtime = date + " " +timeTrim+':00';
              print(date);
              print(formattedDate);
              print(dateAndtime);
              setState(() {
                timeEditingController.text = timeTrim; //set output date to TextField value.
              });
            } else {}
          },
        ),
      ],
    );
  }
  Widget sugarField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('ใส่ค่าน้ำตาลที่ปรุง(ถ้ามี)', style: TextStyle(fontWeight: FontWeight.bold)),
        TextFormField(
          autofocus: false,
          controller: sugarEditingController,
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value!.isEmpty) {
              return ("");
            }
            return null;
          },
          onSaved: (value) {
            sugarEditingController.text = value!;
          },
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            prefixIcon: Icon(LineAwesomeIcons.utensil_spoon),
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "ค่าน้ำตาลที่ปรุง(ช้อนชา)",
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }

  Widget cancelButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: Text('ยกเลิก'),
      style: ElevatedButton.styleFrom(
          primary: Colors.black.withOpacity(0.8),
          textStyle: TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  Widget addButton(BuildContext context, {required bool isEditing}) {
    final text = 'ตกลง';
    return ElevatedButton(
      child: Text(text),
      onPressed: () async {
        final food = foodController.text;
        final mealtime = mealAmountController.text;
        String formattedDateTime =
            DateFormat('dd/MM/yyyy H:m:s').format(dateLast);
        String formattedDate = DateFormat('ddMMyyyy').format(dateLast);
        print('food name $food');
        print('cateogry $mealController.text');
        print('meal amount $mealtime');
        print(mealAmountController.text);
        print('Datetime $formattedDateTime');
        print('Datetime $formattedDate');
        if (food != '' && mealController != '' && mealtime != '') {
          Api setDataToApi = await new Api();
          var setData = await setDataToApi.add_foodinput(id_user, formattedDate,
              formattedDateTime, food, mealtime, mealController.text);
          if (await setData["message"] == 'success') {
            print("------------------------------------------");
            ///////push to next page///
            MaterialPageRoute materialPageRoute = MaterialPageRoute(
                builder: (BuildContext context) => Bottom_Pages());
            Navigator.of(this.context).push(materialPageRoute);
          }
        } else {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.warning,
            animType: AnimType.topSlide,
            showCloseIcon: true,
            headerAnimationLoop: false,
            title: 'Warning',
            desc: 'กรุณากรอกชื่ออาหาร หรือมื้ออาหาร และจำนวนอาหาร',
            btnOkOnPress: () {},
          ).show();
        }
        ;
      },
      style: ElevatedButton.styleFrom(
          primary: Colours.darkGreen,
          textStyle: TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}
