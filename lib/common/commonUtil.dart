import 'package:flutter/material.dart';
import 'package:wanandroid_flutter/login/page_login.dart';

class CommonUtil {

  static void jumpToOtherPage(BuildContext context, Widget page){
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => page));
  }

  static bool isLogin(BuildContext context, bool needJumpToLogin) {
    if (needJumpToLogin) {
      jumpToOtherPage(context, LoginPage());
      return false;
    } else {
      return false;
    }
  }

}