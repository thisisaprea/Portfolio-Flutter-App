/*final birthdayField1 = TextFormField(
      autofocus: false,
      controller: TimePickerEditingController,
      validator: (value) {
        if (value!.isEmpty) {
          return ("กรุณาใส่วันเกิด");
        }
        return null;
      },
      onSaved: (value) {
        TimePickerEditingController.text = value!;
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
      onTap: () {
        CupertinoButton(
          onPressed: () {
            showCupertinoModalPopup(
                context: context,
                builder: (context) => SizedBox(
                      height: 250,
                      child: CupertinoDatePicker(
                        initialDateTime: DateTime.now(),
                        mode: CupertinoDatePickerMode.date,
                        minimumDate: DateTime(1900),
                        maximumDate: DateTime(2006),
                        use24hFormat: true,
                        onDateTimeChanged: (date) {
                          setState(() {
                            dateTime = date;
                          });
                        },
                      ),
                    ));
          },
          child: Text('data'),
        );
        if (dateTime != null) {
          print(dateTime);
          String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
          print(formattedDate);
          setState(() {
            TimePickerEditingController.text =
                formattedDate; //set output date to TextField value.
          });
        } else {}
      },
    );*/
/*void signUp(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      check_user user_check = await new check_user();
      var signup = await user_check.signup(
          emailEditingController.text,
          passwordEditingController.text,
          firstNameEditingController.text,
          lastNameEditingController.text,
          birthdayEditingController.text,
          occupationEditingController.text,
          weightEditingController.text,
          fbsEditingController.text,
          sexEditingController.text,
          listfood);
      print((listfood));
      if (await signup['message'] == "Signup Finishes") {
        await showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text('กรุณายืนยัน E-mail เพื่อการสมัครสมาชิกที่สมบูรณ์'),
          ),
        );
        MaterialPageRoute materialPageRoute = MaterialPageRoute(
            builder: (BuildContext context) => Bottom_Pages());
        Navigator.of(this.context).push(materialPageRoute);
      } else {
        print(signup['message']);
        MaterialPageRoute materialPageRoute = MaterialPageRoute(
            builder: (BuildContext context) => Register_screen());
        Navigator.of(this.context).push(materialPageRoute);
      }
      print(birthdayEditingController.text);
      print(listfood);
    }
    */
/*try {
        await _auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) => {postDetailsToFirestore()})
            .catchError((e) {
          Fluttertoast.showToast(msg: e!.message);
        });
      } on FirebaseAuthException catch (error) {
        switch (error.code) {
          case "invalid-email":
            errorMessage = "Your email address appears to be malformed.";
            break;
          case "wrong-password":
            errorMessage = "Your password is wrong.";
            break;
          case "user-not-found":
            errorMessage = "User with this email doesn't exist.";
            break;
          case "user-disabled":
            errorMessage = "User with this email has been disabled.";
            break;
          case "too-many-requests":
            errorMessage = "Too many requests";
            break;
          case "operation-not-allowed":
            errorMessage = "Signing in with Email and Password is not enabled.";
            break;
          default:
            errorMessage = "An undefined Error happened.";
        }
        Fluttertoast.showToast(msg: errorMessage!);
        print(error.code);
      }*/ /*
  }
  List<String> activityList = [
    'ปิงปอง',
    'ฟิตเนส',
    'บาสเกตบอล',
    'ทำงานบ้าน',
    'เดินเร็ว 4 กม./ชม.',
    'ว่ายน้ำ',
    'เล่นกอล์ฟ',
    'วิ่งเหยาะ',
    'เต้นแอโรบิกง',
    'แบดมินตัน',
    'เทนนิส',
    'ทำสวน',
    'โบว์ลิง',
    'ปั่นจักรยาน',
  ];
  */