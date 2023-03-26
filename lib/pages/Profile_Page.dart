import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:colours/colours.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:project_final/services/Api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controller/check_User.dart';
import 'login.dart';

class profile_user extends StatefulWidget {
  static const routeName = '/Profile_user';

  const profile_user({Key? key}) : super(key: key);

  @override
  _profile_userState createState() => _profile_userState();
}

class _profile_userState extends State<profile_user> {
  var firstname;
  var lastname;
  var email;
  var fbs;
  var weight;
  var job;
  var uid;
  var firstnameNew,lastnameNew,fbsNew,weightNew,jobNew;
  final fNameEditingController = new TextEditingController();
  final lNameEditingController = new TextEditingController();
  final weightEditingController = new TextEditingController();
  final jobEditingController = new TextEditingController();
  final fbsEditingController = new TextEditingController();

  late SharedPreferences pref;
  bool loading = false;
  bool updateUser = false;
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

  Future getdataUser() async {
    //Api restActivity = new Api();
    pref = await SharedPreferences.getInstance();
    var restData = await pref.getString("firstname");
    var restData3 = await pref.getString("lastname");
    var restData4 = await pref.getString("email");
    var restData2 = await pref.getString("FBS");
    var restData5 = await pref.getString("job");
    var restData6 = await pref.getString("weight");
    var restDate7 = await pref.getString('token');

    loading = false;
    setState(() {
      firstname = restData;
      lastname = restData3;
      email = restData4;
      fbs = restData2;
      weight = restData6;
      job = restData5;
      uid = restDate7;
      fNameEditingController.text = firstname;
      lNameEditingController.text = lastname;
      weightEditingController.text = weight;
      jobEditingController.text = job;
      fbsEditingController.text = fbs;
    });
    print(fbsEditingController.text);
    print(jobEditingController.text);
  }

  void _onLoading() {
    setState(() {
      loading = true;
      new Future.delayed(new Duration(seconds: 1), getdataUser);
    });
  }
  Future refreshPage() async{
      var uid = await pref.getString("token");
      Api rest = await new Api();
      var restApi = await rest.get_user(uid);
      pref = await SharedPreferences.getInstance();
      pref.setString("firstname",restApi["datauser"]["Firstname"]);
      pref.setString("lastname",restApi["datauser"]["Lastname"]);
      pref.setString("FBS",restApi["datauser"]["FBS"]);
      pref.setString("job",restApi["datauser"]["Job"]);
      pref.setString("weight",restApi["datauser"]["Weight"]);
      var restData = await pref.getString("firstname");
      var restData3 = await pref.getString("lastname");
      var restData2 = await pref.getString("FBS");
      var restData5 = await pref.getString("job");
      var restData6 = await pref.getString("weight");
      setState(() {
        firstname = restData;
        lastname = restData3;
        job = restData5;
        weight = restData6;
        fbs = restData2;
        print('### Refresh done! ###');
        Navigator.of(context).pop();
        print(firstname);
        print(lastname);
        print(weight);
        print(job);
        print(fbs);
      });
  }
  @override
  void initState() {
    super.initState();
    getdataUser();
    _onLoading();
  }

  @override
  Widget build(BuildContext context) {
    final logoutCon = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.red.withOpacity(0.3),
      ),
      child: ListTile(
        onTap: () => AwesomeDialog(
          context: context,
          dialogType: DialogType.warning,
          animType: AnimType.topSlide,
          showCloseIcon: true,
          headerAnimationLoop: false,
          title: 'ออกจากระบบ',
          desc: 'ต้องการออกจากระบบ?',
          btnCancelOnPress: () {},
          btnCancelText: 'No',
          btnOkColor: Colors.green.shade300,
          btnCancelColor: Colors.red.shade300,
          btnOkOnPress: () async {
            check_user checkuse = new check_user();
            await checkuse.logout();
            MaterialPageRoute materialPageRoute = MaterialPageRoute(
                builder: (BuildContext context) => login_page());
            Navigator.of(this.context).push(materialPageRoute);
          },
          btnOkText: 'Yes',
        ).show(),
        leading: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Colors.red.withOpacity(0.2),
          ),
          child: Icon(
            LineAwesomeIcons.alternate_sign_out,
            color: Colors.red.shade400,
          ),
        ),
        title: Text('ออกจากระบบ',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600)),
      ),
    );
    return Scaffold(
      backgroundColor: Colours.lightGoldenRodYellow.withOpacity(0.8),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple.shade400,
        title: const Text("โปรไฟล์"),
      ),
      body: SingleChildScrollView(
        child: loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 1.93,
                    decoration: BoxDecoration(
                      color: Colours.mediumPurple.withOpacity(0.4),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30)),
                    ),
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ProfilePicture(
                                  name: firstname + ' '+ lastname,
                                  radius: 50,
                                  fontsize: 30,
                                  random: false,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  firstname + " " + lastname,
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                Text(
                                  email,
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.black),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colours.white.withOpacity(0.2),
                                          borderRadius: BorderRadius.all(Radius.circular(15)),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: Text('น้ำหนัก : '+weight + "  "+'น้ำตาลในเลือด : '+fbs, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),),
                                        ),
                                      ),
                                      SizedBox(height: 10,),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colours.white.withOpacity(0.2),
                                          borderRadius: BorderRadius.all(Radius.circular(15)),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: Text('อาชีพ : '+job, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),),
                                        ),
                                      ),

                                    ],
                                  ),
                                ),
                                Divider(height: 5,),
                                SizedBox(
                                  width: 140,
                                  height: 55,
                                  child: ElevatedButton(
                                    onPressed: () => showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          edit(context),
                                    ),
                                    child: Text(
                                      'Edit Profile',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                        Colors.deepPurple.shade300,
                                        side: BorderSide.none,
                                        shape: StadiumBorder()),
                                  ),
                                ),

                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),


                  Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              profileMenuWidget(
                                title: 'คู่มือการใช้แอปพลิเคชัน',
                                onPress: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context){
                                        return Guide();
                                      });
                                },
                                icon: LineAwesomeIcons.info,
                                endIcon: true,
                                textColor: Colors.black,
                                colorBox: Colors.deepPurple.withOpacity(0.2),
                              ),
                              Divider(height: 30,),
                              logoutCon,
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget Guide() {
    return AlertDialog(
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('ตกลง'),
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade700,
              textStyle: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
      backgroundColor: Colours.beige,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Text(
        'คำแนะนำ',
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
      buttonPadding: const EdgeInsets.only(right: 24),
      elevation: 24.0,
      content: SingleChildScrollView(
        child: Column(
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
                  Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.black, //color of border
                          width: 2, //width of border
                        ),
                      ),
                      child: Image.asset('assets/images/HomePageSugar.png')),
                  Text(
                    'ค่าน้ำตาลมี 2 ช่อง ช่องแรกคือค่าน้ำตาลที่กินไป ช่องที่สองคือค่าน้ำตาลที่คงเหลือ คนเป็นเบาหวานควรกินน้ำตาลไม่เกิน 8 กรัม หรือ 2 ช้อนชา',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
                  ),
                  Divider(
                    height: 20,
                  ),
                  Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.black, //color of border
                          width: 2, //width of border
                        ),
                      ),
                      child: Image.asset('assets/images/HomePageAddAc.png')),
                  Text(
                    'กล่องเพิ่มกิจกรรม มีกิจกรรมออกกำลังกาย และการกิน',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
                  ),
                  Divider(
                    height: 20,
                  ),
                  Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.black, //color of border
                          width: 2, //width of border
                        ),
                      ),
                      child: Image.asset('assets/images/homeFoodTodayZ.png')),
                  Text(
                    'กิจกรรมการกินวันนี้ จะแสดงการกินที่เคยใส่ข้อมูลในวันนั้น ๆ',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
                  ),
                  Divider(
                    height: 20,
                  ),
                  Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.black, //color of border
                          width: 2, //width of border
                        ),
                      ),
                      child:
                          Image.asset('assets/images/homeActivityTodayZ.png')),
                  Text(
                    'กิจกรรมการออกกำลังกายวันนี้ จะแสดงการทำกิจกรรมออกกำลังการที่เคยใส่ข้อมูลในวันนั้น ๆ',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
                  ),
                  Divider(
                    height: 20,
                  ),
                  Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.black, //color of border
                          width: 2, //width of border
                        ),
                      ),
                      child: Image.asset('assets/images/homeInput.png')),
                  Text(
                    'ปุ่มใส่ข้อมูลการกิน',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
                  ),
                  Divider(
                    height: 20,
                  ),
                  Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.black, //color of border
                          width: 2, //width of border
                        ),
                      ),
                      child: Image.asset('assets/images/AddFoodUiZ.png')),
                  Text(
                    'ช่องเพิ่มการการกิน ทั้งแบบกรอกมือ และกรอกด้วยเสียงผ่านไมโครโฟน',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
                  ),
                  Divider(
                    height: 20,
                  ),
                  Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.black, //color of border
                          width: 2, //width of border
                        ),
                      ),
                      child: Image.asset(
                          'assets/images/speechBotton.png')),
                  Text(
                    'กดปุ่มรูปไมค์ 1 ครั้งแล้วพูด และกดปุ่มอีกครั้งเมื่อพูดเสร็จแล้ว', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),),
                  Divider(height: 20,),
                  Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.black, //color of border
                          width: 2, //width of border
                        ),
                      ),
                      child: Image.asset('assets/images/Textspeech.png')),
                  Text('พูดในรูปแบบ มื้ออาหาร ชื่ออาหาร จำนวนอาหาร', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),),
                  Divider(height: 20,),
                  Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.black, //color of border
                          width: 2, //width of border
                        ),
                      ),
                      child: Image.asset('assets/images/advice.png')),
                  Text(
                    'ปุ่มคำแนะนำ จะอยู่ในหน้าต่างๆเพื่อแนะนำการใช้งานแอปพลิเคชัน',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
                  ),
                  Divider(
                    height: 20,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget edit(BuildContext context){
    return SingleChildScrollView(
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
                          textInputAction: TextInputAction.none,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
                          validator: (value) {
                            if (value!.isEmpty) {
                              return (weightEditingController.text);
                            }
                            return null;
                          },
                          onSaved: (value) {
                            weightEditingController.text = value!;
                          },
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
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
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
    );
  }
  Widget saveBox(){
    return ElevatedButton(
      onPressed: () async{
        Api rest = await new Api();
        var restApi = await rest.update_user(uid, email, fNameEditingController.text,
            lNameEditingController.text, jobEditingController.text, weightEditingController.text, fbsEditingController.text);
        if(await restApi['message'] == 'update data success'){
          print(email);
          print(fNameEditingController.text);
          print(weightEditingController.text);
          print(jobEditingController.text);
          refreshPage();
        }
      },
      style: ElevatedButton.styleFrom(
          primary: Colors.green.shade700,
          textStyle: TextStyle(fontWeight: FontWeight.bold),
      ),
      child: Text('ตกลง'),

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
}

class profileMenuWidget extends StatelessWidget {
  const profileMenuWidget(
      {Key? key,
      required this.title,
      required this.icon,
      required this.endIcon,
       this.onPress,
       this.textColor,
       this.colorBox});

  final String title;
  final IconData icon;
  final VoidCallback? onPress;
  final bool endIcon;
  final Color? textColor;
  final Color? colorBox;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: colorBox, //Colors.deepPurple.withOpacity(0.1),
      ),
      child: ListTile(
        onTap: onPress,
        leading: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Colors.deepPurple.withOpacity(0.1),
          ),
          child: Icon(
            icon,
            color: Colors.deepPurple.shade400,
          ),
        ),
        title: Text(title,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600)
                .apply(color: textColor)),
        trailing: endIcon
            ? Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.deepPurple.withOpacity(0.1),
                ),
                child: Icon(
                  LineAwesomeIcons.angle_right,
                  size: 18,
                  color: Colors.deepPurple.shade400,
                ),
              )
            : null,
      ),
    );
  }
}
