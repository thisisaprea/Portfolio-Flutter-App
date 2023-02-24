class UserModel {
  String? uid;
  String? email;
  String? userName;
  String? weight;
  String? FBS;
  String? occupation;
  String? sex;
  String? birthday;
  String? listFood;
  String? Id_device;
  String? token;
  String? height;
  String? age;
  String? statusLogin;

  /* String? favfood1 = '';
  String? favfood2 = '';
  String? favfood3 = '';
  String? favfood4 = '';
  String? favfood5 = '';*/

  UserModel(
      {this.uid,
      this.email,
      this.userName,
      this.weight,
      this.FBS,
      this.occupation,
      this.sex,
      this.birthday,
      this.listFood,
      this.Id_device,
      this.token,
      this.height,
      this.age,
      this.statusLogin
      /*this.favfood1, this.favfood2, this.favfood3, this.favfood4, this.favfood5*/
      });

  // receiving data from server
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['userid'],
      email: map['email'],
      userName: map['userName'],
      FBS: map['FBS'],
      weight: map['weight'],
      occupation: map['job'],
      sex: map['sex'],
      birthday: map['birthday'],
      listFood: map['food'],
      Id_device: map['iddevice'],
      token: map['token'],
      height: map['height'],
      age: map['age'],
      statusLogin: map['statusLogin']
      //Id_device = map['deviceLogin'];
      /*favfood1: map['favfood1'],
        favfood2: map['favfood2'],
        favfood3: map['favfood3'],
        favfood4: map['favfood4'],
        favfood5: map['favfood5'],*/
    );
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'userid': uid,
      'email': email,
      'userName': userName,
      'FBS': FBS,
      'weight': weight,
      'job': occupation,
      'sex': sex,
      'birthday': birthday,
      'food': listFood,
      'token': token,
      'height': height,
      'age': age,
      'statusLogin': statusLogin
      //'id_device': Id_device
      /*'favfood1': favfood1,
          'favfood2': favfood2,
          'favfood3': favfood3,
          'favfood4': favfood4,
          'favfood5': favfood5,*/
    };
  }
}
