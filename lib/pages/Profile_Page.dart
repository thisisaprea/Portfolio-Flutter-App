import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:colours/colours.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:project_final/pages/profileEdit.dart';

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
  /*Future getDataformFirebase() async {
    await FirebaseFirestore.instance
        .collection("user_info")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) async {
      if (value.exists) {
        setState(() {
          name = value.data()!["userName"];
          email = value.data()!["email"];
          FBS = value.data()!['FBS'];
          //birthday = DateTime.parse(value.data()!['birthdday']);
          job = value.data()!['job'];
          sex = value.data()!['sex'];
          fev1 = value.data()!['fevfood1'];
          fev2 = value.data()!['fevfood2'];
          fev3 = value.data()!['fevfood3'];
          fev4 = value.data()!['fevfood4'];
          fev5 = value.data()!['fevfood5'];
        });
      }
    });
  }*/
  var firsname;
  var lastname;
  var email;
  var fbs;
  late SharedPreferences pref;
  bool loading = false;
  Future getdataUser() async {
    //Api restActivity = new Api();
    pref = await SharedPreferences.getInstance();
    var restData = await pref.getString("firstname");
    var restData3 = await pref.getString("lastname");
    var restData4 = await pref.getString("email");
    var restData2 = await pref.getString("FBS");
    loading = false;
    setState(() {
      firsname = restData;
      lastname = restData3;
      email = restData4;
      fbs = restData2;
    });
  }
  void _onLoading() {
    setState(() {
      loading = true;
      new Future.delayed(new Duration(seconds: 1),getdataUser);
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
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600)),

      ),
    );
    return Scaffold(
      backgroundColor: Colours.lightGoldenRodYellow.withOpacity(0.8),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple.shade400,
        title: const Text("โปรไฟล์"),
      ),
      body: SingleChildScrollView(
        child: loading? Center(child: CircularProgressIndicator(),):
        Column(
          children: [
        Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height/2.6,
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
                      CircleAvatar(
                        backgroundImage: AssetImage('assets/images/girl.png'),
                        radius: 50,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        firsname + " " + lastname,
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      Text(
                        email,
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: 140,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: () {
                            MaterialPageRoute materialPageRoute = MaterialPageRoute(
                                builder: (BuildContext context) => ProfileEdit());
                            Navigator.of(this.context).pushReplacement(materialPageRoute);
                          },
                          child: Text(
                            'Edit Profile',
                            style: TextStyle(
                                color: Colors.white, fontWeight: FontWeight.w600),
                          ),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple.shade300,
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
                          title: 'information',
                          onPress: (){},
                          icon: LineAwesomeIcons.info,
                          endIcon: true,
                          textColor: Colors.black,
                          colorBox: Colors.deepPurple.withOpacity(0.2),
                        ),
                        Divider(),
                        SizedBox(
                          height: 10,
                        ),
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
}

class profileMenuWidget extends StatelessWidget {
  const profileMenuWidget({
    Key? key,
    required this.title,
    required this.icon,
    required this.endIcon,
    required this.onPress,
    required this.textColor,
    required this.colorBox

  });
  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;
  final Color? colorBox;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: colorBox,//Colors.deepPurple.withOpacity(0.1),
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
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600).apply(color: textColor)),
        trailing: endIcon? Container(
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
        ) : null,
      ),
    );
  }
}
