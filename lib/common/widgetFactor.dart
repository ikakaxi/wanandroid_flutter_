import 'package:flutter/material.dart';

class WidgetFactor {

  static Widget buildTextField(
      {TextEditingController controller,
        String hintText,
        bool obscureText=false
      }) {
    return Container(
      padding: EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 5.0),
      alignment: Alignment.center,
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.circular(22),
      ),
      child: TextField(
        obscureText: obscureText,
        controller: controller,
        decoration: InputDecoration.collapsed(hintText: hintText),
      ),
    );
  }

  static Widget buildButton({@required VoidCallback onPressed, String title}) {
    return MaterialButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(22)),
      ),
      height: 44,
      minWidth: 300,
      color: Colors.blue,
      textColor: Colors.white,
      child: Text(title),
      onPressed: onPressed,
    );
  }
}