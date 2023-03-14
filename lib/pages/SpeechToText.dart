import 'package:avatar_glow/avatar_glow.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:colours/colours.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../services/Api.dart';
import 'bottom_page.dart';

class SpeechToText extends StatefulWidget {
  const SpeechToText({Key? key}) : super(key: key);

  @override
  _SpeechToTextState createState() => _SpeechToTextState();
}

class _SpeechToTextState extends State<SpeechToText> {
  bool _isListening = false;
  late stt.SpeechToText _speech;
  String _text = 'กดปุ่มเพื่อพูดและกดปุ่มอีกครั้งเมื่อพูดเสร็จแล้ว';
  double _confidence = 1.0;
  String? mealText, foodText, CountmealText;

  TextEditingController _STTController = TextEditingController();
  TextEditingController sugarEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getdataUser();
    print(id_user);
    _speech = stt.SpeechToText();
  }

  var id_user;
  late SharedPreferences pref;

  void getdataUser() async {
    pref = await SharedPreferences.getInstance();
    var restId = await pref.getString("token");

    setState(() {
      id_user = restId;
    });
  }

  DateTime dateLast = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Row(
        children: [
          Text(
            'Speech To Text',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          SizedBox(
            width: 70,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Colors.indigo.withOpacity(0.2),
            ),
            child: desQuestionButton(),
          ),
        ],
      ),
      buttonPadding: const EdgeInsets.only(right: 24),
      elevation: 24.0,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _text,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
          ),
          micButton(),
          sugarField(),
        ],
      ),
      actions: [
        cancelButton(context),
        addButton(context),
      ],
    );
  }

  AvatarGlow micButton() {
    return AvatarGlow(
      animate: _isListening,
      glowColor: Theme.of(context).primaryColor,
      endRadius: 75.5,
      duration: Duration(milliseconds: 2000),
      repeatPauseDuration: Duration(milliseconds: 100),
      repeat: true,
      child: FloatingActionButton(
        onPressed: _listen,
        child: Icon(_isListening ? Icons.mic : Icons.mic_none),
        backgroundColor: Colours.darkGreen,
      ),
    );
  }

  var meal, food, countdish, sttText;

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('OnError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
            print(_text);
            print('---------------------');
            if (val.hasConfidenceRating && val.confidence > 0) {
              _confidence = val.confidence;
              _STTController.text = _text;
              //food = sttText.toString().substring(3,6);
              print(_STTController.text);
            }
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
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

  Widget sugarField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('ใส่ค่าน้ำตาลที่ปรุง(ถ้ามี)',
            style: TextStyle(fontWeight: FontWeight.bold)),
        TextFormField(
          autofocus: false,
          controller: sugarEditingController,
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value!.isEmpty) {
              return ("");
            }
            return null;
          },
          onSaved: (value) {
            sugarEditingController.text = value!;
          },
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            prefixIcon: Icon(LineAwesomeIcons.utensil_spoon),
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "ค่าน้ำตาลที่ปรุง(ช้อนชา)",
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }


  Widget desQuestionButton() {
    return IconButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('ตกลง'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade700,
                      textStyle: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
              backgroundColor: Colours.beige,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              title: Text(
                'คำแนะนำ',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              buttonPadding: const EdgeInsets.only(right: 24),
              elevation: 24.0,
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colours.snow,
                      ),
                      child: Column(
                        children: [
                          Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.black, //color of border
                                  width: 2, //width of border
                                ),
                              ),
                              child: Image.asset(
                                  'assets/images/speechBotton.png')),
                          Text(
                            'กดปุ่มรูปไมค์ 1 ครั้งแล้วพูด และกดปุ่มอีกครั้งเมื่อพูดเสร็จแล้ว', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),),
                          Divider(height: 20,),
                          Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.black, //color of border
                                  width: 2, //width of border
                                ),
                              ),
                              child: Image.asset('assets/images/Textspeech.png')),
                          Text('พูดในรูปแบบ มื้ออาหาร ชื่ออาหาร จำนวนอาหาร', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),),
                          Divider(height: 20,),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      icon: Icon(
        LineAwesomeIcons.question_circle,
        color: Colors.indigo.shade400,
        size: 30,
      ),
    );
  }


  Widget addButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        print(id_user);
        //sttText = _STTController.text;
        String formattedDateTime =
            DateFormat('dd/MM/yyyy H:m:s').format(dateLast);
        String formattedDate = DateFormat('ddMMyyyy').format(dateLast);
        Api setDataToApi = await new Api();
        if (_STTController.text == "") {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            animType: AnimType.topSlide,
            showCloseIcon: true,
            headerAnimationLoop: false,
            title: 'เกิดข้อผิดพลาด',
            desc:
                'กรุณาใส่\nมื้อที่กิน ชื่ออาหาร และจำนวนอาหาร(1จาน/ชิ้น ถ้วย)\nเช่น มื้อเช้า กะเพราหมูกรอบ 1 จาน',
            btnOkOnPress: () {},
            btnOkColor: Colors.yellow.shade700,
          ).show();
        } else {
          var setData = await setDataToApi.add_foodinput(
              id_user,
              formattedDate,
              formattedDateTime,
              '',
              _STTController.text,
              '',
              '',
              sugarEditingController.text);
          // mealText = sttText.toString().substring(4,8);
          // foodText = sttText.toString().substring(8,);
          print('//////////////////////////');
          print(_STTController.text);
          print(id_user);
          print('//////////////////////////');
          if (await setData["message"] == 'success') {
            print("------------------------------------------");
            ///////push to next page///
            MaterialPageRoute materialPageRoute = MaterialPageRoute(
                builder: (BuildContext context) => Bottom_Pages());
            Navigator.of(this.context).push(materialPageRoute);
          } else {
            AwesomeDialog(
              context: context,
              dialogType: DialogType.error,
              animType: AnimType.topSlide,
              showCloseIcon: true,
              headerAnimationLoop: false,
              title: 'เกิดข้อผิดพลาด',
              desc:
                  'กรุณาใส่\nมื้อที่กิน ชื่ออาหาร และจำนวนอาหาร(1จาน/ชิ้น ถ้วย)\nเช่น มื้อเช้า กะเพราหมูกรอบ 1 จาน',
              btnOkOnPress: () {},
              btnOkColor: Colors.yellow.shade700,
            ).show();
          }
          ;
        }
      },
      child: Text('ตกลง'),
      style: ElevatedButton.styleFrom(
          primary: Colours.darkGreen,
          textStyle: TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}
