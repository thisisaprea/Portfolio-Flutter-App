import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:colours/colours.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_final/controller/check_User.dart';
import 'package:project_final/pages/register_screen.dart';
import 'package:project_final/services/Api.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
    final passwordField = Column(
      children: [
        TextFormField(
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
                icon: Icon(
                    isHiddenPassword ? Icons.visibility : Icons.visibility_off),
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
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () async{
                Api callApi = new Api();
                await callApi.resetPassword(emailController.text);
                  await AwesomeDialog(
                      context: context,
                      dialogType: DialogType.warning,
                      animType: AnimType.topSlide,
                      showCloseIcon: true,
                      headerAnimationLoop: false,
                      title: 'เปลี่ยนรหัสผ่าน',
                      desc: 'กรุณาตรวจสอบ E-mail เพื่อทำการเปลี่ยนรหัสผ่าน',
                      btnOkText: 'ตกลง',
                      btnOkOnPress: () async {
                        print('---------------------------------------');
                        print('reset password success');
                        print('---------------------------------------');
                      },
                  )
                      .show();
              },
              child: Text(
                "ลืมรหัสผ่าน?",
                style: TextStyle(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
              ),
            ),
          ],
        )
      ],
    );

    final loginButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.green.shade400,
      child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () async {
            bool validate = _formKey.currentState!.validate();
            if (validate) {
              SharedPreferences pref = await SharedPreferences.getInstance();
              check_user checkuse = new check_user();
              var login = await checkuse.login(
                  emailController.text, passwordController.text);
              if (await login['message'] == "Login success") {
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
              } else if (await login['message'] == "Verified false") {
                await AwesomeDialog(
                        context: context,
                        dialogType: DialogType.info,
                        animType: AnimType.topSlide,
                        showCloseIcon: true,
                        headerAnimationLoop: false,
                        title: 'E-mail Verified',
                        desc: 'กรุณายืนยัน E-mail เพื่อเข้าสู่ระบบ',
                        btnOkOnPress: () async {
                          print('---------------------------------------');
                          print(login['datauser']);
                          Api restSentVerify = await new Api();
                          await restSentVerify
                              .send_email_verifiretion(login['datauser']);
                          print('---------------------------------------');
                        },
                        btnCancelOnPress: () {})
                    .show();
              } else {
                await AwesomeDialog(
                  context: context,
                  dialogType: DialogType.warning,
                  animType: AnimType.topSlide,
                  showCloseIcon: true,
                  headerAnimationLoop: false,
                  title: 'Login Failed',
                  desc: 'เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง',
                  btnOkColor: Colors.blueAccent.shade200,
                  btnOkOnPress: () {},
                ).show();
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
        backgroundColor: Colors.green.shade100,
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(10),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      "assets/images/Logo.png",
                      width: 300.0,
                      //fit: BoxFit.contain,
                    ),
                    Container(
                      padding:
                          EdgeInsets.only(right: 8, left: 8, top: 8, bottom: 2),
                      decoration: BoxDecoration(
                        color: Colours.whiteSmoke,
                        //Colors.green.withOpacity(0.7),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30)),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'เข้าสู่ระบบ',
                            style: TextStyle(
                                fontSize: 50, fontWeight: FontWeight.w400),
                          ),
                          SizedBox(height: 24),
                          emailField,
                          SizedBox(height: 15),
                          passwordField,
                          SizedBox(height: 15),
                          loginButton,
                          SizedBox(height: 15),
                        ],
                      ),
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "ยังไม่ได้ลงทะเบียนบัญชีผู้ใช้? ",
                          style: TextStyle(color: Colors.black),
                        ),
                        GestureDetector(
                          onTap: () async {
                            //call Api here
                            Api apiRest = new Api();
                            List<String> restFood = await apiRest.get_food();
                            var restApiFood = await apiRest.get_food_map();

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        Register_screen(restFood: restFood, restApiFood: restApiFood,)));
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
/*void resendVerify(){
    GestureDetector(
      onTap: () async{
        Api apiRest = new Api();
        var verify = apiRest.se
      },
      child: Text(
        "รับ E-mail ยืนยันอีกครั้ง",
        style: TextStyle(
            color: Colors.blueAccent,
            fontWeight: FontWeight.bold,
            fontSize: 15),
      ),
    )*/
}
