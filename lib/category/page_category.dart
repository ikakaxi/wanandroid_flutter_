import 'package:flutter/material.dart';
import 'package:wanandroid_flutter/network/networkUtil.dart';
import 'package:wanandroid_flutter/common/api.dart';

class CategoryPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => CategoryPageState();
}

class CategoryPageState extends State<CategoryPage> {

  List dataList = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getListView(),
    );
  }

  getListView() => ListView.separated(
    separatorBuilder: (BuildContext context, int index) {
      return Divider(
        height: 1,
      );
    },
    itemCount: dataList.length,
    itemBuilder: (BuildContext context, int position) {
      return Container(
        height: 50,
        color: Colors.white,
        child: ListTile(
          leading: Text(dataList[position]["name"]),
          onTap: (){
            print(dataList[position]["name"]);
          },
        ),
      );
    },
  );

  void getData() {
    NetWorkUtil().GET(Api.getGongZhongHaoList, null, (success) {
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