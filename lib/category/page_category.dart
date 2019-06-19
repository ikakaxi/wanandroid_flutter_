import 'package:flutter/material.dart';
import 'package:wanandroid_flutter/network/networkUtil.dart';
import 'package:wanandroid_flutter/common/api.dart';
import 'package:wanandroid_flutter/common/commonUtil.dart';
import 'package:wanandroid_flutter/category/page_category_Info.dart';

class CategoryPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CategoryPageState();
}

class CategoryPageState extends State<CategoryPage> {
  List dataList = [];
  List _selectItems = [];

  @override
  void initState() {
    super.initState();
    if (mounted != null) {
      getData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildListView(),
    );
  }

  Widget _buildListView() => ListView.separated(
        separatorBuilder: (BuildContext context, int index) {
          return Divider(
            height: 1,
          );
        },
        itemCount: dataList.length,
        itemBuilder: (BuildContext context, int position) {
          return _buildItem(dataList[position], position);
        },
      );

  Widget _buildItem(Map data, int position) {
    bool _selected = _selectItems.contains(position);
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: InkWell(
                    onTap: (){
                      CommonUtil.jumpToOtherPage(context, CategoryInfoPage(data["children"], 0, data["name"]),);
                    },
                    child: Text(
                      data["name"],
                      style: TextStyle(fontSize: 15, color: Colors.black),
                    ),
                  ),
                ),
              ),
              Text(
                _subTitleCount(data),
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
              IconButton(
                icon: Image.asset("assets/project/menu_item.png"),
                onPressed: () {
                  print(data);
                  setState(() {
                    if (_selected) {
                      _selectItems.remove(position);
                    } else {
                      _selectItems.add(position);
                    }
                  });
                },
              ),
            ],
          ),
          _selected ? Wrap(
            spacing: 4.0, // gap between adjacent chips
            runSpacing: 2.0, // gap between lines
            children: _buildWrapItem(data),
          ) : Container(),
        ],
      ),
    );
  }

  String _subTitleCount(Map data) {
    List list = data["children"];
    int count = list.length;
    return "$count分类";
  }

  List<Widget> _buildWrapItem(Map data, ) {
    List<Widget> itms = [];
    List list = data["children"];
    for (int i = 1; i <= list.length; i++) {
      Map dict = list[i - 1];
      itms.add(InkWell(
        onTap: () {
          print(dict);
          CommonUtil.jumpToOtherPage(context, CategoryInfoPage(list, i-1, data["name"]),);
        },
        child: Chip(
          avatar: CircleAvatar(
              backgroundColor: Colors.blue.shade900,
              child: new Text(
                '$i',
                style: TextStyle(fontSize: 10.0),
              )),
          label: Text(
            dict["name"],
          ),
        ),
      ));
    }
    return itms;
  }

  void getData() {
    NetWorkUtil().GET(Api.category, null, (success) {
      reloadData(success["data"]);
    }, (error) {
      print(error);
    });
  }

  void reloadData(List data) {
    setState(() {
      dataList = data;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
