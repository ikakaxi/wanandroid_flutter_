import 'package:flutter/material.dart';
import 'package:wanandroid_flutter/common/commonUtil.dart';

class MinePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MinePageState();
}

class MinePageState extends State<MinePage> {
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
                "点击登录",
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ],
          ),
        ));
  }

  Widget _buildItem(String title) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Row(
            children: <Widget>[
              Padding(padding: EdgeInsets.fromLTRB(15, 25, 0, 25)),
              Image(
                image: AssetImage("assets/mine/heart.png"),
              ),
              Padding(padding: EdgeInsets.only(left: 10)),
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
    );
  }
}
