import 'package:flutter/material.dart';
import 'package:wanandroid_flutter/login/page_login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommonUtil {

  static void storeUserInfo(String username, String password, int id) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("username", username);
    prefs.setString("password", password);
    prefs.setInt("id", id);
    prefs.setBool("isLogin", true);
  }

  static void removeUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("username");
    prefs.remove("username");
    prefs.remove("isLogin");
    prefs.remove("id");
  }

  static Future<String> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("username");
  }

  static void jumpToOtherPage(BuildContext context, Widget page){
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => page));
  }

  static Future<bool> isLogin(BuildContext context, bool needJumpToLogin) async {
    final prefs = await SharedPreferences.getInstance();
    bool isLogin = (prefs.getBool("isLogin") != null)&&prefs.getBool("isLogin");
    if (!isLogin && needJumpToLogin) {
      jumpToOtherPage(context, LoginPage());
    }
    return isLogin;
  }

  static Future clickFavouriteBtn(BuildContext context,Map data) async {
    bool isLogin = await CommonUtil.isLogin(context, true);
    if (isLogin){

    }
  }

}