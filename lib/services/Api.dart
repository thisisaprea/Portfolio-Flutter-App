import 'dart:convert';
import 'package:http/http.dart' as http;

class Api {
  var path = "http://10.0.2.2:8000/";

  Api() {}

  Sign_up(email, password, firstname, lastname, birthday, job, weight, fbs, sex,
      food) async {
    print('//////////////////////////////////////////////////////////////');
    final http.Response response = await http.post(
      Uri.parse("http://10.0.2.2:8000/register/"),
      headers: <String, String>{
        "Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json',
        'Accept': '*/*'
      },
      body: jsonEncode(<String, String>{
        'firstname': await firstname,
        'lastname': await lastname,
        'birthday': await birthday,
        'job': await job,
        'weight': await weight,
        'fbs': await fbs,
        'email': await email,
        'sex': await sex,
        'password': await password,
        'food': await food,
      }),
    );
    print("API response.statusCode : ");
    print(response.statusCode);

    if (response.statusCode == 200) {
      print(jsonDecode(response.body));
      return (jsonDecode(response.body));
    } else {
      throw Exception('Failed to Sign_up.');
    }
  }
  Login(email, password, id_device) async {
    print(email);
    print(password);
    print(id_device);
    if(email.toString().isNotEmpty && password.toString().isNotEmpty){
      final http.Response response = await http.post(
        Uri.parse("http://10.0.2.2:8000/login/"),
        headers: <String, String>{
          "Access-Control-Allow-Origin": "*",
          'Content-Type': 'application/json',
          'Accept': '*/*'
        },
        body: jsonEncode(<String, String>{
          'email': await email,
          'password': await password,
          'devicelogin': await id_device,
        }),
      );
      print("222222222222222222222222222222222222222");
      if (response.statusCode == 200) {
        return (jsonDecode(response.body));

      } else {
        throw Exception('Failed to Login.');
      }
    }
  }
  send_email_verifiretion(tokenID) async {
    final http.Response response = await http.post(
      Uri.parse("http://10.0.2.2:8000/send_verdify/"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'Token': await tokenID,
      }),
    );
    if (response.statusCode == 200) {
      print(jsonDecode(response.body));
      return (jsonDecode(response.body));
    } else {
      throw Exception('Failed to Logout.');
    }
  }
  Logout(tokenID) async {
    final http.Response response = await http.post(
      Uri.parse("http://10.0.2.2:8000/logout/"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'uid': await tokenID,
      }),
    );
    if (response.statusCode == 200) {
      print(jsonDecode(response.body));
      return (jsonDecode(response.body));
    } else {
      throw Exception('Failed to Logout.');
    }
  }
  get_food() async {
    final http.Response response = await http.post(
      Uri.parse("http://10.0.2.2:8000/get_food/"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'uid': await "",
      }),

    );
    if (response.statusCode == 200) {
      List<String> listFood = [];
      var jsonFood = jsonDecode(response.body);
      for (var i = 0; i< jsonFood['datauser'].length; i++){
        listFood.add(jsonFood['datauser'][i]);

      }
      //print(jsonFood);
      //jsonFood['datauser'];
      return listFood;
      /*print(jsonDecode(response.body));
      return (jsonDecode(response.body));*/
    } else {
      throw Exception('Not Found');
    }
  }
  get_food_map() async {
    final http.Response response = await http.post(
      Uri.parse("http://10.0.2.2:8000/get_food/"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'uid': await "",
      }),

    );
    if (response.statusCode == 200) {
      var jsonFood = jsonDecode(response.body);
      print(jsonFood['datauser']);
      return (jsonFood['datauser']);
    } else {
      throw Exception('Not Found');
    }
  }
  get_activity() async {
    final http.Response response = await http.post(
      Uri.parse("http://10.0.2.2:8000/get_activity/"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'uid': await "",
      }),
    );
    if (response.statusCode == 200) {
      List<String> listActivity = [];
      var jsonFood = jsonDecode(response.body);
      for (var i = 0; i< jsonFood['datauser'].length; i++){
        listActivity.add(jsonFood['datauser'][i]);

      }
      return listActivity;
    } else {
      throw Exception('Not Found');
    }
  }
  get_contentbased(tokenID, dateFormat, meal) async {
    final http.Response response = await http.post(
      Uri.parse("http://10.0.2.2:8000/content/"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'uid': await tokenID,
        'dateformat' : await dateFormat,
        'meal' : await meal,
      }),
    );
    if (response.statusCode == 200) {
      print(jsonDecode(response.body));
      return (jsonDecode(response.body));
    } else {
      throw Exception('Not Found');
    }
  }
  get_collaboretive(tokenID, dateFormat, meal) async {
    final http.Response response = await http.post(
      Uri.parse("http://10.0.2.2:8000/collaborative/"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'uid': await tokenID,
        'dateformat' : await dateFormat,
        'meal' : await meal,
      }),
    );
    if (response.statusCode == 200) {
      print(jsonDecode(response.body));
      return (jsonDecode(response.body));
    } else {
      throw Exception('Not Found');
    }
  }
  add_foodinput(tokenID, dateFormat,datetime, menu, text,amount, meal,sugar) async {
    final http.Response response = await http.post(
      Uri.parse("http://10.0.2.2:8000/insert_food/"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'uid': await tokenID,
        'dateformat' : await dateFormat,
        'datetime' : await datetime,
        'menu' : await menu,
        'text' : await text,
        'amount' : await amount,
        'meal' : await meal,
        'insert_sugar' : await sugar,
      }),
    );
    if (response.statusCode == 200) {
      print(jsonDecode(response.body));
      return (jsonDecode(response.body));
    } else {
      throw Exception('Not Found');
    }
  }
  add_activityinput(tokenID, dateFormat,datetime, activity_name, amount_time) async {
    final http.Response response = await http.post(
      Uri.parse("http://10.0.2.2:8000/insert_activity/"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'uid': await tokenID,
        'dateformat' : await dateFormat,
        'datetime' : await datetime,
        'activity_name' : await activity_name,
        'timestamp' : await amount_time,
      }),
    );
    if (response.statusCode == 200) {
      print(jsonDecode(response.body));
      return (jsonDecode(response.body));
    } else {
      throw Exception('Not Found');
    }
  }
  get_sugar(tokenID, dateformat) async {
    final http.Response response = await http.post(
      Uri.parse("http://10.0.2.2:8000/get_sugar/"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'uid': await tokenID,
        'dateformat' : await dateformat
      }),
    );
    if (response.statusCode == 200) {
      print(jsonDecode(response.body));
      return (jsonDecode(response.body));
    } else {
      throw Exception('Not Found');
    }
  }
  show_food(tokenID, dataformat) async {
    final http.Response response = await http.post(
      Uri.parse("http://10.0.2.2:8000/show_food/"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'uid': await tokenID,
        'dateformat' : await dataformat
      }),
    );
    if (response.statusCode == 200) {
      print(jsonDecode(response.body));
      return (jsonDecode(response.body));
    } else {
      throw Exception('Not Found');
    }
  }
  show_activity(tokenID, dateformat) async {
    final http.Response response = await http.post(
      Uri.parse("http://10.0.2.2:8000/show_activity/"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'uid': await tokenID,
        'dateformat' : await dateformat
      }),
    );
    if (response.statusCode == 200) {
      print(jsonDecode(response.body));
      return (jsonDecode(response.body));
    } else {
      throw Exception('Not Found');
    }
  }
  get_history(tokenID, stringdatestart, stringdateend) async {
    final http.Response response = await http.post(
      Uri.parse("http://10.0.2.2:8000/get_history/"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'uid': await tokenID,
        'string_date_start' : await stringdatestart,
        'string_date_end' : await stringdateend
      }),
    );
    if (response.statusCode == 200) {
      print('---------------------------------');
      print(jsonDecode(response.body));
      print('---------------------------------');
      return (jsonDecode(response.body));
    } else {
      throw Exception('Not Found');
    }
  }
  resetPassword(email) async {
    print(email);
    final http.Response response = await http.post(
      Uri.parse("http://10.0.2.2:8000/resetpassword/"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': await email,
      }),
    );
    if (response.statusCode == 200) {
      print(jsonDecode(response.body));
      return (jsonDecode(response.body));
    } else {
      throw Exception('Failed.');
    }
  }
  update_user(uid, email, firstname, lastname,job,weight, fbs) async {
    final http.Response response = await http.post(
      Uri.parse("http://10.0.2.2:8000/update_datauser/"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'uid': await uid,
        'email': await email,
        'firstname': await firstname,
        'lastname': await lastname,
        'job': await job,
        'weight': await weight,
        'fbs': await fbs,
      }),
    );
    if (response.statusCode == 200) {
      print(jsonDecode(response.body));
      return (jsonDecode(response.body));
    } else {
      throw Exception('Failed.');
    }
  }
  get_user(uid) async {
    final http.Response response = await http.post(
      Uri.parse("http://10.0.2.2:8000/get_datauser/"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'uid': await uid,
      }),
    );
    if (response.statusCode == 200) {
      print(jsonDecode(response.body));
      return (jsonDecode(response.body));
    } else {
      throw Exception('Failed.');
    }
  }
}
