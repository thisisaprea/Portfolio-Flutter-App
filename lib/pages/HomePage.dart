import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:duration_picker/duration_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:project_final/pages/bottom_page.dart';
import 'package:project_final/pages/history_daily.dart';
import 'package:project_final/services/Api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/last_time.dart';
import '../widgets/ConsultationCard.dart';
import 'Profile_User.dart';
import 'history.dart';
import 'history_second.dart';

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
  final activityEditingController = new TextEditingController();
  final timeActivityEditingController = new TextEditingController();
  final TimePickerEditingController = new TextEditingController();
  var getsugar;
  var activity;
  var showAcitivityFood, showAcitivity;
  var titleActivity, titleFood;
  var dateFood, dateActivity;
  var snapshotActivity;
  var MinutesToApi = 0;
  var sugarValue = 8.0;
  late SharedPreferences pref;
  String? dateStart;
  bool loading = false;
  void setDateStart(){
    setState(() {
      dateStart = '24/02/2023';
    });
  }
  void getActivityUser() async {
    Api restContent = await new Api();
    pref = await SharedPreferences.getInstance();
    String formattedDate = DateFormat('ddMMyyyy').format(dateTime);
    var restId = await pref.getString("token");
    var showAcitivity = await restContent.show_activity(restId, formattedDate);
    setState(() {
      try {
        titleActivity = 'คุณ' +
            showAcitivity['datafood'][0]['nameactivity'] + "\nระยะเวลา " + showAcitivity['datafood'][0]['timestamp'].toString() + ' นาที';
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
    });
  }

  void getFoodUser() async {
    Api restContent = await new Api();
    pref = await SharedPreferences.getInstance();
    String formattedDate = DateFormat('ddMMyyyy').format(dateTime);
    var restId = await pref.getString("token");
    var showAcitivityFood = await restContent.show_food(restId, formattedDate);
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
        titleFood = 'คุณยังไม่การเพิ่มการกินวันนี้';
        dateFood = '';
      }
      this.showAcitivityFood = showAcitivityFood;
    });
  }

  void getdataActivity() async {
    Api restActivity = new Api();
    var restacivity = await restActivity.get_activity();
    loading = true;
    setState(() {
      loading == false;
      activity = restacivity;

    });
  }

  void getSugar() async {

    pref = await SharedPreferences.getInstance();
    var restId = await pref.getString("token");
    Api restSugar = new Api();
    String formattedDate = DateFormat('ddMMyyyy').format(dateTime);
    var restsugar = await restSugar.get_sugar(await restId, formattedDate);
    print('//////////////////////////////////////');
    print(id_user);
    print(restsugar);
    print('//////////////////////////////////////');
    setState(() {
      getsugar = restsugar;
      sugarValue = sugarValue - getsugar['sugar']['sugar'];
      if(sugarValue <= 0){
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
    setState(() {
      dataName = restData;
      dataFbs = restData2;
      id_user = restId;
    });
  }

  @override
  void initState() {
    super.initState();
    getdataUser();
    getdataActivity();
    getSugar();
    getActivityUser();
    getFoodUser();
    setDateStart();
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
      backgroundColor: Colors.white54,
      floatingActionButton: SizedBox(
        width: 75,
        height: 75,
        child: FittedBox(
          child: FloatingActionButton(
            backgroundColor: Colors.green.shade400,
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
                height: MediaQuery.of(context).size.height / 7,
                decoration: BoxDecoration(
                  color: Colors.green.shade400,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20)),
                ),
                child: Row(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 20,
                        ),
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
                            radius: 25,
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "สวัสดี!",
                              style: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "${dataName}",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 150),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () async {
                        Api restContent = await new Api();
                        pref = await SharedPreferences.getInstance();
                        String formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);
                        var restId = await pref.getString("token");
                        var showAcitivityFood = await restContent.get_history(
                            restId, dateStart, formattedDate);
                        //print(showAcitivityFood['data_history'][0]);
                        var listHistory;

                        try {
                          listHistory = showAcitivityFood['data_history'][0];
                        } catch (e) {
                          listHistory = [];
                        };
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => history_daily(
                                    restListActivity: listHistory)));
                      },
                      child: ConsultCard(
                          name: 'น้ำตาลที่กินไป',
                          color: Colors.deepOrange.shade200,
                          title: getsugar['sugar']['sugar'].toStringAsFixed(2) + ' กรัม',
                        title2: 'น้ำตาลที่กินได้ต่อวันคงเหลือ',
                        des: sugarValue.toStringAsFixed(2) + ' กรัม',

                      ),

                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () async {
                  print(showAcitivity);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => report_static(
                                restListActivity: showAcitivity['datafood'],
                                title: 'การออกกำลังกาย',
                              )));
                },
                child: Padding(
                  padding: EdgeInsets.only(top: 24, left: 10, right: 10),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 3.5,
                    decoration: BoxDecoration(
                      color: Colors.yellow.shade400,
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(top: 5, left: 24, right: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'กิจกรรมออกกำลังกาย',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    titleActivity,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0,
                                    ),
                                  ),
                                  Text(
                                    dateActivity,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
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
                                      'เพิ่มการทำกิจกรรม',
                                      style: TextStyle(
                                          color: Colors.black87, fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 50,
                              ),
                            ],
                          ),
                          //SizedBox(width: 230),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
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
                    height: MediaQuery.of(context).size.height / 3.5,
                    decoration: BoxDecoration(
                      color: Colors.blueAccent.shade100,
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
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            titleFood,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 30.0,
                            ),
                          ),
                          Text(
                            dateFood,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
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
          print(pickedDate.toString().substring(0,4));
          timeActivityEditingController.text = pickedDate.toString().substring(0,4);

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
        if(MinutesToApi > 0 && activityName != ''){
          Api setDataToApi = await new Api();
          var setData = await setDataToApi.add_activityinput(id_user,
              formattedDate, formattedDateTime, activityName, MinutesToApi.toString());
          if (await setData["message"] == 'success') {
            //Navigator.of(context).pop();
            MaterialPageRoute materialPageRoute = MaterialPageRoute(
                builder: (BuildContext context) => Bottom_Pages());
            Navigator.of(this.context).push(materialPageRoute);
          }
        }else{
          AwesomeDialog(
            context: context,
            dialogType: DialogType.warning,
            animType: AnimType.topSlide,
            showCloseIcon: true,
            headerAnimationLoop: false,
            title: 'Warning',
            desc: 'กรุณาใส่ข้อมูลให้ครบ',
            btnOkOnPress: () {
            },
          ).show();
        }
      },
      child: Text('ตกลง'),
      style: ElevatedButton.styleFrom(
          primary: Colors.green,
          textStyle: TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}
