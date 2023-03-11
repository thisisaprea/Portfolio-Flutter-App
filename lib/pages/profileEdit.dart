import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:project_final/pages/bottom_page.dart';

class ProfileEdit extends StatefulWidget {
  const ProfileEdit({Key? key}) : super(key: key);

  @override
  _ProfileEditState createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  @override
  Widget build(BuildContext context) {
    final saveEditButton = SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: () => AwesomeDialog(
          context: context,
          dialogType: DialogType.warning,
          animType: AnimType.topSlide,
          showCloseIcon: true,
          headerAnimationLoop: false,
          title: 'บันทึกการแก้ไข',
          desc: 'ต้องการบันทึกข้อมูลหรือไม่?',
          btnCancelOnPress: () {},
          btnCancelText: 'No',
          btnOkColor: Colors.green.shade300,
          btnCancelColor: Colors.red.shade300,
          btnOkOnPress: () {
            MaterialPageRoute materialPageRoute = MaterialPageRoute(
                builder: (BuildContext context) => Bottom_Pages());
            Navigator.of(this.context).push(materialPageRoute);
          },
          btnOkText: 'Yes',
        ).show(),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.amber.shade600,
          side: BorderSide.none,
          shape: StadiumBorder(),
        ),
        child: Text(
          "บันทึก",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        backgroundColor: Colors.amber.shade500,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            children: [
              Form(
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        label: Text('First name'),
                        prefixIcon: Icon(Icons.person_2_rounded),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        label: Text('First name'),
                        prefixIcon: Icon(Icons.person_2_rounded),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        label: Text('First name'),
                        prefixIcon: Icon(Icons.person_2_rounded),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        label: Text('First name'),
                        prefixIcon: Icon(Icons.person_2_rounded),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        label: Text('First name'),
                        prefixIcon: Icon(Icons.person_2_rounded),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        label: Text('First name'),
                        prefixIcon: Icon(Icons.person_2_rounded),
                      ),
                    ),
                    SizedBox(
                      height: 24,
                    ),
                  ],
                ),
              ),
              saveEditButton,
              /*SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    saveEditButton;
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber.shade600,
                    side: BorderSide.none,
                    shape: StadiumBorder(),
                  ),
                  child: Text(
                    "บันทึก",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),*/
            ],
          ),
        ),
      ),
    );
  }
}
