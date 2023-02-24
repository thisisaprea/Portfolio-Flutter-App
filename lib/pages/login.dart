import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_final/controller/check_User.dart';
import 'package:project_final/controller/user_model.dart';
import 'package:project_final/pages/HomePage.dart';
import 'package:project_final/pages/main_page.dart';
import 'package:project_final/pages/register_screen.dart';
import 'package:project_final/services/Api.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controller/User_Convert_data.dart';
import 'bottom_page.dart';

class login_page extends StatefulWidget {
  static const routeName = '/LoginPage';

  const login_page({Key? key}) : super(key: key);

  @override
  _login_pageState createState() => _login_pageState();
}

class _login_pageState extends State<login_page> {
  final _formKey = GlobalKey<FormState>();
  bool isHiddenPassword = true;



  // editing controller
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  late SharedPreferences pref;
  //final _auth = FirebaseAuth.instance;
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    final emailField = TextFormField(
        autofocus: false,
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value!.isEmpty) {
            return ("กรุณาใส่อีเมล");
          }
          // reg expression for email validation
          if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
              .hasMatch(value)) {
            return ("อีเมลไม่ถูกต้อง");
          }
          return null;
        },
        onSaved: (value) {
          emailController.text = value!;
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
        controller: passwordController,
        obscureText: isHiddenPassword,
        validator: (value) {
          RegExp regex = new RegExp(r'^.{6,}$');
          if (value!.isEmpty) {
            return ("กรุณาใส่รหัสผ่าน");
          }
          if (!regex.hasMatch(value)) {
            return ("รหัสผ่านไม่ถูกต้อง");
          }
        },
        onSaved: (value) {
          passwordController.text = value!;
        },
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.vpn_key),
          suffixIcon: IconButton(
              icon:
              Icon(isHiddenPassword? Icons.visibility : Icons.visibility_off),
              onPressed: () {
                setState(() {
                 isHiddenPassword = !isHiddenPassword;
                });
              }),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "รหัสผ่าน",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    final loginButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.green.shade400,
      child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () async{
            bool validate = _formKey.currentState!.validate();
            if(validate){
              SharedPreferences pref = await SharedPreferences.getInstance();
              check_user checkuse = new check_user();
              var login = await checkuse.login(emailController.text, passwordController.text);
              if(await login['message'] == "Login success"){
                
                pref.setString("email", login["datauser"]["Email"]);
                pref.setString("firstname", login["datauser"]["Firstname"]);
                pref.setString("lastname", login["datauser"]["Lastname"]);
                pref.setString("token", login["datauser"]["Token"]);
                pref.setString("gender", login["datauser"]["Sex"]);
                pref.setString("job", login["datauser"]["Job"]);
                pref.setString("height", login["datauser"]["Height"]);
                pref.setString("weight", login["datauser"]["Weight"]);
                pref.setString("username", login["datauser"]["Username"]);
                pref.setString("birthday", login["datauser"]["Birthday"]);
                pref.setString("age", login["datauser"]["Age"]);
                pref.setString("statusLogin", login["datauser"]["statuslogin"]);
                pref.setString("FBS", login["datauser"]["FBS"]);
                pref.setString("deviceLogin", login["datauser"]["devicelogin"]);

                
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => Bottom_Pages()));
              }
              print("------------------------------------------");
              print(pref.getString('firstname'));
            }
          },
          child: Text(
            "เข้าสู่ระบบ",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );



    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.lightGreen.shade100,
        appBar: AppBar(
          backgroundColor: Colors.green.shade400,
          title: Text(
            'เข้าสู่ระบบ',
            style: TextStyle(color: Colors.white),
          ),
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              /*Navigator.push(context,
                  MaterialPageRoute(builder: (context) => main_page()));*/
            },
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              color: Colors.white54,
              padding: EdgeInsets.all(25),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      "assets/images/Logo.png",
                      width: 500.0,
                      fit: BoxFit.contain,
                    ),
                    Text(
                      'เข้าสู่ระบบ',
                      style: TextStyle(
                          fontSize: 50, fontWeight: FontWeight.w400),
                    ),
                    SizedBox(height: 25),
                    emailField,
                    SizedBox(height: 25),
                    passwordField,
                    SizedBox(height: 35),
                    loginButton,
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "ยังไม่ได้ลงทะเบียนบัญชีผู้ใช้? ",
                          style: TextStyle(color: Colors.black),
                        ),
                        GestureDetector(
                          onTap: () async{
                            //call Api here
                            Api apiRest = new Api();
                            List<String> restFood = await apiRest.get_food();

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Register_screen(restFood:restFood)));
                          },
                          child: Text(
                            "ลงทะเบียน",
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

  void toglePasswordVoiew() {
    setState(() {
      isHiddenPassword = !isHiddenPassword;
    });
  }

}
