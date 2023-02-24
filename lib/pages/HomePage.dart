import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:project_final/services/Api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/last_time.dart';
import '../widgets/ConsultationCard.dart';
import 'Profile_User.dart';
import 'history.dart';
import 'food_list.dart';
import 'history_second.dart';
import 'main_page.dart';

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
  var sugar;
  var activity;
  late SharedPreferences pref;

  void getdataActivity() async {
    Api restActivity = new Api();
    var restacivity = await restActivity.get_activity();
    setState(() {
      activity = restacivity;
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
    final activity_field = DropdownButtonFormField(
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
        contentPadding: EdgeInsets.fromLTRB(10, 15, 10, 15),
        hintText: "กิจกรรม",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        //textInputAction: TextInputAction.next,
      ),
    );

    final timeToActivity_Field = TextFormField(
        autofocus: false,
        controller: timeActivityEditingController,
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value!.isEmpty) {
            return ("กรุณาใส่ค่าน้ำตาลในเลือด");
          }
          return null;
        },
        onSaved: (value) {
          timeActivityEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.timer),
          contentPadding: EdgeInsets.fromLTRB(10, 15, 10, 15),
          hintText: "เวลาที่ออกกำลังกาย",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    return Scaffold(
      backgroundColor: Colors.green.shade100,
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
                  color: Colors.white60,
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
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  children: [
                    ConsultCard(
                        name: 'น้ำตาลที่กินได้ต่อวันคงเหลือ',
                        color: Colors.deepOrange.shade200,
                        title: '$sugar'),
                    SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: Container(
                        //width: 220,
                        height: 130,
                        decoration: BoxDecoration(
                          color: Colors.deepOrange.shade200,
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                        child: Padding(
                          padding:
                              EdgeInsets.only(top: 24, left: 24, right: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        'ค่าน้ำตาลในเลือด',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${dataFbs}' + ' mg/dl',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.0,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              OutlinedButton(
                                onPressed: () => showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                    title:
                                        Text('อัปเดตค่าน้ำตาลในเลือดปัจจุบัน'),
                                    content: Text('120'),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, 'Cancel'),
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, 'OK'),
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  ),
                                ),
                                style: ButtonStyle(
                                  foregroundColor:
                                      MaterialStateProperty.all(Colors.white),
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.white38),
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(20),
                                      ),
                                    ),
                                  ),
                                ),
                                child: Text(
                                  'อัปเดต',
                                  style: TextStyle(
                                      color: Colors.black87, fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => report_static()));
                },
                child: Padding(
                  padding: EdgeInsets.only(top: 24, left: 10, right: 10),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 5,
                    decoration: BoxDecoration(
                      color: Colors.green.shade600,
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
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    '${activityEditingController.text}',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  OutlinedButton(
                                    onPressed: () => showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                        title: Text('กิจกรรม'),
                                        content: Container(
                                          width: double.infinity,
                                          height: 125,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                activity_field,
                                                SizedBox(
                                                  height: 15,
                                                ),
                                                timeToActivity_Field,
                                              ],
                                            ),
                                          ),
                                        ),
                                        actions: [
                                          activitySaveButton(context),

                                          TextButton(
                                            onPressed: () => Navigator.pop(
                                                context, 'Cancel'),
                                            child: const Text('Cancel'),
                                          ),
                                        ],
                                      ),
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
                                width: 10,
                              ),
                              Text(
                                '${timeActivityEditingController.text}',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 30.0,
                                    fontWeight: FontWeight.bold),
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
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => report_static()));
                },
                child: Padding(
                  padding: EdgeInsets.only(top: 24, left: 10, right: 10),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 5,
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
                            'มื้อเย็น สุกี้หมูแห้ง 1 จาน',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 30.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ItemList(),
                      ));
                },
                child: Padding(
                  padding:
                      EdgeInsets.only(top: 24, left: 10, right: 10, bottom: 25),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 8,
                    decoration: BoxDecoration(
                      color: Colors.yellow.shade100,
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(top: 1, left: 20, right: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'ไข่เจียวหมูสับ',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget activitySaveButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async{
        String formattedDateTime = DateFormat('dd/MM/yyyy H:m:s').format(dateTime);
        String formattedDate = DateFormat('ddMMyyyy').format(dateTime);
        final activityName = activityEditingController.text;
        final activityTime = timeActivityEditingController.text;
        print('id $id_user');
        print('activity $activityName');
        print('timeAc $activityTime');
        print('timeDate Event $formattedDateTime');
        print('timeDate Event Format $formattedDate');
        Api setDataToApi = await new Api();
        var setData = await setDataToApi.add_activityinput(id_user, formattedDate, formattedDateTime, activityName, activityTime);
        if(await setData["message"] == 'success'){
          sugar = await setDataToApi.get_sugar(id_user, formattedDate);
          print('น้ำตาล ${sugar['sugar']['sugar']}');
          //Navigator.of(context).pop();
          Navigator.pop(context, 'OK');
        } //เค้ก
      },
      child: const Text('OK'),);
  }

}
