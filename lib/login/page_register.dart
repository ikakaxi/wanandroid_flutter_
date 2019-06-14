import 'package:flutter/material.dart';
import 'package:wanandroid_flutter/common/widgetFactor.dart';
import 'package:wanandroid_flutter/common/toast.dart';
import 'package:wanandroid_flutter/network/networkUtil.dart';
import 'package:wanandroid_flutter/common/api.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return RegisterPageState();
  }
}

class RegisterPageState extends State<RegisterPage> {
  TextEditingController _accountController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _repasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("注册"),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            top: 150,
            width: 300,
            height: 270,
            child: Column(
              children: <Widget>[
                WidgetFactor.buildTextField(
                    controller: _accountController, hintText: "请输入账号"),
                Flexible(
                  flex: 1,
                  child: Container(),
                ),
                WidgetFactor.buildTextField(
                    controller: _passwordController,
                    hintText: "请输入密码",
                    obscureText: true),
                Flexible(
                  flex: 1,
                  child: Container(),
                ),
                WidgetFactor.buildTextField(
                    controller: _repasswordController,
                    hintText: "请确认密码",
                    obscureText: true),
                Flexible(
                  flex: 3,
                  child: Container(),
                ),
                WidgetFactor.buildButton(
                    onPressed: _clickRegisterBtn, title: "注册"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _clickRegisterBtn() {
    if (_accountController.text.trim().length == 0) {
      Toast.show(context, "请输入账号");
    } else if (_passwordController.text.trim().length == 0) {
      Toast.show(context, "请输入密码");
    } else if (_passwordController.text.trim() != _repasswordController.text.trim()) {
      Toast.show(context, "密码不一致");
    } else {
      _register(_accountController.text.trim(), _passwordController.text.trim());
    }
  }

  void _register(String account, String password) {

    Map<String, dynamic> param = {"username":account, "password":password, "repassword":password};
    NetWorkUtil().POST(Api.register, param, (success){
      Toast.show(context, "注册成功");
      Navigator.of(context).pop();
    }, (error){
      Toast.show(context, error);
    });
  }

  @override
  void dispose() {
    _accountController.dispose();
    _passwordController.dispose();
    _repasswordController.dispose();
    super.dispose();
  }
}
