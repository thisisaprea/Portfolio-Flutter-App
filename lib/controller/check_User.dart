
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/Api.dart';
import 'User_Convert_data.dart';

class check_user {
  var id_device = "";

  Api use_api = new Api();

  signup(email, password, firstname, lastname, birthday, job, weight, fbs, sex, food) async {
    print("-----------------------------------------------------------");
    var signin = await use_api.Sign_up(email, password, firstname, lastname, birthday, job, weight, fbs, sex,
        food);

    return await signin;
  }

  login(email, password) async {
    user_file userdata_file = await new user_file();
    await userdata_file.getdata_user_file();
    var id_device = await userdata_file.Id_device;
    if (await id_device == null) {
      Random r = new Random();

      var iddevice = String.fromCharCode(r.nextInt(26) + 65) +
          String.fromCharCode(r.nextInt(26) + 65);

      for (int i = 0; i < 10; ++i) {
        var num = r.nextInt(10);

        iddevice += num.toStringAsFixed(0);
      }
      id_device = await iddevice;
    }
    print("--------------------------ID-----------------------");
    print(id_device);
    print("--------------------------ID-----------------------");

    //var id_device = "Phone1";
    var login = await use_api.Login(email, password, id_device);
    // print("DDDDDDDDDD");
    //print(login);
    // print("DDDDDDDDDDD");

    var message = await login['message'];
    var datauser = await login['tokenID'];

    if (await message == 'Login success') {
      await userdata_file.write_user_file(datauser);

      //userdata_file.getdata_user_file();
    }
    //user_file userfile = new user_file();
    print(
        " -------------------------- Login success --------------------------");
    print(login['message']);
    return await login;
  }

  logout() async {
    print("ssssss");
    SharedPreferences pref = await SharedPreferences.getInstance();
    var token = await pref.getString("token");
    Api checkuse = new Api();
    await checkuse.Logout(token);
    await pref.clear();


    return "Logout success";
  }
//android:name="io.flutter.embedding.android.NormalTheme"@style/NormalTheme
}