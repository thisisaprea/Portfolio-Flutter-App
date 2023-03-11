import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:colours/colours.dart';
import 'package:duration_picker/duration_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:project_final/pages/bottom_page.dart';
import 'package:project_final/pages/history_daily.dart';
import 'package:project_final/services/Api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/last_time.dart';
import '../widgets/ConsultationCard.dart';
import 'Profile_Page.dart';
import 'history.dart';
import 'addFood.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/HomePage';

  /*var restActivity;
  HomePage({required this.restActivity});*/
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState(); //restActivity: restActivity
}

class _HomePageState extends State<HomePage> {
  /* var restActivity;
  _HomePageState({required this.restActivity});*/
  var FBS;
  DateTime dateTime = DateTime.now();
  var dataName;
  var dataFbs;
  var id_user;
  var userage;
  final activityEditingController = new TextEditingController();
  final timeActivityEditingController = new TextEditingController();
  final TimePickerEditingController = new TextEditingController();
  var getsugar;
  var activity;
  var showAcitivityFood, showAcitivity;
  var titleActivity, titleFood;
  var dateFood, dateActivity;
  var MinutesToApi = 0;
  var sugarValue = 8.0;
  var titleText,subText;
  late SharedPreferences pref;
  String? dateStart;
  bool loading = true;
  bool loadingFood = false;
  bool loadingActivity = false;

  void _onLoadingActivity() {
    setState(() {
      loadingActivity = true;
      new Future.delayed(new Duration(seconds: 2),getdataActivity);
    });
  }
  void _onLoadingFood() {
    setState(() {
      loadingFood = true;
      new Future.delayed(new Duration(seconds: 2), getFoodUser);
    });
  }

  Future getActivityUser() async {
    Api restContent = await new Api();
    pref = await SharedPreferences.getInstance();
    String formattedDate = DateFormat('ddMMyyyy').format(dateTime);
    var restId = await pref.getString("token");
    var showAcitivity = await restContent.show_activity(restId, formattedDate);
    loadingActivity = false;
    setState(() {
      try {
        titleActivity = showAcitivity['datafood'][0]['nameactivity'] +
            " ระยะเวลา " + showAcitivity['datafood'][0]['timestamp'].toString() + ' นาที';
        dateActivity = 'วันที่ ' +
            (showAcitivity['datafood'][0]['datetime']).substring(0, 11) +
            ' เวลา ' +
            (showAcitivity['datafood'][0]['datetime']).substring(
                11, showAcitivity['datafood'][0]['datetime'].length) +
            ' น.';
      } catch (e) {
        titleActivity = 'คุณยังไม่มีการออกกำลังกายวันนี้';
        dateActivity = "";
      }
      this.showAcitivity = showAcitivity;
      print('////////////showAcitivity////////////');
    });
  }

  Future getFoodUser() async {
    Api restContent = await new Api();
    pref = await SharedPreferences.getInstance();
    String formattedDate = DateFormat('ddMMyyyy').format(dateTime);
    var restId = await pref.getString("token");
    var showAcitivityFood = await restContent.show_food(restId, formattedDate);
    loadingFood = false;
    setState(() {
      try {
        titleFood = 'มื้อ' +
            showAcitivityFood['datafood'][0]['meal'] +
            " ทาน" +
            showAcitivityFood['datafood'][0]['nameactivity'];
        dateFood = 'วันที่ ' +
            (showAcitivityFood['datafood'][0]['datetime']).substring(0, 11) +
            ' เวลา ' +
            (showAcitivityFood['datafood'][0]['datetime']).substring(
                11, showAcitivityFood['datafood'][0]['datetime'].length) +
            ' น.';
      } catch (e) {
        titleFood = 'คุณยังไม่มีการเพิ่มการกินวันนี้';
        dateFood = '';
      }
      this.showAcitivityFood = showAcitivityFood;
      print(titleFood);
      print('--------showAcitivityFood---------');
    });
  }

  void getdataActivity() async {
    Api restActivity = new Api();
    var restacivity = await restActivity.get_activity();
    setState(() {
      activity = restacivity;
    });
  }

  Future getSugar() async {
    pref = await SharedPreferences.getInstance();
    var restId = await pref.getString("token");
    Api restSugar = new Api();
    String formattedDate = DateFormat('ddMMyyyy').format(dateTime);
    var restsugar = await restSugar.get_sugar(await restId, formattedDate);

    print('//////////////////////////////////////');
    print(id_user);
    print(restsugar);
    print('//////////////////////////////////////');
    loading = false;
    setState(() {
      getsugar = restsugar;
      sugarValue = sugarValue - getsugar['sugar']['sugar'];
      if (sugarValue <= 0) {
        sugarValue = 0.0;
      }

      print(getsugar['sugar']['sugar']);
    });
  }

  void getdataUser() async {
    pref = await SharedPreferences.getInstance();
    var restData = await pref.getString("firstname");
    var restData2 = await pref.getString("FBS");
    var restId = await pref.getString("token");
    var restAge = await pref.getString("age");
    setState(() {
      dataName = restData;
      dataFbs = restData2;
      id_user = restId;
      userage = restAge;
    });
  }
  var number = 0;
  @override
  void initState() {
    super.initState();
    getdataUser();
    getdataActivity();
    getSugar();
    getActivityUser();
    getFoodUser();
    _onLoadingFood();
    _onLoadingActivity();

    print('-----------------------------------');
    print(loading.toString());
    print('-----------------------------------');
  }

  @override
  Future addLastTime(String food, String category) async {
    final lastTime = LastTime()
      ..food = food
      ..category = category
      ..createdDate = DateTime.now()
      ..timeStamp.add(DateTime.now());

    final box = Hive.box<LastTime>('lastTimes');
    box.add(lastTime);
    print('$box, $lastTime');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colours.lightGoldenRodYellow.withOpacity(0.8),
      //Colors.white54,
      floatingActionButton: SizedBox(
        width: 75,
        height: 75,
        child: FittedBox(
          child: FloatingActionButton(
            backgroundColor: Colours.darkGreen.shade400,
            onPressed: () => showDialog(
              context: context,
              builder: (context) => history_second(onFinish: addLastTime),
            ),
            child: Icon(Icons.add),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 2.5,
                decoration: BoxDecoration(
                  color: Colours.darkGreen.withOpacity(0.8),
                  //Colors.green.withOpacity(0.7),
                  border: Border.all(
                    color: Colors.black, //color of border
                    width: 2, //width of border
                  ),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30)),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(right: 8, left: 8, top: 15),
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          InkWell(
                            onTap: () async {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => profile_user()));
                            },
                            child: CircleAvatar(
                              backgroundImage:
                                  AssetImage('assets/images/girl.png'),
                              radius: 60,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "สวัสดี!",
                                  style: GoogleFonts.notoSerifThai(
                                    textStyle: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                Text(
                                  "คุณ ${dataName}",
                                  style: GoogleFonts.notoSerifThai(
                                    textStyle: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                Text(
                                  "ค่าน้ำตาลในเลือด: ${dataFbs}",
                                  style: GoogleFonts.notoSerifThai(
                                    textStyle: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                Text(
                                  "อายุ: ${userage}",
                                  style: GoogleFonts.notoSerifThai(
                                    textStyle: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 105,
                              width: 165,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black, //color of border
                                  width: 2, //width of border
                                ),
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white.withOpacity(0.5),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  //crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text('น้ำตาลที่กินไป',
                                      style: GoogleFonts.notoSerifThai(
                                        textStyle: TextStyle(
                                          color: Colors.black.withOpacity(0.8),
                                          fontWeight: FontWeight.w400,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                    loading? Center(child: CircularProgressIndicator(),)
                                        :Text(
                                      getsugar['sugar']['sugar'].toStringAsFixed(2) + ' กรัม',
                                      style: GoogleFonts.notoSerifThai(
                                        textStyle: TextStyle(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Container(
                              height: 105,
                              width: 165,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black, //color of border
                                  width: 2, //width of border
                                ),
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white.withOpacity(0.5),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  //crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text('น้ำตาลคงเหลือ',
                                      style: GoogleFonts.notoSerifThai(
                                        textStyle: TextStyle(
                                          color: Colors.black.withOpacity(0.8),
                                          fontWeight: FontWeight.w400,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                    loading ? Center(
                                      child: Container(
                                        width: 30, height: 30,child: CircularProgressIndicator(),
                                      ),
                                    ):Text(sugarValue.toStringAsFixed(2) + ' กรัม',
                                      style: GoogleFonts.notoSerifThai(
                                        textStyle: TextStyle(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Divider(color: Colors.black54, thickness: 1,),
              Padding(
                padding: EdgeInsets.all(8),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black, //color of border
                      width: 2, //width of border
                    ),
                    color: Colours.lightSteelBlue,
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'เพิ่มกิจกรรมของคุณ',
                              style: GoogleFonts.notoSerifThai(
                                textStyle: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                OutlinedButton(
                                  onPressed: () => showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        alertFilActivity(context),
                                  ),
                                  style: ButtonStyle(
                                    foregroundColor:
                                        MaterialStateProperty.all(
                                            Colors.white),
                                    backgroundColor:
                                        MaterialStateProperty.all(
                                            Colors.white38),
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(20),
                                        ),
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    'เพิ่มการออกกำลังกาย',
                                    style: GoogleFonts.notoSerifThai(
                                      textStyle: TextStyle(
                                        color: Colors.black87,
                                        //fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                ),
                                ),
                                SizedBox(width: 5,),
                                OutlinedButton(
                                  onPressed: () => showDialog(
                                    context: context,
                                    builder: (context) => history_second(onFinish: addLastTime),
                                  ),
                                  style: ButtonStyle(
                                    foregroundColor:
                                    MaterialStateProperty.all(
                                        Colors.white),
                                    backgroundColor:
                                    MaterialStateProperty.all(
                                        Colors.white38),
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(20),
                                        ),
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    'เพิ่มกิจกรรมการกิน',
                                    style: GoogleFonts.notoSerifThai(
                                      textStyle: TextStyle(
                                        color: Colors.black87,
                                        //fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),
                ),
              ),
              /*InkWell(
                onTap: () async {
                  print(showAcitivityFood);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => report_static(
                              restListActivity: showAcitivityFood['datafood'],
                              title: 'การกิน')));
                },
                child: Padding(
                  padding: EdgeInsets.only(top: 24, left: 10, right: 10),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 5,
                    decoration: BoxDecoration(
                      color: Colours.plum.withOpacity(0.6),
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(top: 5, left: 24, right: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'การกินมื้อล่าสุด',
                            style: GoogleFonts.notoSerifThai(
                              textStyle: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),
                          ),
                          loadingFood? Center(child: CircularProgressIndicator(),):
                          Text(
                            titleFood,
                            style: GoogleFonts.notoSerifThai(
                              textStyle: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                          ),
                          loadingFood? Center(child: CircularProgressIndicator(),):
                          Text(
                            dateFood,
                            style: GoogleFonts.notoSerifThai(
                              textStyle: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),*/
              Divider(color: Colors.black54, thickness: 1,),
              Container(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: loadingFood? Center(child: CircularProgressIndicator(),):
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black, //color of border
                            width: 2, //width of border
                          ),
                          color: Colours.lightSalmon.withOpacity(0.6),
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ExpansionTile(
                            title: Text('กิจกรรมการกินวันนี้',
                              style: GoogleFonts.notoSerifThai(
                              textStyle: TextStyle(
                                color: Colors.black87,
                                fontSize: 17,
                              ),
                            ),),
                            subtitle: Text(titleFood+'\n'+dateFood,
                              style: GoogleFonts.notoSerifThai(
                              textStyle: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),),
                            children: [
                              ListView.builder(
                                physics: ScrollPhysics(parent: null),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  titleText = showAcitivityFood['datafood'][index]['nameactivity'];
                                  subText = 'มื้อที่กิน : ' +
                                      showAcitivityFood['datafood'][index]['meal'] +
                                      " จำนวน : " +
                                      showAcitivityFood['datafood'][index]['amount'] +
                                      '\nวันที่ ' +
                                      (showAcitivityFood['datafood'][index]['datetime'])
                                          .substring(0, 11) +
                                      ' เวลา ' +
                                      (showAcitivityFood['datafood'][index]['datetime']).substring(
                                          11,
                                          showAcitivityFood['datafood'][index]['datetime'].length) +
                                      ' น.';
                                  return Container(
                                    margin: EdgeInsets.only(bottom: 8),
                                    padding:
                                    EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.black, //color of border
                                        width: 2, //width of border
                                      ),
                                      color: Colours.darkSeagreen,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(20),
                                      ),
                                    ),
                                    child: ListTile(
                                      trailing: Text(
                                        showAcitivityFood['datafood'][index]['sugar'].toStringAsFixed(2),style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700),),
                                      title: Text(titleText,style: TextStyle(fontWeight: FontWeight.w700),),
                                      subtitle: Text(subText,style: TextStyle(fontWeight: FontWeight.w700),),
                                      leading: Icon(LineAwesomeIcons.hamburger),
                                    ),
                                  );
                                },
                                itemCount: showAcitivityFood['datafood'].length,
                              ),
                            ],
                            onExpansionChanged: (bool expanded){},
                            controlAffinity: ListTileControlAffinity.trailing,

                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: loadingActivity? Center(child: CircularProgressIndicator(),):
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black, //color of border
                            width: 2, //width of border
                          ),
                          color: Colours.lightSalmon.withOpacity(0.6),
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ExpansionTile(
                            title: Text('กิจกรรมออกกำลังวันนี้',
                              style: GoogleFonts.notoSerifThai(
                                textStyle: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 17,
                                ),
                              ),),
                            subtitle: Text(titleActivity+'\n'+dateActivity,
                              style: GoogleFonts.notoSerifThai(
                                textStyle: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                ),
                              ),),
                            children: [
                              ListView.builder(
                                physics: ScrollPhysics(parent: null),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  titleText = showAcitivity['datafood'][index]['nameactivity'];
                                  subText = 'ระยะเวลาออกกำลังกาย : ' +
                                      showAcitivity['datafood'][index]['timestamp'] +
                                      '\nวันที่ ' +
                                      (showAcitivity['datafood'][index]['datetime'])
                                          .substring(0, 11) +
                                      ' เวลา ' +
                                      (showAcitivity['datafood'][index]['datetime']).substring(
                                          11,
                                          showAcitivity['datafood'][index]['datetime'].length) +
                                      ' น.';
                                  return Container(
                                    margin: EdgeInsets.only(bottom: 8),
                                    padding:
                                    EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.black, //color of border
                                        width: 2, //width of border
                                      ),
                                      color: Colours.cadetBlue.withOpacity(0.8),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(20),
                                      ),
                                    ),
                                    child: ListTile(
                                      trailing: Text(
                                        showAcitivity['datafood'][index]['sugar'].toStringAsFixed(2),style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700),),
                                      title: Text(titleText,style: TextStyle(fontWeight: FontWeight.w700),),
                                      subtitle: Text(subText,style: TextStyle(fontWeight: FontWeight.w700),),
                                      leading: Icon(LineAwesomeIcons.biking),
                                    ),
                                  );
                                },
                                itemCount: showAcitivity['datafood'].length,
                              ),
                            ],
                            onExpansionChanged: (bool expanded){},
                            controlAffinity: ListTileControlAffinity.trailing,

                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget alertFilActivity(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Text(
        'เพิ่มการทำกิจกรรม',
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
      buttonPadding: const EdgeInsets.only(right: 24),
      elevation: 24.0,
      content: Form(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            activity_field(),
            SizedBox(height: 10),
            timeToActivity_Field(),
          ],
        ),
      ),
      actions: <Widget>[
        cancelButton(context),
        addButton(context),
      ],
    );
  }

  Widget activity_field() {
    return DropdownButtonFormField(
      validator: (value) => value == null ? "กรุณาเลือกกิจกรรม" : null,
      onChanged: (String? newValue) {
        setState(() {
          activityEditingController.text = newValue!;
        });
      },
      items: activity.map<DropdownMenuItem<String>>(
        (String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        },
      ).toList(),
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.sports_volleyball),
        contentPadding: EdgeInsets.fromLTRB(20, 5, 5, 10),
        hintText: "กิจกรรม",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        //textInputAction: TextInputAction.next,
      ),
    );
  }

  Widget timeToActivity_Field() {
    return TextField(
      autofocus: false,
      controller: timeActivityEditingController,
      decoration: InputDecoration(
        labelText: 'กรุณาใส่เวลา',
        prefixIcon: Icon(Icons.calendar_today_outlined),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "ระยะเวลาในการออกกำลังกาย",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      readOnly: true,
      onTap: () async {
        Duration? pickedDate = (await showDurationPicker(
          context: context,
          initialTime: Duration(minutes: 10),
        ));
        if (pickedDate != null) {
          print(pickedDate.inMinutes);
          MinutesToApi = pickedDate.inMinutes;
          print(pickedDate.toString().substring(0, 4));
          timeActivityEditingController.text =
              pickedDate.toString().substring(0, 4);
        } else {}
      },
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

  Widget addButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        String formattedDateTime =
            DateFormat('dd/MM/yyyy H:m:s').format(dateTime);
        String formattedDate = DateFormat('ddMMyyyy').format(dateTime);
        final activityName = activityEditingController.text;
        final activityTime = timeActivityEditingController.text;
        print('id $id_user');
        print('activity $activityName');
        print('timeAc $activityTime');
        print('timeDate Event $formattedDateTime');
        print('timeDate Event Format $formattedDate');
        print(MinutesToApi);
        if (MinutesToApi > 0 && activityName != '') {
          Api setDataToApi = await new Api();
          var setData = await setDataToApi.add_activityinput(
              id_user,
              formattedDate,
              formattedDateTime,
              activityName,
              MinutesToApi.toString());
          if (await setData["message"] == 'success') {
            //Navigator.of(context).pop();
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
            desc: 'กรุณาใส่ข้อมูลให้ครบ',
            btnOkOnPress: () {},
          ).show();
        }
      },
      child: Text('ตกลง'),
      style: ElevatedButton.styleFrom(
          primary: Colours.darkGreen,
          textStyle: TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}
