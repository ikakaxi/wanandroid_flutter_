import 'package:flutter/material.dart';
import 'package:wanandroid_flutter/common/toast.dart';
import 'package:wanandroid_flutter/network/networkUtil.dart';
import 'package:wanandroid_flutter/common/api.dart';
import 'package:wanandroid_flutter/common/commonUtil.dart';
import 'package:wanandroid_flutter/login/page_register.dart';
import 'package:wanandroid_flutter/common/widgetFactor.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {
  TextEditingController _accountEditingController = TextEditingController();
  TextEditingController _passwordEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("登录"),
      ),
      body: Stack(
        alignment: AlignmentDirectional.center,
        children: <Widget>[
          Positioned(
              top: 200,
              height: 260,
              width: 300,
              child: Column(
                children: <Widget>[
                  WidgetFactor.buildTextField(
                      controller: _accountEditingController,
                      hintText: "请输入账号",
                      obscureText: false),
                  Flexible(
                    flex: 1,
                    child: Container(),
                  ),
                  WidgetFactor.buildTextField(
                      controller: _passwordEditingController,
                      hintText: "请输入密码",
                      obscureText: true),
                  Flexible(
                    flex: 3,
                    child: Container(),
                  ),
                  WidgetFactor.buildButton(onPressed: _clickLoginBtn, title: "登录"),
                  Flexible(
                    flex: 1,
                    child: Container(),
                  ),
                  _buildRegisterBtn(),
                ],
              )),
        ],
      ),
    );
  }

  Widget _buildRegisterBtn() {
    return FlatButton(
        onPressed: _clickRegisterBtn,
        highlightColor:Colors.white10,
        splashColor: Colors.white10,
        textColor: Colors.grey,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("还没账号?", style: TextStyle(fontSize: 14),),
            Text("注册", style: TextStyle(fontSize: 14, color: Colors.blue),),
          ],
        )
    );
  }

  void _clickLoginBtn() {
    if (_accountEditingController.text.trim().length == 0) {
      Toast.show(context, "请先输入账号");
    } else if (_passwordEditingController.text.trim().length == 0) {
      Toast.show(context, "请先输入密码");
    } else {
      _login(_accountEditingController.text.trim(),
          _passwordEditingController.text.trim());
    }
  }

  void _login(String acount, String pwd) {
    Map<String, dynamic> param = {"username": acount, "password": pwd};
    NetWorkUtil().POST(Api.login, param, (success) {
      print(success);
      Navigator.of(context).pop();
    }, (error) {
      Toast.show(context, error);
    });
  }

  void _clickRegisterBtn() {
    CommonUtil.jumpToOtherPage(context, RegisterPage());
  }

  @override
  void dispose() {
    _accountEditingController.dispose();
    _passwordEditingController.dispose();
    super.dispose();
  }
}
