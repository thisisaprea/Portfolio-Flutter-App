

import 'package:custom_searchable_dropdown/custom_searchable_dropdown.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';


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
  var selected;
  bool loading = true;
  final TextEditingController textEditingController = TextEditingController();
  final TextEditingController sugarEditingController = TextEditingController();
  final TextEditingController birthdayEditingController =
  new TextEditingController();
  TimeOfDay time = TimeOfDay(hour: 10, minute: 30);
  DateTime _selectedYears = DateTime(2008);
  var showYear;

  selectYear(context) async {
    print("Calling date picker");
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("เลือกปีเกิด (ปี ค.ศ.)"),
          content: SizedBox(
            width: 300,
            height: 300,
            child: YearPicker(
              firstDate: DateTime(1940),
              lastDate: DateTime(2008),
              initialDate: DateTime.now(),
              selectedDate: _selectedYears,
              onChanged: (DateTime dateTime) {
                print(dateTime.year);
                setState(() {
                  _selectedYears = dateTime;
                  showYear = "${dateTime.year}";
                  birthdayEditingController.text = showYear;
                });
                Navigator.pop(context);
              },
            ),
          ),
        );
      },
    );
  }
  Widget build(BuildContext context) {
    final birthdayField = TextFormField(
      autofocus: false,
      controller: birthdayEditingController,
      validator: (value) {
        if (value!.isEmpty) {
          return ("กรุณาใส่วันเกิด");
        }
        return null;
      },
      onSaved: (value) {
        birthdayEditingController.text = value!;
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
        selectYear(context);
        if (showYear != null) {
          print(showYear);
          setState(() {
            birthdayEditingController.text =
                showYear; //set output date to TextField value.
          });
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
              birthdayField
            ],
          ),
        ),
      ),
    );
  }
}
