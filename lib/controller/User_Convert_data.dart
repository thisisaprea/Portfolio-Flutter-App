import 'dart:io';
import 'dart:convert';

import 'package:path_provider/path_provider.dart';

class convert_data {
  var uid;
  var email;
  var password;
  var userName;
  var firstName;
  var lastName;
  var weight;
  var FBS;
  var job;
  var sex;
  var birthday;
  var Login;
  List<String>? listFood = [];
//email, password, firstname, lastname, birthday, job, weight, fbs, sex,
// food
  convert_data(user_json) {
    email = user_json['Email'];
    password = user_json['password'];
    firstName = user_json['Firstname'];
    lastName = user_json['Lastname'];
    uid = user_json['IDUser'];
    weight = user_json['weight'];
    FBS = user_json['FBS'];
    job = user_json['job'];
    sex = user_json['sex'];
    birthday = user_json['birthday'];
    listFood = user_json['listFood'];
    Login = user_json['login'];
  }
}

class user_file {
  var uid;
  var email;
  var userName;
  var firstName;
  var lastName;
  var weight;
  var FBS;
  var job;
  var sex;
  var birthday;
  var password;
  var Login;
  List<String>? listFood = [];

  var Id_device;

  // var filepath_W = File('./lib/page/Backend/datafile/client_data.json');

  user_file() {
    // print("LLLLLLLLLLLLLLLololo");

    // print("IIIIIIIIIIIIIIIII");
  }

  getdata_user_file() async {
    var user_json = await getApplicationSupportDirectory()
        .then((Directory directory) async {
      //  print("dododo");
      Directory dir = directory;
      //  print("LLLLLLL");
      print(dir);
      File filepath_W = new File(dir.path + "/userGet_data.json");
      bool fileExists = filepath_W.existsSync();
      //  print("LLLLLLL");
      if (fileExists) {
        //    print("ggg");
        // read file

        print(filepath_W);
        var user_json = jsonDecode(filepath_W.readAsStringSync());
        print(user_json);
        //  print("JJJJJJ");
        //print(data_json['Login']);

        //   print("KKKKKKKKKKKKKKKKKKKKKKK");
        //  print("JJJJJJ");

        firstName = user_json['Firstname'];
        lastName = user_json['Lastname'];
        uid = user_json['IDUser'];
        weight = user_json['weight'];
        FBS = user_json['FBS'];
        job = user_json['job'];
        birthday = user_json['birthday'];
        email = user_json['email'];
        sex = user_json['sex'];
        password = user_json['password'];

        listFood = user_json['listFood'];

        Id_device = user_json['Use_Device'];
        // print("YYYYYYYYYYYYYYYYYY");
        // print(Email);
        print(Login);
        print(uid);
        return user_json;
      } else {
        print("HHHH");
        //  print("ddddddddddddddddddddd");
        // write file
        var user_json = {'Login': false, 'Use_Device': await Id_device};
        var user = jsonEncode(user_json);
        filepath_W.writeAsString(user);
        Login = user_json['Login'];
      }
    });


/*
    Email = data_json['Email'];
    Firstname = data_json['Firstname'];
    Lastname = data_json['Lastname'];
    IDuser = data_json['IDUser'];
    Albums_Create = data_json['Albums_Create'];
    Login = data_json['Login'];
    Password = data_json['Password'];4*/
    /*
    print(Email);
    print(Login);
    print(IDuser);
    return data_json;*/
    /*
    print("GGGGasdasdasddsadasd");
    var file =
        File('./ProjectPhotoL-main/lib/Backend/datafile/client_data.json');
    // var G = (await file.readAsString());

    var data_json = jsonDecode(file.readAsStringSync());
    print(data_json.runtimeType);
    print(data_json);
    print("HHH");

    Email = data_json['Email'];
    Firstname = data_json['Firstname'];
    Lastname = data_json['Lastname'];
    IDuser = data_json['IDuser'];
    Albums_Create = data_json['Albums_Create'];
    Login = data_json['Login'];

    // print(user.runtimeType);
    //Map<String, dynamic> userMap = jsonDecode(G);

    // print(userMap['name']);*/
    return user_json;
  }

  Future<void> usedata() async {
    //print("--------------------getdata_user_file25------------------");
    print(getApplicationDocumentsDirectory());
    // print("--------------------getdata_user_file2------------------");
    //  Email = "HHHH";
  }

  write_user_file(map_data) {
    var user = jsonEncode(map_data);

    getApplicationSupportDirectory().then((Directory directory) {
      Directory dir = directory;
      File filepath_W = new File(dir.path + "/client_data.json");
      filepath_W.writeAsString(user);
    });

    return "Write_Success";
  }
}
