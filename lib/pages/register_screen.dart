import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:colours/colours.dart';
import 'package:date_field/date_field.dart';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:multiple_search_selection/multiple_search_selection.dart';
import 'package:project_final/services/Api.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controller/check_User.dart';
import 'bottom_page.dart';
import 'login.dart';

class Register_screen extends StatefulWidget {
  static const routeName = '/register_screen';
  var restFood;

  //const Register_screen({Key? key}) : super(key: key);
  Register_screen({required this.restFood});

  @override
  _Register_screenState createState() =>
      _Register_screenState(restFood: restFood);
}

class _Register_screenState extends State<Register_screen> {
  var restFood;

  _Register_screenState({required this.restFood});

  late double screen;
  String? errorMessage;
  bool _isObscure = true;
  bool _isObscurere = true;
  final _formKey = GlobalKey<FormState>();
  String? dropdownValue = '';
  var _selectedMenu;
  var menu;
  var selectedjobs;
  var listFood;
  DateTime dateTime = DateTime.now();
  List<String> listmultiFood = [];
  List<String> listfood = [
    'ข้าวผัดกุ้ง',
    'ข้าวกระเพราหมูสับ',
    'ผัดซีอิ๊ว',
    'สุกี้หมูแห้ง',
    'โอเลี้ยง'
  ];

  //var job = "นักเรียน/นักศึกษา";
  List<String> jobList = [
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
  List<String> gender = <String>[
    'หญิง',
    'ชาย',
  ];

  // editing Controller
  final userNameEditingController = TextEditingController();
  final firstNameEditingController = TextEditingController();
  final lastNameEditingController = TextEditingController();
  final emailEditingController = TextEditingController();
  final passwordEditingController = TextEditingController();
  final confirmPasswordEditingController = TextEditingController();
  final fbsEditingController = TextEditingController();
  final jobEditingController = TextEditingController();
  final sexEditingController = TextEditingController();
  final birthdayEditingController = TextEditingController();
  final weightEditingController = TextEditingController();
  final menuItemsEditingController1 = TextEditingController();
  final menuItemsEditingController2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    screen = MediaQuery.of(context).size.width;
    //name
    final firstNameField = TextFormField(
      autofocus: false,
      controller: firstNameEditingController,
      keyboardType: TextInputType.name,
      validator: (value) {
        RegExp regex = new RegExp(r'^.{3,}$');
        if (value!.isEmpty) {
          return ("กรุณาใส่ชื่อ");
        }
        if (!regex.hasMatch(value)) {
          return ("ชื่อผู้ใช้ต้องมีตัวอักษรอย่างน้อย 3 ตัวอักษร");
        }
        return null;
      },
      onSaved: (value) {
        firstNameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.account_circle),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "ชื่อ",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
    final lastNameField = TextFormField(
      autofocus: false,
      controller: lastNameEditingController,
      keyboardType: TextInputType.name,
      validator: (value) {
        RegExp regex = new RegExp(r'^.{3,}$');
        if (value!.isEmpty) {
          return ("กรุณาใส่นามสกุล");
        }
        if (!regex.hasMatch(value)) {
          return ("นามสกุลผู้ใช้ต้องมีตัวอักษรอย่างน้อย 3 ตัวอักษร");
        }
        return null;
      },
      onSaved: (value) {
        lastNameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.account_circle),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "นามสกุล",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
    //fbs field
    final fbsField = TextFormField(
        autofocus: false,
        controller: fbsEditingController,
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value!.isEmpty) {
            return ("กรุณาใส่ค่าน้ำตาลในเลือด");
          }
          return null;
        },
        onSaved: (value) {
          fbsEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.bloodtype),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "ค่าน้ำตาลในเลือด",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));
    final weightField = TextFormField(
        autofocus: false,
        controller: weightEditingController,
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value!.isEmpty) {
            return ("กรุณาใส่น้ำหนัก (กก.)");
          }
          return null;
        },
        onSaved: (value) {
          weightEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.monitor_weight_outlined),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "น้ำหนัก",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));
    //sexField
    final sexField = DropdownButtonFormField(
      validator: (value) => value == null ? "กรุณาเลือกเพศ" : null,
      onChanged: (String? newValue) {
        setState(() {
          sexEditingController.text = newValue!;
        });
      },
      items: gender.map<DropdownMenuItem<String>>(
        (String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        },
      ).toList(),
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.transgender),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "เพศ",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        //textInputAction: TextInputAction.next,
      ),
    );
    //occupationField
    final occupationField = DropdownButtonFormField(
      validator: (value) => value == null ? "กรุณาเลือกอาชีพ" : null,
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
        prefixIcon: Icon(Icons.transgender),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "อาชีพ",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        //textInputAction: TextInputAction.next,
      ),
    );
    //birthday field
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
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1940),
          lastDate: DateTime.now(),
        );
        if (pickedDate != null) {
          print(pickedDate);
          String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
          print(formattedDate);
          setState(() {
            birthdayEditingController.text =
                formattedDate; //set output date to TextField value.
          });
        } else {}
      },
    );
    //fev 5 foods
    final favfoodField = DropdownButtonFormField2(
      validator: (value) => value == null ? "กรุณาเลือกเมนู" : null,
      onChanged: (menuValue) {
        setState(() {
          menuItemsEditingController2.text = menuValue! as String;
        });
      },
      items: restFood.map<DropdownMenuItem<String>>(
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
      searchController: menuItemsEditingController2,
      searchInnerWidgetHeight: 50,
      searchInnerWidget: Padding(
        padding: EdgeInsets.only(
          top: 8,
          bottom: 4,
          right: 8,
          left: 8,
        ),
        child: TextFormField(
          controller: menuItemsEditingController2,
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
          menuItemsEditingController2.clear();
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
    );

    final emailField = TextFormField(
        autofocus: false,
        controller: emailEditingController,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value!.isEmpty) {
            return ("กรุณาใส่อีเมล");
          }
          // reg expression for email validation
          if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
              .hasMatch(value)) {
            return ("กรุณาใส่อีเมลที่ถูกต้อง เช่น flutter@me.com");
          }
          return null;
        },
        onSaved: (value) {
          emailEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.mail),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "อีเมล",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));
    //password field
    final passwordField = TextFormField(
        autofocus: false,
        controller: passwordEditingController,
        obscureText: _isObscure,
        validator: (value) {
          RegExp regex = new RegExp(r'^.{6,}$');
          if (value!.isEmpty) {
            return ("Password is required for login");
          }
          if (value.length > 15) {
            return ("Enter Valid Password(Max. 15 Character)");
          }
          if (!regex.hasMatch(value)) {
            return ("Enter Valid Password(Min. 6 Character)");
          }
        },
        onSaved: (value) {
          userNameEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.vpn_key),
          suffixIcon: IconButton(
            icon: Icon(_isObscure ? Icons.visibility : Icons.visibility_off),
            onPressed: () {
              setState(() {
                _isObscure = !_isObscure;
              });
            },
          ),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "รหัสผ่าน",
          labelText: "รหัสผ่าน",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));
    //confirm password field
    final confirmPasswordField = TextFormField(
        autofocus: false,
        controller: confirmPasswordEditingController,
        obscureText: _isObscurere,
        validator: (value) {
          if (confirmPasswordEditingController.text !=
              passwordEditingController.text) {
            return "รหัสผ่านไม่ตรงกัน กรุณาใส่รหัสผ่านที่ตรงกัน";
          }
          return null;
        },
        onSaved: (value) {
          confirmPasswordEditingController.text = value!;
        },
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.vpn_key),
          suffixIcon: IconButton(
            icon: Icon(_isObscurere ? Icons.visibility : Icons.visibility_off),
            onPressed: () {
              setState(() {
                _isObscurere = !_isObscurere;
              });
            },
          ),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "ยืนยันรหัสผ่าน",
          labelText: "ยืนยันรหัสผ่าน",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    return Scaffold(
      backgroundColor: Colors.green.shade100,
      body: Center(
        child: SingleChildScrollView(
          child: SafeArea(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'ลงทะเบียน',
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colours.snow,
                      ),
                      child: Column(
                        children: [
                          firstNameField,
                          SizedBox(height: 20),
                          lastNameField,
                          SizedBox(height: 20),
                          emailField,
                          SizedBox(height: 20),
                          passwordField,
                          SizedBox(height: 20),
                          confirmPasswordField,
                          SizedBox(height: 20),
                          fbsField,
                          SizedBox(height: 20),
                          weightField,
                          SizedBox(height: 20),
                          sexField,
                          SizedBox(height: 20),
                          occupationField,
                          SizedBox(height: 20),
                          favfoodField,
                          SizedBox(height: 20),
                          birthdayField,
                          /*favfood1,
                      SizedBox(height: 20),
                      favfood1,
                      SizedBox(height: 20),
                      favfood1,
                      SizedBox(height: 20),
                      favfood1,
                      SizedBox(height: 20),
                      favfood1,
                      SizedBox(height: 20),*/
                          signupButton(),
                        ],
                      ),
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "เป็นสมาชิกอยู่แล้ว? ",
                          style: TextStyle(color: Colors.black),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => login_page()));
                          },
                          child: Text(
                            "เข้าสู่ระบบ",
                            style: TextStyle(
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container signupButton() {
    return Container(
      margin: EdgeInsets.only(top: 16),
      width: screen * 0.75,
      child: SizedBox(
        width: 140,
        height: 55,
        child: ElevatedButton(
          onPressed: () async {
            print('--------------- Email and Password ---------------');
            bool validate = _formKey.currentState!.validate();
            if (validate) {
              check_user user_check = await new check_user();
              var signup = await user_check.signup(
                  emailEditingController.text,
                  passwordEditingController.text,
                  firstNameEditingController.text,
                  lastNameEditingController.text,
                  birthdayEditingController.text,
                  jobEditingController.text,
                  weightEditingController.text,
                  fbsEditingController.text,
                  sexEditingController.text,
                  listfood.toString());

              if (await signup['message'] == "Signup Finishes") {
                await AwesomeDialog(
                  context: context,
                  dialogType: DialogType.info,
                  animType: AnimType.topSlide,
                  showCloseIcon: true,
                  headerAnimationLoop: false,
                  title: 'Warning',
                  desc: 'กรุณายืนยัน E-mail เพื่อการสมัครสมาชิกที่สมบูรณ์',
                  btnOkOnPress: () {},
                ).show();
                print(
                    "------------------pop up บอกกรุณายืนยัน Email------------------------");
                MaterialPageRoute materialPageRoute = MaterialPageRoute(
                    builder: (BuildContext context) => login_page());
                Navigator.of(this.context).push(materialPageRoute);
              } else {
                Api apiRest = new Api();
                var restFood = await apiRest.get_food();
                print(signup['message']);
                MaterialPageRoute materialPageRoute = MaterialPageRoute(
                    builder: (BuildContext context) =>
                        Register_screen(restFood: restFood));
                Navigator.of(this.context).push(materialPageRoute);
              }
              print(firstNameEditingController.text);
              print(lastNameEditingController.text);
            }
          },
          child: Text(
            "ลงทะเบียน",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          style: ElevatedButton.styleFrom(
              elevation: 5,
              backgroundColor: Colors.green.shade400,
              side: BorderSide.none,
              shape: StadiumBorder()),
        ),
      ),
    );
  }
}
