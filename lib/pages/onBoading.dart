

import 'package:custom_searchable_dropdown/custom_searchable_dropdown.dart';
import 'package:dropdown_button2/dropdown_button2.dart';


import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../services/Api.dart';

class onBoarding extends StatefulWidget {
  static const routeName = '/Food_list';

  const onBoarding({Key? key}) : super(key: key);

  @override
  _onBoardingState createState() => _onBoardingState();
}

class _onBoardingState extends State<onBoarding> {
  @override
  //String? selectedValue;
  var listFood;
  var _selectedMenu;
  var selected;
  bool loading = true;
  final TextEditingController textEditingController = TextEditingController();
  final TextEditingController sugarEditingController = TextEditingController();
  TimeOfDay time = TimeOfDay(hour: 10, minute: 30);

  void initState() {
    super.initState();
    getdataFood();

    //retrieveData();
  }

  List<String> listSelectFood = [];
  List<String> listItem = [
    'รับจ้างอิสระ',
    'รับจ้างทั่วไป',
    'ข้าราชการ',
    'บริหารธุรกิจ',
    'พนักงานเอกชน',
    'เกษตรกร',
    'แม่บ้าน/พ่อบ้าน',
    'นักเรียน/นักศึกษา',
    'ว่างงาน',
  ];

  Future getdataFood() async {
    Api restActivity = new Api();
    var restfood = await restActivity.get_food_map();
    loading = false;
    setState(() {
      listFood = restfood;
      print(listFood);
    });
  }

  Widget build(BuildContext context) {
    /*final favfoodField = loading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : DropdownButtonFormField2(
            validator: (value) => value == null ? "กรุณาเลือกเมนู" : null,
            onChanged: (menuValue) {
              setState(() {
                textEditingController.text = menuValue! as String;
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
            buttonWidth: 200,
            itemHeight: 40,
            dropdownMaxHeight: 200,
            searchController: textEditingController,
            searchInnerWidgetHeight: 50,
            searchInnerWidget: Padding(
              padding: EdgeInsets.only(
                top: 8,
                bottom: 4,
                right: 8,
                left: 8,
              ),
              child: TextFormField(
                controller: textEditingController,
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
                textEditingController.clear();
              }
            },
            value: _selectedMenu,
            isExpanded: true,
            hint: Text(
              "เลือกเมนูโปรด",
            ),
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.transgender),
              contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
              hintText: "อาชีพ",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              //textInputAction: TextInputAction.next,
            ),
          );*/
    final multiSelect = loading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : CustomSearchableDropDown(
            items: listFood,
            label: 'เลือกเมนูอาหารที่ชอบ',
            //multiSelectTag: 'Names',
            multiSelectValuesAsWidget: true,
            decoration: BoxDecoration(border: Border.all(color: Colors.blue)),
            multiSelect: true,
            prefixIcon: Padding(
              padding: const EdgeInsets.all(0.0),
              child: Icon(Icons.search),
            ),
            dropDownMenuItems: listFood.map((item) {
              return item.toString();
            }).toList(),
            onChanged: (value) {
              if(value != null){
                print(value);
                selected = value!;
                print(selected);
              }else{
                Text('กรุณากรอก');
              }
            },
          );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange.shade400,
        title: Text('มื้ออาหาร'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black, //color of border
                      width: 2, //width of border
                    ),
                    //color: Colours.lightSalmon.withOpacity(0.6),
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ExpansionTile(
                      title: Text('ใส่เวลาย้อนหลัง'),

                      //backgroundColor: Colours.blueGrey,
                      children: [
                        TimeMealField(),
                      ],
                      onExpansionChanged: (bool expanded) {},
                      controlAffinity: ListTileControlAffinity.trailing,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    //color: Colours.lightSalmon.withOpacity(0.6),
                    border: Border.all(
                      color: Colors.black, //color of border
                      width: 2, //width of border
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ExpansionTile(
                      title: Text('ใส่ค่าน้ำตาลที่ปรุง'),
                      //backgroundColor: Colours.blueGrey,
                      children: [
                        sugarField(),
                      ],
                      onExpansionChanged: (bool expanded) {},
                      controlAffinity: ListTileControlAffinity.trailing,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              multiSelect,
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget TimeMealField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('เวลาย้อนหลัง', style: TextStyle(fontWeight: FontWeight.bold)),
        TextFormField(
          autofocus: false,
          controller: textEditingController,
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value!.isEmpty) {
              return ("");
            }
            return null;
          },
          onSaved: (value) {
            textEditingController.text = value!;
          },
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            prefixIcon: Icon(LineAwesomeIcons.clock),
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "เวลาย้อนหลัง",
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.deepPurple),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }

  Widget _TimePicker() {
    return TextFormField(
      autofocus: false,
      controller: textEditingController,
      validator: (value) {
        if (value!.isEmpty) {
          return ("");
        }
        return null;
      },
      onSaved: (value) {
        textEditingController.text = value!;
      },
      decoration: InputDecoration(
        labelText: 'กรุณาใส่วันเกิด',
        prefixIcon: Icon(Icons.calendar_today_outlined),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "วันเกิด",
        border: OutlineInputBorder(
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
          //String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
          //print(formattedDate);
          setState(() {
            textEditingController.text =
                pickedTime.toString(); //set output date to TextField value.
          });
        } else {}
      },
    );
  }

  Widget sugarField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('ใส่ค่าน้ำตาลที่ปรุง',
            style: TextStyle(fontWeight: FontWeight.bold)),
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
            hintText: "ค่าน้ำตาลที่ปรุง (หน่วยเป็นช้อนชา)",
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.deepPurple),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }
}
