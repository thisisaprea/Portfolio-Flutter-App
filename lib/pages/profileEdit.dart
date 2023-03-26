import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:colours/colours.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:project_final/pages/bottom_page.dart';

class ProfileEdit extends StatefulWidget {
  const ProfileEdit({Key? key}) : super(key: key);

  @override
  _ProfileEditState createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  @override
  Widget build(BuildContext context) {
    return Container();
    /*return SingleChildScrollView(
      child: AlertDialog(
        backgroundColor: Colours.beige,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(
          'แก้ไขข้อมูลส่วนตัว',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        buttonPadding: const EdgeInsets.only(right: 24),
        elevation: 24.0,
        actions: [
          saveBox(),
          cancelButton(context),
        ],
        content: Builder(
            builder: (context) {
              var heigth = MediaQuery.of(context).size.height;
              var width = MediaQuery.of(context).size.width;
              return Container(
                height: heigth - 460,
                width: width - 5,
                child: Column(
                  children: [
                    Form(
                      child: Column(
                        children: [
                          TextFormField(
                            autofocus: false,
                            controller: fNameEditingController,
                            keyboardType: TextInputType.name,
                            validator: (value) {
                              RegExp regex = new RegExp(r'^.{3,}$');
                              if (value!.isEmpty) {
                                return (fNameEditingController.text);
                              }
                              if (!regex.hasMatch(value)) {
                                return ("ชื่อผู้ใช้ต้องมีตัวอักษรอย่างน้อย 3 ตัวอักษร");
                              }
                              return null;
                            },
                            onSaved: (value) {
                              fNameEditingController.text = value!;
                            },
                            textInputAction: TextInputAction.none,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.account_circle),
                              contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                              hintText: "ชื่อ",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            autofocus: false,
                            controller: lNameEditingController,
                            keyboardType: TextInputType.name,
                            validator: (value) {
                              RegExp regex = new RegExp(r'^.{3,}$');
                              if (value!.isEmpty) {
                                return (lNameEditingController.text);
                              }
                              if (!regex.hasMatch(value)) {
                                return ("นามสกุลต้องมีตัวอักษรอย่างน้อย 3 ตัวอักษร");
                              }
                              return null;
                            },
                            onSaved: (value) {
                              lNameEditingController.text = value!;
                            },
                            textInputAction: TextInputAction.none,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.account_circle),
                              contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                              hintText: "นามสกุล",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),

                          TextFormField(
                            autofocus: false,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return (weightEditingController.text);
                              }
                              return null;
                            },
                            onSaved: (value) {
                              weightEditingController.text = value!;
                            },
                            textInputAction: TextInputAction.none,
                            controller: weightEditingController,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.line_weight),
                              contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                              hintText: "น้ำหนัก",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              //textInputAction: TextInputAction.next,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          DropdownButtonFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return (jobEditingController.text);
                              }
                              return null;
                            },

                            onChanged: (String? newValue) {
                              setState(() {
                                jobEditingController.text = newValue!;
                              });
                            },
                            items: jobList.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              },
                            ).toList(),
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.work,),
                              contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                              hintText: "อาชีพ",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              //textInputAction: TextInputAction.next,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            autofocus: false,
                            controller: fbsEditingController,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return (fbsEditingController.text);
                              }
                              return null;
                            },
                            onSaved: (value) {
                              fbsEditingController.text = value!;
                            },
                            textInputAction: TextInputAction.none,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.bloodtype),
                              contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                              hintText: "ค่าน้ำตาลในเลือด (FBS)",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              //textInputAction: TextInputAction.next,
                            ),
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
              );
            }
        ),
      ),
    );*/
  }
}

