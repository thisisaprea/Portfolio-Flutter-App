import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controller/check_User.dart';
import '../widgets/alrert_dialog.dart';
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
  void getdataUser() async{
    //Api restActivity = new Api();
    pref = await SharedPreferences.getInstance();
    var restData = await pref.getString("firstname");
    var restData3 = await pref.getString("lastname");
    var restData4 = await pref.getString("email");
    var restData2 = await pref.getString("FBS");
    setState(() {
      firsname = restData;
      lastname = restData3;
      email = restData4;
      fbs = restData2;
    });
  }
  @override
  void initState(){
    super.initState();
    getdataUser();
  }

  @override
  Widget build(BuildContext context) {
    final logoutButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.red.shade300,
      child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () async{
            check_user checkuse = new check_user();
            await checkuse.logout();
            MaterialPageRoute materialPageRoute = MaterialPageRoute(
                builder: (BuildContext context) => login_page());
            Navigator.of(this.context).push(materialPageRoute);
          },
          child: Text(
            "ออกจากระบบ",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple.shade400,
        title: const Text("โปรไฟล์"),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/images/girl.png'),
                    radius: 100,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Welcome",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
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
                            Text('${firsname}'),
                            Text('${lastname}'),
                            Text('${email}'),
                          ],
                        ),
                      ),
                    ),
                  ),
                  logoutButton
                ],
              ),
              SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ),
    );

  }


}
