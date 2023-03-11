import 'package:avatar_glow/avatar_glow.dart';
import 'package:colours/colours.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

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
  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Text(
        'Speech To Text',
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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

  Widget addButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        sttText = _STTController.text;
        // mealText = sttText.toString().substring(4,8);
        // foodText = sttText.toString().substring(8,);
        print('//////////////////////////');
        print(sttText);
        print('//////////////////////////');

        MaterialPageRoute materialPageRoute = MaterialPageRoute(
            builder: (BuildContext context) => Bottom_Pages());
        Navigator.of(this.context).push(materialPageRoute);
      },
      child: Text('ตกลง'),
      style: ElevatedButton.styleFrom(
          primary: Colours.darkGreen,
          textStyle: TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}
