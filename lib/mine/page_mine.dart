import 'package:flutter/material.dart';
import 'package:wanandroid_flutter/common/api.dart';
import 'package:wanandroid_flutter/common/commonUtil.dart';
import 'package:wanandroid_flutter/network/networkUtil.dart';

class MinePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MinePageState();
}

class MinePageState extends State<MinePage> {
  String _headerTitle = "点击登录";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    reloadHeader();
  }

  void reloadHeader() async {
    String headerTitle = await CommonUtil.getUsername();
    setState(() {
      _headerTitle = headerTitle == null ? _headerTitle : headerTitle;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: <Widget>[
        _buildHeaderWidget(),
        Padding(
          padding: EdgeInsets.only(top: 20),
        ),
        _buildItem("我的收藏"),
        _buildItem("关于软件"),
        _buildItem("退出登录"),
      ],
    );
  }

  Widget _buildHeaderWidget() {
    return Container(
      height: 100,
      color: Colors.white,
      padding: EdgeInsets.all(15),
      child: InkWell(
        onTap: () {
          CommonUtil.isLogin(context, true);
        },
        child: Row(
          children: <Widget>[
            Image(
              image: AssetImage('assets/mine/header.png'),
            ),
            Padding(padding: EdgeInsets.only(left: 10)),
            Text(
              _headerTitle,
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(String title) {
    return Container(
      color: Colors.white,
      child: InkWell(
        onTap: (){
          if (title == "退出登录"){
            logout();
          }
        },
        child: Column(
          children: [
            Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(15, 12, 10, 12),
                  child: Image(
                    image: AssetImage("assets/mine/heart.png"),
                  ),
                ),
                Text(
                  title,
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ],
            ),
            Divider(
              height: 1,
              color: Colors.black12,
            ),
          ],
        ),
      ),
    );
  }

  void logout() async {
    bool isLogin = await CommonUtil.isLogin(context, false);
    if(isLogin){
      CommonUtil.removeUserInfo();
      NetWorkUtil().GET(Api.logout, null, null, null);
      setState(() {
        _headerTitle = "点击登录";
      });
    }
  }
}
