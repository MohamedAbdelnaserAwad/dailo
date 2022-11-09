
import 'package:flutter/material.dart';

class Components {
  static InputDecoration textInputDecoration = const InputDecoration(
    labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
      color: Colors.blue,
      width: 2.0,
    )),
    enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
      color: Color(0xffcb4a4a),
      width: 2.0,
    )),
    errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
      color: Color(0xffb62222),
      width: 2.0,
    )),
  );

  static void nextScreen(context, page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  static void nextScreenReplace(context, page) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => page));
  }

  static void showSnackBar(context, color, message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
        style: TextStyle(fontSize: 14.0),
      ),
      backgroundColor: color,
      duration: Duration(seconds: 2),
      action: SnackBarAction(
        label: 'Ok',
        onPressed: () {},
        textColor: Colors.white,
      ),
    ));
  }
}
