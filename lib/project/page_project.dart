import 'package:flutter/material.dart';
import 'package:wanandroid_flutter/common/api.dart';
import 'package:wanandroid_flutter/common/commonUtil.dart';
import 'package:wanandroid_flutter/network/networkUtil.dart';
import 'package:wanandroid_flutter/web/page_web.dart';

class ProjectPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => ProjectPageState();
}

class ProjectPageState extends State<ProjectPage> {

  List _typesList = [];
  List _dataList = [];
  Map _typeMap;
  int _page = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      endDrawer: _buildDrawerListView(),
      body: Container(
        child: Stack(
          children: <Widget>[
            Positioned(
              left: 0,
              top: 0,
              right: 0,
              height: 50,
              child: _buildHeader(),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: 60,
              bottom: 0,
              child: _buildListView(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {

    return Container(
      color: Colors.white,
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(15),
            child: Text("选择分类", style: TextStyle(fontSize: 16, color: Colors.black,),),
          ),
          Expanded(child: Container(),),
          Padding(
            padding: EdgeInsets.all(0),
            child: Text(null == _typeMap ? "" : _typeMap["name"], style: TextStyle(fontSize: 14, color: Colors.black54,),),
          ),
          IconButton(
            icon: Image(image: AssetImage('assets/project/menu_item.png'),),
            highlightColor: Colors.white10,
            splashColor: Colors.white10,
            onPressed: (){
              setState(() {

              });
            },
          ),
        ],
      )
    );
  }

  Widget _buildListView() {
    return ListView.separated(
      separatorBuilder: (BuildContext context, int index) {
        return Divider(
          color: Colors.black26,
          height: 10,
        );
      },
      itemCount: _dataList.length,
      itemBuilder: (BuildContext context, int position) {
        return _buildItem(_dataList[position]);
      },
    );
  }

  Widget _buildItem(Map data) {
    return Container(
        height: 250,
        color: Colors.white,
        child: InkWell(
          onTap: (){
            if (data["link"] != null) {
              CommonUtil.jumpToOtherPage(context, WebPage(loadUrl: data["link"], title: data["title"],));
            }
          },
          child: Stack(
            children: <Widget>[
              Positioned(
                top: 8,
                left: 15,
                child: Image(
                  width: 25,
                  height: 25,
                  image: AssetImage('assets/mine/header.png'),
                ),
              ),
              Positioned(
                top: 0,
                right: 15,
                child: IconButton(
                  icon: Image(image: AssetImage('assets/mine/heart.png'),),
                  onPressed: (){
                    CommonUtil.clickFavouriteBtn(context, data);
                  },
                ),
              ),
              Positioned(
                top: 12,
                left: 50,
                child: Text(data["author"], style: TextStyle(fontSize: 14),),
              ),
              Positioned(
                top: 45,
                right: 15,
                left: 15,
                height: 130,
                child: Image.network(
                  data["envelopePic"],
                  fit: BoxFit.fill,
                ),
              ),
              Positioned(
                top: 185,
                left: 15,
                right: 15,
                child: Text(data["title"], style: TextStyle(fontSize: 15),),
              ),
              Positioned(
                top: 225,
                left: 15,
                child: Text(data["niceDate"], style: TextStyle(fontSize: 13),),
              ),
            ],
          ),
        )
    );
  }

  Widget _buildDrawerListView() {
    return Drawer(
      child: ListView.separated(
        separatorBuilder: (BuildContext context, int index) {
          return Divider(
            color: Colors.black26,
            height: 1,
          );
        },
        itemCount: _typesList.length,
        itemBuilder: (BuildContext context, int position) {
          return _buildDrawerItem(_typesList[position]);
        },
      )
    );
  }

  Widget _buildDrawerItem(Map data) {
    return ListTile(
      leading: Text(data["name"]),
      onTap: (){
        _typeMap = data;
        _loadDataByType();
        Navigator.of(context).pop();
      },
    );
  }

  // network
  void _loadData() async {
    Future<dynamic>.delayed(Duration(seconds: 0), () {
      return NetWorkUtil().GET(Api.projectType, null, (success) {
        _typesList = success['data'];
        setState(() {
          _typeMap = _typesList.first;
        });
      }, (error) {
        print(error);
      });
    }).then((_){
      _loadDataByType();
    });
  }

  void _loadDataByType() async {
    print(_typeMap);
    if (null == _typeMap) return;
    String cid = _typeMap["id"].toString();
    String p = _page.toString();
    print("/project/list/$p/json?cid=$cid");
    NetWorkUtil().GET("/project/list/$p/json?cid=$cid", null, (success) {
      print(success["data"]["datas"]);
      setState(() {
        _dataList = success["data"]["datas"];
      });
    }, (error) {
      print(error);
    });
  }
}